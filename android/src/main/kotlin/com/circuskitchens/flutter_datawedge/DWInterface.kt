package com.circuskitchens.flutter_datawedge


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import com.circuskitchens.flutter_datawedge.pigeon.*


enum class DWCommand(val cmd: String) {
    CreateProfile("com.symbol.datawedge.api.CREATE_PROFILE"),
    SetConfig("com.symbol.datawedge.api.SET_CONFIG")
}

enum class DWEvent(val value: String ) {
    ResultAction("com.symbol.datawedge.api.RESULT_ACTION"),
    Action("com.symbol.datawedge.api.ACTION"),
    ResultNotification("com.symbol.datawedge.api.NOTIFICATION_ACTION")

}

class DWInterface(val context: Context) : BroadcastReceiver(), DataWedgeHostApi {

    // Registers a broadcast receive that listens to datawedge intents
    fun setupBroadcastReceiver(){
        val intentFilter = IntentFilter()
        intentFilter.addAction(context.packageName + ".SCAN_EVENT")
        intentFilter.addAction(DWEvent.ResultAction.value)
        intentFilter.addAction(DWEvent.Action.value)
        intentFilter.addAction(DWEvent.ResultNotification.value)
        intentFilter.addCategory(Intent.CATEGORY_DEFAULT)
        context.registerReceiver(this, intentFilter)
    }


    // A map that contains the callbacks that are associated to the command identifier
    val callbacks = HashMap<String,(Error?,Bundle?) -> Unit>()


    companion object {



        // DataWedge Extras
        const val EXTRA_GET_VERSION_INFO = "com.symbol.datawedge.api.GET_VERSION_INFO"

        const val EXTRA_KEY_APPLICATION_NAME = "com.symbol.datawedge.api.APPLICATION_NAME"
        const val EXTRA_KEY_NOTIFICATION_TYPE = "com.symbol.datawedge.api.NOTIFICATION_TYPE"
        const val EXTRA_RESULT_NOTIFICATION = "com.symbol.datawedge.api.NOTIFICATION"
        const val EXTRA_REGISTER_NOTIFICATION = "com.symbol.datawedge.api.REGISTER_FOR_NOTIFICATION"

        const val EXTRA_RESULT_NOTIFICATION_TYPE = "NOTIFICATION_TYPE"
        const val EXTRA_KEY_VALUE_SCANNER_STATUS = "SCANNER_STATUS"
        const val EXTRA_KEY_VALUE_PROFILE_SWITCH = "PROFILE_SWITCH"
        const val EXTRA_KEY_VALUE_PROFILE_ENABLED = "PROFILE_ENABLED"
        const val EXTRA_KEY_VALUE_CONFIGURATION_UPDATE = "CONFIGURATION_UPDATE"
        const val EXTRA_KEY_VALUE_NOTIFICATION_STATUS = "STATUS"
        const val EXTRA_KEY_VALUE_NOTIFICATION_PROFILE_NAME = "PROFILE_NAME"
        const val EXTRA_SEND_RESULT = "SEND_RESULT"

        const val EXTRA_RESULT = "RESULT"
        const val EXTRA_RESULT_GET_ACTIVE_PROFILE =
            "com.symbol.datawedge.api.RESULT_GET_ACTIVE_PROFILE"
        const val EXTRA_RESULT_GET_PROFILES_LIST =
            "com.symbol.datawedge.api.RESULT_GET_PROFILES_LIST"
        const val EXTRA_RESULT_INFO = "RESULT_INFO"
        const val EXTRA_COMMAND = "COMMAND"
        const val EXTRA_COMMAND_IDENTIFIER = "COMMAND_IDENTIFIER"

        // DataWedge Actions




        const val ACTION_SET_CONFIG = "com.symbol.datawedge.api.SET_CONFIG"

        const val DATAWEDGE_SCAN_EXTRA_SOURCE = "com.symbol.datawedge.source"
        const val DATAWEDGE_SCAN_EXTRA_DATA_STRING = "com.symbol.datawedge.data_string"
        const val DATAWEDGE_SCAN_EXTRA_LABEL_TYPE = "com.symbol.datawedge.label_type"

    }


    fun intentToString(intent: Intent?): String? {
        if (intent == null) return ""
        val stringBuilder = StringBuilder("action: ")
            .append(intent.action)
            .append(" data: ")
            .append(intent.dataString)
            .append(" extras: ")
        for (key in intent.extras!!.keySet()) stringBuilder.append(key).append("=").append(
            intent.extras!![key]
        ).append(" ")
        return stringBuilder.toString()
    }
    // Called whenever an intent is passed to the broadcast receiver


    override fun onReceive(p0: Context?, intent: Intent?) {

        if(intent == null){
            return
        }

        val action = intent.action
        val b = intent.extras

        Log.d("DWInterface",action.toString())

        when (action) {
            (DWEvent.ResultAction.value)  -> {
                // Some cmd returned
                Log.d("DWInterface","Command returned")
                val result = intent.getStringExtra(DWInterface.EXTRA_RESULT) ?: ""
                Log.d("DWInterface",intentToString(intent) ?: "No data in intent")

                val command = intent.getStringExtra(DWInterface.EXTRA_COMMAND) ?: ""

                val commandIdentifier= intent.getStringExtra(DWInterface.EXTRA_COMMAND_IDENTIFIER) ?: ""

                // Callback the function we have stored in our hashmap
                if(callbacks.containsKey(commandIdentifier)){
                    callbacks[commandIdentifier]?.let { it(null,intent.extras) }
                    // Remove the pending command as it is resolved now
                    callbacks.remove(commandIdentifier)
                }else{
                    Log.d("DWInterface","Unknown command was returned")
                }

            }
        }


    }

    // Clear all callbacks to prevent holding unresolvable references and unregister the broadcast receiver
    fun dispose(){
        for (callback in callbacks) {
            callback.value(Error("DataWedge interface was disposed"),null)
        }

        context.unregisterReceiver(this)
    }


    // from https://stackoverflow.com/questions/46943860/idiomatic-way-to-generate-a-random-alphanumeric-string-in-kotlin
    private fun getRandomString(length: Int) : String {
        val allowedChars = ('A'..'Z') + ('a'..'z') + ('0'..'9')
        return (1..length)
            .map { allowedChars.random() }
            .joinToString("")
    }

    fun sendCommandString(
        command: DWCommand,
        parameter: String,
        callback: (Error?,Bundle?) -> Unit
    ) {
        sendCommand(command,parameter, callback)
    }

    fun sendCommandBundle(

        command: DWCommand,
        parameter: Bundle,
        callback: ( Error?,Bundle?) -> Unit
    ) {
        sendCommand(command,parameter, callback)
    }

    private fun sendCommand(command: DWCommand, parameter: Any, callback: ( Error?, Bundle?) -> Unit){
        // Generate a random command identifier
        val commandIdentifier = getRandomString(10)
        // Keep a reference to the callback by the command id
        callbacks[commandIdentifier] = callback

        val dwIntent = Intent()
        dwIntent.action = DWEvent.Action.value


        // This is certainly not elegant... not sure how this could be done more elegantly
        if(parameter is String) {
            dwIntent.putExtra(command.cmd,parameter)
        }else if(parameter is Bundle) {
            dwIntent.putExtra(command.cmd,parameter)
        }else{
            callback(Error("Unsupported payload type"),null)
            return
        }

        dwIntent.putExtra(EXTRA_SEND_RESULT, "true")
        dwIntent.putExtra(EXTRA_COMMAND_IDENTIFIER, commandIdentifier)

        context.sendBroadcast(dwIntent)

    }


    private fun printBundle( bundle: Bundle, indent: Int): String {

        val builder = java.lang.StringBuilder()

        bundle.keySet().forEach { key ->
            builder.append(" ".repeat(indent * 4))
            builder.append(key)
            builder.append(": ")

            val value = bundle.get(key)

            if (value is String || value is Boolean) {
                builder.append(value)
            } else if (value is Bundle) {
                builder.append("\n")
                builder.append(printBundle(value, indent + 1))
            }

            builder.append("\n")


        }

        return builder.toString()

    }


    override fun createProfile(
        profileName: String,
        callback: (kotlin.Result<CreateProfileResponse>) -> Unit
    ) {
        sendCommand(DWCommand.CreateProfile,profileName) { error, result ->
            if (error != null) {
                callback(Result.failure(error))
            }else{
                callback(Result.success(CreateProfileResponse(CreateProfileResponseType.PROFILECREATED)))
            }
        }


    }

    override fun getPackageIdentifer(): String {
        return context.applicationInfo.packageName
    }


    override fun listenScannerStatus(callback: (Result<Unit>) -> Unit) {
        TODO("Not yet implemented")
    }


    override fun setProfileConfig(config: ProfileConfig, callback: (kotlin.Result<Unit>) -> Unit) {
        // We somehow need to convert the profile config to a bundle...

        val configBundle = Bundle()

        configBundle.putString("PROFILE_NAME",config.profileName)
        configBundle.putString("PROFILE_ENABLED", config.profileEnabled.toString())
        configBundle.putString("CONFIG_MODE",  when (config.configMode){
            ConfigMode.CREATEIFNOTEXISTS -> "CREATE_IF_NOT_EXIST"
            ConfigMode.UPDATE -> "UPDATE"
            ConfigMode.OVERWRITE -> "OVERWRITE"
        })

        if(config.appList != null) {
            // Apps that this profile is relevant for
            configBundle.putParcelableArray("APP_LIST", config.appList.map { appEntry ->
                val app = Bundle()
                if (appEntry != null) {
                    app.putString("PACKAGE_NAME", appEntry.packageName)
                    app.putStringArray(
                        "ACTIVITY_LIST",
                        appEntry.activityList.map { e -> e!! }.toTypedArray()
                    )
                }
                app
            }.toTypedArray())
        }


        // Barcode parameters
        if(config.barcodeParamters != null){
            val bConfig = Bundle()
            val params = config.barcodeParamters;
            bConfig.putString("PLUGIN_NAME","BARCODE")

            val bParams = Bundle()

            if(params.scannerSelection != null){
                bParams.putString("scanner_selection_by_identifier", when (params.scannerSelection){
                    ScannerIdentifer.AUTO -> "AUTO"
                    ScannerIdentifer.INTERNALIMAGER -> "INTERNAL_IMAGER"
                    ScannerIdentifer.INTERNALLASER -> "INTERNAL_LASER"
                    ScannerIdentifer.INTERNALCAMERA -> "INTERNAL_CAMERA"
                    ScannerIdentifer.SERIALSSI -> "SERIAL_SSI"
                    ScannerIdentifer.BLUETOOTHSSI -> "BLUETOOTH_SSI"
                    ScannerIdentifer.BLUETOOTHRS6000 -> "BLUETOOTH_RS6000"
                    ScannerIdentifer.BLUETOOTHDS2278 -> "BLUETOOTH_DS2278"
                    ScannerIdentifer.BLUETOOTHDS3678 -> "BLUETOOTH_DS3678"
                    ScannerIdentifer.PLUGABLESSI -> "PLUGABLE_SSI"
                    ScannerIdentifer.PLUGABLESSIRS5000 -> "PLUGABLE_SSI_RS5000"
                    ScannerIdentifer.USBSSIDS3608 -> "USB_SSI_DS3608"
                    ScannerIdentifer.BLUETOOTHZEBRA -> "BLUETOOTH_ZEBRA"
                    ScannerIdentifer.USBZEBRA ->"USB_ZEBRA"
                })
            }

            intentBool(bParams,"configure_all_scanners",params.configureAllScanners)

            // UPC EAN Parameters below in order of documentation

            intentBool(bParams,"databar_to_upc_ean",params.dataBarToUpcEan)
            intentBool(bParams,"upcean_linear_decode",params.upcEeanLinearDecode)
            intentNr(bParams,"upcean_security_level",params.upcEanSecurityLevel.toInt())
            intentBool(bParams,"upcean_supplemental2",params.upcEanSupplemental2)
            intentBool(bParams,"upcean_supplemental5",params.upcEanSupplemental5)

            if(params.upcEanSupplementalMode != null){
                bParams.putString("upcean_supplemental_mode",when (params.upcEanSupplementalMode) {
                    UpcSupplementalMode.NONE -> "0"
                    UpcSupplementalMode.ALWAYS -> "1"
                    UpcSupplementalMode.AUTO -> "2"
                    UpcSupplementalMode.SMART -> "3"
                    UpcSupplementalMode.SUPPLEMENTAL378TO379 -> "4"
                    UpcSupplementalMode.SUPPLEMENTAL978TO979 -> "5"
                    UpcSupplementalMode.SUPPLEMENTAL414TO419AND434TO439 -> "6"
                    UpcSupplementalMode.SUPPLEMENTAL977 -> "7"

                })
            }

            intentNr(bParams,"upcean_retry_count",params.upcEanRetryCount.toInt())

            intentBool(bParams,"upcean_linear_decode",params.upcEeanLinearDecode)
            intentBool(bParams,"upcean_bookland",params.upcEanBookland)
            intentBool(bParams,"upcean_coupon",params.upcEanCoupon)

            if(params.upcEanCouponReport != null){
                bParams.putString("upcean_coupon_report",when (params.upcEanCouponReport) {
                    UpcEanCouponReport.OLDMODE -> "0"
                    UpcEanCouponReport.NEWMODE -> "1"
                    UpcEanCouponReport.BOTH -> "2"
                })
            }

            intentBool(bParams,"upcean_ean_zero_extend",params.upcEanZeroExtend)

            if(params.upceanBooklandFormat != null){
                bParams.putString("upcean_bookland_format",when (params.upceanBooklandFormat) {
                    UpcEanBooklandFormat.ISBN10 -> "0"
                    UpcEanBooklandFormat.ISBN13 -> "13"
                })
            }


            // NextGen SimulScan Parameters
            if(params.scanningMode != null){
                bParams.putString("scanning_mode",when (params.scanningMode) {
                    ScanningMode.SINGLE -> ""
                    ScanningMode.DOCUMENTCAPTURE -> "5"
                    ScanningMode.UDI -> ""
                    ScanningMode.MULTIBARCODE -> "3"
                })
            }

            intentString(bParams,"doc_capture_template",params.docCaptureTemplate)

            intentNr(bParams,"common_barcode_dynamic_quantity",params.commonBarcodeDynamicQuantity)

            // Barcode Highlighting parameters

            intentBool(bParams,"barcode_highlighting_enabled",params.barcodeHighlightingEnabled)
            intentString(bParams,"rule_name",params.ruleName)
            // Todo critera for highlighting

            // UDI parameters

            intentBool(bParams,"enable_udi_gs1",params.enableUdiGs1)
            intentBool(bParams,"enable_udi_hibcc",params.enableUdiHibcc)
            intentBool(bParams,"enable_udi_iccbba",params.enableUdiIccbba)

            // OCR Parameters

            if(params.ocrOrientation != null){
                bParams.putString("ocr_orientation",when (params.ocrOrientation) {
                  OcrOrientation.DEGREE_0 -> "0"
                    OcrOrientation.DEGREE_270 -> "1"
                    OcrOrientation.DEGREE_180 -> "2"
                    OcrOrientation.DEGREE_90 -> "3"
                    OcrOrientation.OMNIDIRECTIONAL -> "4"
                })
            }

            intentNr(bParams,"ocr_lines",params.ocrLines?.toInt())

            intentNr(bParams,"ocr_min_chars",params.ocrMinChars?.toInt())
            intentNr(bParams,"ocr_max_chars",params.ocrMaxChars?.toInt())

            intentString(bParams,"ocr_subset",params.ocrSubset)
            intentNr(bParams,"ocr_quiet_zone",params.ocrQuietZone)






            if(params.configureAllScanners != null){
                bParams.putString("configure_all_scanners", params.configureAllScanners.toString())
            }



            bConfig.putBundle("PARAM_LIST",bParams)

            configBundle.putBundle("PLUGIN_CONFIG",bConfig)

        }






        Log.d("DWInterface",printBundle(configBundle,0))

        sendCommand(DWCommand.SetConfig,configBundle) { err, _ ->
            if (err != null) {
                callback(Result.failure(err))
            } else {
                callback(Result.success(Unit))
            }
        }


    }

    fun intentString(bundle: Bundle, key:String, input: String?){
        if(input != null){
            bundle.putString(key,input)
        }
    }

    fun intentNr(bundle: Bundle, key: String, input: Int?){

        if(input != null){
            bundle.putString(key,input.toString())
        }

    }


    fun intentBool(bundle: Bundle,key: String ,input: Boolean?) {
        if(input != null){
            bundle.putString(key,input.toString())
        }
    }


}
