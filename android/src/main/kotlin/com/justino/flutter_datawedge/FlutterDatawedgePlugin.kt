package com.justino.flutter_datawedge

import android.content.Context
import android.content.IntentFilter
import android.os.Bundle
import androidx.annotation.NonNull
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
  private val commandChannel = "com.justino.flutter_datawedge/command"
  private val scanChannel = "com.justino.flutter_datawedge/scan"
  private val profileIntentAction = "com.justino.flutter_datawedge.SCAN"
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
    intentFilter.addAction(profileIntentAction)
    intentFilter.addAction(DWInterface.DATAWEDGE_RETURN_ACTION)
    intentFilter.addCategory(DWInterface.DATAWEDGE_RETURN_CATEGORY)

    scanEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, scanChannel)
    scanEventChannel.setStreamHandler(this)

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

  override fun onListen(arguments: Any?, events: EventSink?) {
    val receiver = SinkBroadcastReceiver(events)
    registeredReceivers.add(receiver)
    context.registerReceiver(receiver, intentFilter )
  }

  override fun onCancel(arguments: Any?) {

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
    appConfig.putString("PACKAGE_NAME", context.packageName)      //  Associate the profile with this app
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

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    for (receiver in registeredReceivers) {
      context.unregisterReceiver(receiver)
    }
    commandMethodChannel.setMethodCallHandler(null)
    scanEventChannel.setStreamHandler(null)
  }

}
