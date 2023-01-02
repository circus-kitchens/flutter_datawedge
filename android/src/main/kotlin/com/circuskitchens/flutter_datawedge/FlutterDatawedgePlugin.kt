package com.circuskitchens.flutter_datawedge

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import com.circuskitchens.flutter_datawedge.consts.MyChannels
import com.circuskitchens.flutter_datawedge.consts.MyIntents
import com.circuskitchens.flutter_datawedge.consts.MyMethods
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

class FlutterDatawedgePlugin: FlutterPlugin, MethodCallHandler, StreamHandler {

  private val profileIntentBroadcast = "2"

  private lateinit var scanEventChannel: EventChannel

  private lateinit var commandMethodChannel: MethodChannel

  /**
   * Used to save BroadcastReceiver to be able unregister them.
   */
  private val registeredReceivers: ArrayList<SinkBroadcastReceiver> = ArrayList()

  private val dwInterface = DWInterface()

  private lateinit var context: Context

  private lateinit var intentFilter: IntentFilter

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    context = flutterPluginBinding.applicationContext

    intentFilter = IntentFilter()
    intentFilter.addAction(context.packageName + MyIntents.SCAN_EVENT_INTENT_ACTION)
    intentFilter.addAction(DWInterface.ACTION_RESULT)
    intentFilter.addAction(DWInterface.ACTION_RESULT_NOTIFICATION)
    intentFilter.addCategory(Intent.CATEGORY_DEFAULT)

    scanEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, MyChannels.scanChannel)
    scanEventChannel.setStreamHandler(this)

    commandMethodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, MyChannels.commandChannel)
    commandMethodChannel.setMethodCallHandler(this)

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when (call.method) {
      MyMethods.getPlatformVersion -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      MyMethods.sendDataWedgeCommandStringParameter -> {
        val arguments = JSONObject(call.arguments.toString())
        val command: String = arguments.get("command") as String
        val parameter: String = arguments.get("parameter") as String
        dwInterface.sendCommandString(context, command, parameter)
        //  result.success(0);  //  DataWedge does not return responses
      }
      MyMethods.createDataWedgeProfile -> {
        createDataWedgeProfile(call.arguments.toString())
      }
      MyMethods.listenScannerStatus -> {
        listenScannerStatus()
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onListen(arguments: Any?, events: EventSink?) {
    val receiver = SinkBroadcastReceiver(events)
    registeredReceivers.add(receiver)
    context.registerReceiver(receiver, intentFilter )
  }

  override fun onCancel(arguments: Any?) {

  }

  private fun createDataWedgeProfile(profileName: String) {


    //https://techdocs.zebra.com/datawedge/latest/guide/api/createprofile/
    dwInterface.sendCommandString(context, DWInterface.EXTRA_CREATE_PROFILE, profileName)
    val profileConfig = Bundle()
    profileConfig.putString(DWInterface.EXTRA_KEY_VALUE_NOTIFICATION_PROFILE_NAME, profileName)
    profileConfig.putString("PROFILE_ENABLED", "true") //  These are all strings
    profileConfig.putString("CONFIG_MODE", "UPDATE")

    val barcodeConfig = Bundle()
    barcodeConfig.putString("PLUGIN_NAME", "BARCODE")
    //  This is the default but never hurts to specify
    barcodeConfig.putString("RESET_CONFIG", "true")

    val barcodeProps = Bundle()
    barcodeConfig.putBundle("PARAM_LIST", barcodeProps)
    profileConfig.putBundle("PLUGIN_CONFIG", barcodeConfig)

    val appConfig = Bundle()
    //  Associate the profile with this app
    appConfig.putString("PACKAGE_NAME", context.packageName)
    appConfig.putStringArray("ACTIVITY_LIST", arrayOf("*"))
    profileConfig.putParcelableArray("APP_LIST", arrayOf(appConfig))

    dwInterface.sendCommandBundle(context, DWInterface.ACTION_SET_CONFIG, profileConfig)
    //  You can only configure one plugin at a time in some versions of DW, now do the intent output
    profileConfig.remove("PLUGIN_CONFIG")

    val intentConfig = Bundle()
    intentConfig.putString("PLUGIN_NAME", "INTENT")
    intentConfig.putString("RESET_CONFIG", "true")

    val intentProps = Bundle()
    intentProps.putString("intent_output_enabled", "true")
    intentProps.putString("intent_action", context.packageName + MyIntents.SCAN_EVENT_INTENT_ACTION)
    intentProps.putString("intent_delivery", profileIntentBroadcast)  //  "2"
    intentConfig.putBundle("PARAM_LIST", intentProps)
    profileConfig.putBundle("PLUGIN_CONFIG", intentConfig)

    dwInterface.sendCommandBundle(context, DWInterface.ACTION_SET_CONFIG, profileConfig)
  }

  private fun listenScannerStatus(){
    //https://techdocs.zebra.com/datawedge/latest/guide/api/registerfornotification
    val b = Bundle()
    b.putString(DWInterface.EXTRA_KEY_APPLICATION_NAME, context.packageName)
    b.putString(DWInterface.EXTRA_KEY_NOTIFICATION_TYPE, DWInterface.EXTRA_KEY_VALUE_SCANNER_STATUS)

    //https://techdocs.zebra.com/datawedge/latest/guide/api/setconfig/
    dwInterface.sendCommandBundle(context, DWInterface.EXTRA_REGISTER_NOTIFICATION, b)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    for (receiver in registeredReceivers) {
      context.unregisterReceiver(receiver)
    }
    commandMethodChannel.setMethodCallHandler(null)
    scanEventChannel.setStreamHandler(null)
  }

}
