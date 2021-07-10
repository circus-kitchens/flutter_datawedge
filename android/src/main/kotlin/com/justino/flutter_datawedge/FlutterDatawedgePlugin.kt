package com.justino.flutter_datawedge

import android.content.BroadcastReceiver
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

class FlutterDatawedgePlugin: FlutterActivity(), FlutterPlugin, MethodCallHandler {
  private val commandChannel = "com.justino.flutter_datawedge/command"
  private val scanChannel = "com.justino.flutter_datawedge/scan"
  private val profileIntentAction = "com.justino.flutter_datawedge.SCAN"
  private val profileIntentBroadcast = "2"

  private lateinit var scanEventChannel: EventChannel
  //private lateinit var eventStreamHandler: StreamHandler
  private lateinit var commandMethodChannel: MethodChannel

  //private var dataWedgeBroadcastReceiver: BroadcastReceiver? = null

  private val dwInterface = DWInterface()

  private lateinit var context: Context

  /**
   * Used to save BroadcastReceiver to be able unregister them.
   */
  private val registeredReceivers: ArrayList<BroadcastReceiver> = ArrayList()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    context = flutterPluginBinding.applicationContext

    scanEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, scanChannel)
    scanEventChannel.setStreamHandler(
      object : StreamHandler {
        private var dataWedgeBroadcastReceiver: BroadcastReceiver? = null

        override fun onListen(arguments: Any?, events: EventSink?) {

          dataWedgeBroadcastReceiver = createDataWedgeBroadcastReceiver(events)

          val intentFilter = IntentFilter()
          intentFilter.addAction(profileIntentAction)
          intentFilter.addAction(DWInterface.DATAWEDGE_RETURN_ACTION)
          intentFilter.addCategory(DWInterface.DATAWEDGE_RETURN_CATEGORY)

          registeredReceivers.add(dataWedgeBroadcastReceiver!!)

          flutterPluginBinding.applicationContext.registerReceiver(
              dataWedgeBroadcastReceiver,
              intentFilter
          )

        }

        override fun onCancel(arguments: Any?) {
          flutterPluginBinding.applicationContext.unregisterReceiver(dataWedgeBroadcastReceiver)
          dataWedgeBroadcastReceiver = null
        }
      }
    )

    //scanEventChannel.setStreamHandler(this)

    commandMethodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, commandChannel)
    commandMethodChannel.setMethodCallHandler(this)

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "sendDataWedgeCommandStringParameter" -> {
        val arguments = JSONObject(call.arguments.toString())
        val command: String = arguments.get("command") as String
        val parameter: String = arguments.get("parameter") as String
        dwInterface.sendCommandString(context, command, parameter)
        //  result.success(0);  //  DataWedge does not return responses
      }
      "createDataWedgeProfile" -> {
        createDataWedgeProfile(call.arguments.toString())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    commandMethodChannel.setMethodCallHandler(null)
    scanEventChannel.setStreamHandler(null)
  }

  private fun createDataWedgeBroadcastReceiver(events: EventSink?): BroadcastReceiver {

    return object : BroadcastReceiver() {
      override fun onReceive(context: Context, intent: Intent) {

        Log.d(TAG, "onReceive: $intent.action")
          if (intent.action.equals(profileIntentAction)){
          //  A barcode has been scanned
          val scanData = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_DATA_STRING) ?: ""
          val symbology = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_LABEL_TYPE) ?: ""
          val date = Calendar.getInstance().time
          val df = SimpleDateFormat("dd/MM/yyyy HH:mm:ss", Locale.US)
          val dateTimeString = df.format(date)

          Log.d(TAG, "scanData: $scanData")

          val currentScan =  Scan(scanData, symbology, dateTimeString)
          events?.success(currentScan.toJson())
        }
        //  Could handle return values from DW here such as RETURN_GET_ACTIVE_PROFILE
        //  or RETURN_ENUMERATE_SCANNERS
      }
    }
  }

  private fun createDataWedgeProfile(profileName: String) {
    //  Create and configure the DataWedge profile associated with this application
    //  For readability's sake, I have not defined each of the keys in the DWInterface file
    dwInterface.sendCommandString(context, DWInterface.DATAWEDGE_SEND_CREATE_PROFILE, profileName)
    val profileConfig = Bundle()
    profileConfig.putString("PROFILE_NAME", profileName)
    profileConfig.putString("PROFILE_ENABLED", "true") //  These are all strings
    profileConfig.putString("CONFIG_MODE", "UPDATE")
    val barcodeConfig = Bundle()
    barcodeConfig.putString("PLUGIN_NAME", "BARCODE")
    barcodeConfig.putString("RESET_CONFIG", "true") //  This is the default but never hurts to specify
    val barcodeProps = Bundle()
    barcodeConfig.putBundle("PARAM_LIST", barcodeProps)
    profileConfig.putBundle("PLUGIN_CONFIG", barcodeConfig)
    val appConfig = Bundle()
    appConfig.putString("PACKAGE_NAME", "com.justino.flutter_datawedge")      //  Associate the profile with this app
    appConfig.putStringArray("ACTIVITY_LIST", arrayOf("*"))
    profileConfig.putParcelableArray("APP_LIST", arrayOf(appConfig))
    dwInterface.sendCommandBundle(context, DWInterface.DATAWEDGE_SEND_SET_CONFIG, profileConfig)
    //  You can only configure one plugin at a time in some versions of DW, now do the intent output
    profileConfig.remove("PLUGIN_CONFIG")
    val intentConfig = Bundle()
    intentConfig.putString("PLUGIN_NAME", "INTENT")
    intentConfig.putString("RESET_CONFIG", "true")
    val intentProps = Bundle()
    intentProps.putString("intent_output_enabled", "true")
    intentProps.putString("intent_action", profileIntentAction)
    intentProps.putString("intent_delivery", profileIntentBroadcast)  //  "2"
    intentConfig.putBundle("PARAM_LIST", intentProps)
    profileConfig.putBundle("PLUGIN_CONFIG", intentConfig)
    dwInterface.sendCommandBundle(context, DWInterface.DATAWEDGE_SEND_SET_CONFIG, profileConfig)
  }

  /*override fun onListen(arguments: Any?, events: EventSink?) {
    dataWedgeBroadcastReceiver = createDataWedgeBroadcastReceiver(events)
    val intentFilter = IntentFilter()
    intentFilter.addAction(profileIntentAction)
    intentFilter.addAction(DWInterface.DATAWEDGE_RETURN_ACTION)
    intentFilter.addCategory(DWInterface.DATAWEDGE_RETURN_CATEGORY)
    registerReceiver(dataWedgeBroadcastReceiver, intentFilter)
  }*/

  /*override fun onCancel(arguments: Any?) {
    unregisterReceiver(dataWedgeBroadcastReceiver)
    dataWedgeBroadcastReceiver = null
  }*/

}
