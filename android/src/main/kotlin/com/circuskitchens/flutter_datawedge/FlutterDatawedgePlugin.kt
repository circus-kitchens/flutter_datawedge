package com.circuskitchens.flutter_datawedge

import android.annotation.SuppressLint
import android.content.Context
import android.content.Context.RECEIVER_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.Build
import com.circuskitchens.flutter_datawedge.consts.MyChannels
import com.circuskitchens.flutter_datawedge.consts.MyIntents
import src.main.kotlin.com.circuskitchens.flutter_datawedge.consts.MyMethods
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONObject

class FlutterDatawedgePlugin : FlutterPlugin, MethodCallHandler, StreamHandler {

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

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        context = flutterPluginBinding.applicationContext

        intentFilter = IntentFilter()
        intentFilter.addAction(context.packageName + MyIntents.SCAN_EVENT_INTENT_ACTION)
        intentFilter.addAction(DWInterface.ACTION_RESULT)
        intentFilter.addAction(DWInterface.ACTION_DATAWEDGE)
        intentFilter.addAction(DWInterface.ACTION_RESULT_NOTIFICATION)
        intentFilter.addCategory(Intent.CATEGORY_DEFAULT)

        scanEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, MyChannels.scanChannel)
        scanEventChannel.setStreamHandler(this)

        commandMethodChannel =
            MethodChannel(flutterPluginBinding.binaryMessenger, MyChannels.commandChannel)
        commandMethodChannel.setMethodCallHandler(this)

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {
            MyMethods.sendDataWedgeCommandStringParameter -> {
                val arguments = JSONObject(call.arguments.toString())
                val command: String = arguments.get("command") as String
                val parameter: String = arguments.get("parameter") as String
                val commandIdentifier: String = arguments.get("commandIdentifier") as String
                dwInterface.sendCommandString(context, command, parameter, commandIdentifier)
                result.success(null)  //  DataWedge does not return responses
            }

            MyMethods.createDataWedgeProfile -> {
                val arguments = JSONObject(call.arguments.toString())
                val name: String = arguments.get("name") as String
                val commandIdentifier: String = arguments.get("commandIdentifier") as String
                createDataWedgeProfile(name, commandIdentifier)
                result.success(null)  //  DataWedge does not return responses
            }

            MyMethods.updateDataWedgeProfile -> {
                val arguments = JSONObject(call.arguments.toString())
                val profileName: String = arguments.get("profileName") as String
                val pluginName: String = arguments.get("pluginName") as String
                val commandIdentifier: String = arguments.get("commandIdentifier") as String

                val configJson: JSONObject = arguments.getJSONObject("config")
                val config = mutableMapOf<String, Any>()

                for (key in configJson.keys()) {
                    config[key] = configJson.get(key)
                }

                updateProfilePluginConfig(
                    profileName,
                    pluginName,
                    config.toMap(),
                    commandIdentifier
                )

                result.success(null)  //  DataWedge does not return responses
            }

            MyMethods.listenScannerStatus -> {
                val arguments = JSONObject(call.arguments.toString())
                val commandIdentifier: String = arguments.get("commandIdentifier") as String
                listenScannerStatus(commandIdentifier)
                result.success(null)  //  DataWedge does not return responses
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    override fun onListen(arguments: Any?, events: EventSink?) {
        val receiver = SinkBroadcastReceiver(events)
        registeredReceivers.add(receiver)
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU){
            context.registerReceiver(receiver, intentFilter, RECEIVER_EXPORTED)
        }else{
           context.registerReceiver(receiver, intentFilter)
        }
    }

    override fun onCancel(arguments: Any?) {

    }

    private fun createDataWedgeProfile(profileName: String, commandIdentifier: String) {
        //https://techdocs.zebra.com/datawedge/latest/guide/api/createprofile/
        dwInterface.sendCommandString(
            context,
            DWInterface.EXTRA_CREATE_PROFILE,
            profileName,
            "createProfile_$commandIdentifier"
        )

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

        // https://techdocs.zebra.com/datawedge/latest/guide/api/setconfig/
        dwInterface.sendCommandBundle(
            context,
            DWInterface.ACTION_SET_CONFIG,
            profileConfig,
            "profileConfig_$commandIdentifier"
        )

        /// You can only configure one plugin at a time in some versions of DW, now do the intent output
        profileConfig.remove("PLUGIN_CONFIG")

        val intentConfig = Bundle()
        intentConfig.putString("PLUGIN_NAME", "INTENT")
        intentConfig.putString("RESET_CONFIG", "true")

        val intentProps = Bundle()
        intentProps.putString("intent_output_enabled", "true")
        intentProps.putString(
            "intent_action", context.packageName + MyIntents.SCAN_EVENT_INTENT_ACTION
        )
        intentProps.putString("intent_delivery", profileIntentBroadcast)  //  "2"
        intentConfig.putBundle("PARAM_LIST", intentProps)
        profileConfig.putBundle("PLUGIN_CONFIG", intentConfig)

        // https://techdocs.zebra.com/datawedge/latest/guide/api/setconfig/
        dwInterface.sendCommandBundle(
            context,
            DWInterface.ACTION_SET_CONFIG,
            profileConfig,
            "intentOutputConfig_$commandIdentifier"
        )

    }

    private fun updateProfilePluginConfig(
        profileName: String,
        pluginName: String,
        config: Map<String, Any>,
        commandIdentifier: String,
    ) {
        val profileConfig = Bundle()
        profileConfig.putString(DWInterface.EXTRA_KEY_VALUE_NOTIFICATION_PROFILE_NAME, profileName)
        profileConfig.putString("CONFIG_MODE", "UPDATE")

        val pluginConfig = Bundle()
        pluginConfig.putString("PLUGIN_NAME", pluginName.uppercase())
        pluginConfig.putString("RESET_CONFIG", "false")

        val paramBundle = Bundle()

        for ((key, value) in config) {
            when (value) {
                is String -> paramBundle.putString(key, value)
                //bool value is always passed as string
                is Boolean -> paramBundle.putString(key, value.toString())
                is Double -> paramBundle.putDouble(key, value)
                is Int -> paramBundle.putInt(key, value)
            }
        }

        pluginConfig.putBundle("PARAM_LIST", paramBundle)
        profileConfig.putBundle("PLUGIN_CONFIG", pluginConfig)

        dwInterface.sendCommandBundle(
            context,
            DWInterface.ACTION_SET_CONFIG,
            profileConfig,
            "profileConfigUpdate_$commandIdentifier"
        )
    }


    private fun listenScannerStatus(commandIdentifier: String) {
        //https://techdocs.zebra.com/datawedge/latest/guide/api/registerfornotification
        val b = Bundle()
        b.putString(DWInterface.EXTRA_KEY_APPLICATION_NAME, context.packageName)
        b.putString(
            DWInterface.EXTRA_KEY_NOTIFICATION_TYPE, DWInterface.EXTRA_KEY_VALUE_SCANNER_STATUS
        )

        //https://techdocs.zebra.com/datawedge/latest/guide/api/setconfig/
        dwInterface.sendCommandBundle(
            context,
            DWInterface.EXTRA_REGISTER_NOTIFICATION,
            b,
            "listenScannerStatus_$commandIdentifier"
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        for (receiver in registeredReceivers) {
            context.unregisterReceiver(receiver)
        }
        commandMethodChannel.setMethodCallHandler(null)
        scanEventChannel.setStreamHandler(null)
    }

}
