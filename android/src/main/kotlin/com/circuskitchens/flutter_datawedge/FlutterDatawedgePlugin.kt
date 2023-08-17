package com.circuskitchens.flutter_datawedge



import android.content.Context
import android.content.IntentFilter
import android.os.Build.*
import android.os.Build.VERSION_CODES.*
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.circuskitchens.flutter_datawedge.pigeon.DataWedgeFlutterApi
import com.circuskitchens.flutter_datawedge.pigeon.DataWedgeHostApi
import io.flutter.embedding.engine.plugins.FlutterPlugin

class FlutterDatawedgePlugin : FlutterPlugin {

    private val profileIntentBroadcast = "2"


    
    private var flutter: FlutterPlugin.FlutterPluginBinding? = null
    private var flutterApi: DataWedgeFlutterApi? = null
    private var dwInterface: DWInterface? = null

    private lateinit var intentFilter: IntentFilter

    @RequiresApi(LOLLIPOP)
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("FlutterDataWedgeFlugin","Attaching to engine...")
        val api = DataWedgeFlutterApi(flutterPluginBinding.binaryMessenger)
        dwInterface = DWInterface(flutterPluginBinding.applicationContext,api)
        flutterApi = api
        DataWedgeHostApi.setUp(flutterPluginBinding.binaryMessenger,dwInterface)
        dwInterface?.setupBroadcastReceiver()
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        dwInterface?.dispose()
        DataWedgeHostApi.setUp(binding.binaryMessenger,null)
        flutterApi = null
    }


/*
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            MyMethods.getPlatformVersion -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            MyMethods.sendDataWedgeCommandStringParameter -> {
                val arguments = JSONObject(call.arguments.toString())
                val command: String = arguments.get("command") as String
                val parameter: String = arguments.get("parameter") as String
                val commandIdentifier: String = arguments.get("commandIdentifier") as String
                dwInterface.sendCommandString(context, command, parameter, commandIdentifier)
                result.success(null);  //  DataWedge does not return responses
            }
            MyMethods.createDataWedgeProfile -> {
                val arguments = JSONObject(call.arguments.toString())
                val name: String = arguments.get("name") as String
                val commandIdentifier: String = arguments.get("commandIdentifier") as String
                createDataWedgeProfile(name, commandIdentifier)
                result.success(null);  //  DataWedge does not return responses
            }
            MyMethods.listenScannerStatus -> {
                val arguments = JSONObject(call.arguments.toString())
                val commandIdentifier: String = arguments.get("commandIdentifier") as String
                listenScannerStatus(commandIdentifier)
                result.success(null);  //  DataWedge does not return responses
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        val receiver = SinkBroadcastReceiver(events)
        registeredReceivers.add(receiver)
        context.registerReceiver(receiver, intentFilter)
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
            "intent_action",
            context.packageName + MyIntents.SCAN_EVENT_INTENT_ACTION
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


    private fun listenScannerStatus(commandIdentifier: String) {
        //https://techdocs.zebra.com/datawedge/latest/guide/api/registerfornotification
        val b = Bundle()
        b.putString(DWInterface.EXTRA_KEY_APPLICATION_NAME, context.packageName)
        b.putString(
            DWInterface.EXTRA_KEY_NOTIFICATION_TYPE,
            DWInterface.EXTRA_KEY_VALUE_SCANNER_STATUS
        )

        //https://techdocs.zebra.com/datawedge/latest/guide/api/setconfig/
        dwInterface.sendCommandBundle(
            context,
            DWInterface.EXTRA_REGISTER_NOTIFICATION,
            b,
            "listenScannerStatus_$commandIdentifier"
        )
    }*/


}
