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
        const val EXTRA_SOFT_SCAN_TRIGGER = "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER"
        const val EXTRA_RESULT_NOTIFICATION = "com.symbol.datawedge.api.NOTIFICATION"
        const val EXTRA_REGISTER_NOTIFICATION = "com.symbol.datawedge.api.REGISTER_FOR_NOTIFICATION"
        const val EXTRA_UNREGISTER_NOTIFICATION =
            "com.symbol.datawedge.api.UNREGISTER_FOR_NOTIFICATION"

        const val EXTRA_RESULT_NOTIFICATION_TYPE = "NOTIFICATION_TYPE"
        const val EXTRA_KEY_VALUE_SCANNER_STATUS = "SCANNER_STATUS"
        const val EXTRA_KEY_VALUE_PROFILE_SWITCH = "PROFILE_SWITCH"
        const val EXTRA_KEY_VALUE_CONFIGURATION_UPDATE = "CONFIGURATION_UPDATE"
        const val EXTRA_KEY_VALUE_NOTIFICATION_STATUS = "STATUS"
        const val EXTRA_KEY_VALUE_NOTIFICATION_PROFILE_NAME = "PROFILE_NAME"
        const val EXTRA_SEND_RESULT = "SEND_RESULT"

        const val EXTRA_EMPTY = ""

        const val EXTRA_RESULT_GET_VERSION_INFO = "com.symbol.datawedge.api.RESULT_GET_VERSION_INFO"
        const val EXTRA_RESULT = "RESULT"
        const val EXTRA_RESULT_INFO = "RESULT_INFO"
        const val EXTRA_COMMAND = "COMMAND"
        const val EXTRA_COMMAND_IDENTIFIER = "COMMAND_IDENTIFIER"

        // DataWedge Actions




        const val ACTION_GET_SCANNER_STATUS = "com.symbol.datawedge.api.GET_SCANNER_STATUS"
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
            intentNr(bParams,"upcean_security_level",params.upcEanSecurityLevel?.toInt())
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

            intentNr(bParams,"upcean_retry_count",params.upcEanRetryCount?.toInt())

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
                    ScanningMode.SINGLE -> "1"
                    ScanningMode.DOCUMENTCAPTURE -> "5"
                    ScanningMode.UDI -> "2"
                    ScanningMode.MULTIBARCODE -> "3"
                })
            }

            intentString(bParams,"doc_capture_template",params.docCaptureTemplate)

            intentNr(bParams,"common_barcode_dynamic_quantity",params.commonBarcodeDynamicQuantity?.toInt())

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
            intentNr(bParams,"ocr_quiet_zone",params.ocrQuietZone?.toInt())

            intentNr(bParams,"ocr_check_digit_modulus",params.ocrCheckDigitModulus?.toInt())

            intentNr(bParams,"ocr_check_digit_multiplier",params.ocrCheckDigitMultiplier?.toInt())

            intentNr(bParams,"ocr_check_digit_validation",params.ocrCheckDigitValidation?.toInt())

            if(params.inverseOcr != null){
                bParams.putString("inverse_ocr",when (params.inverseOcr) {
                    InverseOcr.REGULAR -> "0"
                   InverseOcr.INVERSE -> "1"
                    InverseOcr.AUTO -> "2"

                })
            }

            // Other scanner parameters
            if(params.presentationModeSensitivity != null) {
                bParams.putString("presentation_mode_sensitivity",when (params.presentationModeSensitivity) {
                    PresentationModeSensitivity.LOW -> "80"
                    PresentationModeSensitivity.MEDIUM -> "120"
                    PresentationModeSensitivity.HIGH -> "160"
                })
            }


            intentBoolToNr(bParams,"barcode_trigger_mode",params.enableHardwareTrigger)

            if(params.autoSwitchToDefaultOnEvent != null){

                bParams.putString("auto_switch_to_default_on_event",when (params.autoSwitchToDefaultOnEvent) {
                    SwitchOnEvent.CONNECTORDISCONNECT -> "3"
                    SwitchOnEvent.DISABLED -> "0"
                    SwitchOnEvent.ONCONNECT -> "1"
                    SwitchOnEvent.ONDISCONNECT -> "2"
                })


            }

            intentBool(bParams,"digimarc_decoding",params.digimarcDecoding)

            // scaning mode see above

            intentNr(bParams,"multi_barcode_count",params.multiBarcodeCount?.toInt())

            intentBool(bParams,"instant_reporting_enable",params.enableInstantReporting)
            intentBool(bParams,"report_decoded_barcodes",params.reportDecodedBarcodes)


            if(params.scannerTriggerResource != null){
                bParams.putString("scanner_trigger_resource",when (params.scannerTriggerResource) {
                    TriggerSource.CENTER -> "CENTER"
                    TriggerSource.LEFT -> "LEFT"
                    TriggerSource.RIGHT ->"RIGHT"
                    TriggerSource.GUN -> "GUN"
                    TriggerSource.PROXIMITY -> "PROXIMITY"
                    TriggerSource.KEYMAPPERSCAN -> "KEY_MAPPER_SCAN"
                    TriggerSource.KEYMAPPERL1 -> "KEY_MAPPER_L1"
                    TriggerSource.KEYMAPPERR1 -> "KEY_MAPPER_R1"
                    TriggerSource.WIREDLEFT -> "WIRED_LEFT"
                    TriggerSource.WIREDRIGHT -> "WIRED_RIGHT"
                })
            }

            // why is this hypen case...?
            intentBool(bParams,"trigger-wakeup",params.triggerWakeupScan)
            intentBool(bParams,"scanner_input_enabled",params.scannerInputEnabled)

            // why not a boolean...?
            if(params.enableAimMode != null){
                if(params.enableAimMode){
                    bParams.putString("aim_mode","on")
                }else{
                    bParams.putString("aim_mode","off")
                }
            }

            intentNr(bParams,"beam_timer",params.beamTimer?.toInt())

            // why is this uppercase...?
            intentBoolToNr(bParams,"Adaptive_Scanning",params.enableAdaptiveScanning)


            if(params.beamWidth != null){
                bParams.putString("Beam_Width",when (params.beamWidth) {
                   BeamWidth.NARROW -> "0"
                    BeamWidth.NORMAL -> "1"
                    BeamWidth.WIDE -> "2"
                })
            }


            if(params.powerMode != null){
                bParams.putString("power_mode",when (params.powerMode) {
                    PowerMode.LOW -> "0"
                    PowerMode.OPTIMIZED -> "1"
                    PowerMode.HIGH -> "2"
                    PowerMode.ALWAYSON -> "3"

                })
            }

            if(params.mpdMode != null){
                bParams.putString("mpd_mode",when (params.mpdMode) {
                    MpdMode.DISPLAY_OFF -> "0"
                    MpdMode.DISPLAY_ON -> "3"
                })
            }

            if(params.readerMode != null) {
                bParams.putString("reader_mode",when (params.readerMode) {
                    ReaderMode.PRESENTATION -> "7"
                    ReaderMode.TRIGGERED -> "0"
                })
            }

            intentNr(bParams,"linear_security_level",params.linearSecurityLevel?.toInt())


            if(params.picklist != null) {
                bParams.putString("picklist",when (params.picklist) {
                   PicklistMode.DISABLED -> "0"
                    PicklistMode.HARDWARE -> "1"
                    PicklistMode.SOFTWARE -> "2"
                })
            }

            if(params.aimType != null) {
                bParams.putString("aim_type",when (params.aimType) {
                    AimType.TRIGGER -> "0"
                    AimType.TIMEDHOLD -> "1"
                    AimType.TIMEDRELEASE -> "2"
                    AimType.PRESSANDRELEASE -> "3"
                    AimType.PRESENTATION -> "4"
                    AimType.CONTINOUSREAD -> "5"
                    AimType.PRESSANDSUSTAIN -> "6"
                    AimType.PRESSANDCONTINUE -> "7"
                    AimType.TIMEDCONTINOUS -> "8"
                })
            }

            if(params.sceneDetectQualifier != null){
                bParams.putString("scene_detect_qualifier",when (params.sceneDetectQualifier) {
                    SceneDetectQualifier.NONE -> "0"
                    SceneDetectQualifier.PROXIMITYSENSOR  -> "1"
                })
            }

            intentNr(bParams,"aim_timer",params.aimTimer?.toInt())
            intentNr(bParams,"same_barcode_timeout",params.sameBarcodeTimeout?.toInt())
            intentBool(bParams,"trigger_wakeup_scan",params.triggerWakeupScan)
            intentNr(bParams,"different_barcode_timeout",params.differentBarcodeTimeout?.toInt())

            if(params.illuminationMode != null ){
                bParams.putString("illumination_mode",when (params.illuminationMode) {
                    IlluminationMode.OFF -> "off"
                    IlluminationMode.TORCH -> "torch"
                })
            }


            intentNr(bParams,"illumination_brightness",params.illuminationBrightness?.toInt())

            if(params.lcdMode != null){
                bParams.putString("lcd_mode",when (params.lcdMode) {
                    LcdMode.DISABLED -> "0"
                    LcdMode.ENABLED -> "3"
                })
            }

            intentNr(bParams,"low_power_timeout",params.lowPowerTimeout?.toInt())

            // This is the weirdest parameter ever
            if(params.delayToLowPowerMode != null){
                bParams.putString("delay_to_low_power_mode",when (params.delayToLowPowerMode) {
                    DelayToLowPowerMode.MINUTES_1 -> "32"
                    DelayToLowPowerMode.MINUTES_5 -> "37"
                    DelayToLowPowerMode.SECONDS_1 -> "16"
                    DelayToLowPowerMode.SECONDS_30 -> "29"
                })
            }


            if(params.inverse1dMode != null) {
                bParams.putString("inverse_1d_mode",when (params.inverse1dMode) {
                    Inverse1dMode.DISABLE -> "0"
                    Inverse1dMode.ENABLE -> "1"
                    Inverse1dMode.AUTO -> "2"

                })
            }


            intentNr(bParams,"viewfinder_size",params.viewFinderSize?.toInt())
            intentNr(bParams,"viewfinder_posx",params.viewFinderPosX?.toInt())
            intentNr(bParams,"viewfinder_posy",params.viewFinderPosY?.toInt())


            if(params.marginlessEffortLevel1d != null){
                bParams.putString("1d_marginless_decode_effort_level",when (params.marginlessEffortLevel1d) {
                    EffortLevel.LEVEL_0 -> "0"
                    EffortLevel.LEVEL_1 -> "1"
                    EffortLevel.LEVEL_2 -> "2"
                    EffortLevel.LEVEL_3 -> "3"


                })
            }


            if(params.poorQualityBcDecodeEffortLevel != null){
                bParams.putString("poor_quality_bcdecode_effort_level",when (params.poorQualityBcDecodeEffortLevel) {
                    EffortLevel.LEVEL_0 -> "0"
                    EffortLevel.LEVEL_1 -> "1"
                    EffortLevel.LEVEL_2 -> "2"
                    EffortLevel.LEVEL_3 -> "3"
                })
            }

            if(params.charsetName != null ){
                bParams.putString("charset_name",when (params.charsetName) {
                    Charset.AUTO -> "AUTO"
                    Charset.UTF8 -> "UTF-8"
                    Charset.ISO88591 -> "ISO-8859-1"
                    Charset.SHIFTJIS -> "Shift_JIS"
                    Charset.GB18030 -> "GB18030"
                    Charset.NONE -> throw Error("Can not use none charset here")

                })
            }

            if(params.autoCharsetPrefferedOrder != null){
                bParams.putString("auto_charset_preferred_order",params.autoCharsetPrefferedOrder.joinToString(separator = ";"))
            }



            if(params.autoCharsetFallback != null ){
                bParams.putString("auto_charset_failure_option",when (params.charsetName) {
                    Charset.AUTO -> throw Error("Can not use auto charset here")
                    Charset.UTF8 -> "UTF-8"
                    Charset.ISO88591 -> "ISO-8859-1"
                    Charset.SHIFTJIS -> "Shift_JIS"
                    Charset.GB18030 -> "GB18030"
                    Charset.NONE -> "NONE"
                })
            }

            if(params.viewFinderMode != null ){
                bParams.putString("viewfinder_mode",when (params.viewFinderMode) {
                    ViewFinderMode.ENABLED -> "1"
                    ViewFinderMode.STATICRETICLE -> "2"
                })
            }

            if(params.codeIdType != null){
                bParams.putString("code_id_type",when (params.codeIdType) {
                    CodeIdType.NONE -> "0"
                    CodeIdType.AIM -> "1"
                    CodeIdType.SYMBOL -> "2"
                })
            }

            if(params.volumeSliderType != null){
                bParams.putString("volume_slider_type",when (params.volumeSliderType) {
                    VolumeSliderType.RINGER -> "0"
                    VolumeSliderType.MUSICMEDIA -> "1"
                    VolumeSliderType.ALARMS -> "2"
                    VolumeSliderType.NOTIFICATION -> "3"
                })
            }

            intentString(bParams,"decode_audio_feedback_uri",params.decodeAudioFeedbackUri)

            intentBool(bParams,"decode_haptic_feedback",params.decodeHapticFeedback)

            intentBool(bParams,"bt_disconnect_on_exit",params.btDisconnectOnExit)


            intentNr(bParams,"connection_idle_time",params.connectionIdleTime?.toInt())
            intentNr(bParams,"establish_connection_time",params.establishConnectionTime?.toInt())

            intentNr(bParams,"remote_scanner_audio_feedback_mode",params.remoteScannerAudioFeedbackMode?.toInt())
            intentNr(bParams,"remote_scanner_led_feedback_mode",params.remoteScannerLedFeedbackMode?.toInt())

            intentBool(bParams,"display_bt_address_barcode",params.displayBtAddressBarcode)

            intentNr(bParams,"good_decode_led_timer",params.goodDecodeLedTimer?.toInt())

            intentBool(bParams,"decoding_led_feedback",params.decodingLedFeedback)


            intentBool(bParams,"decoder_usplanet_report_check_digit",params.decoderUsPlanetReportCheckDigit)

            intentBool(bParams,"decode_screen_notification",params.decodeScreenNotification)


            intentNr(bParams,"decode_screen_time",params.decodeScreenTime?.toInt())
            intentNr(bParams,"decode_screen_translucency",params.decodeScreenTranslucency?.toInt())


            intentBoolToNr(bParams,"keep_pairing_info_after_reboot",params.keepParingInfoAfterReboot)

            if(params.dpmIlluminationControl != null){
                bParams.putString("dpm_illumination_control",when (params.dpmIlluminationControl) {
                    DpmIlluminationControl.DIRECT -> "0"
                    DpmIlluminationControl.INDIRECT -> "11"
                    DpmIlluminationControl.CYCLE -> "10"
                })
            }


            if(params.dpmMode != null){
                bParams.putString("dpm_mode",when (params.dpmMode) {
                    DpmMode.DISABLED -> "0"
                    DpmMode.MODE1 -> "1"
                    DpmMode.MODE2 -> "2"
                })
            }

            intentBool(bParams,"qr_launch_enable",params.qrLaunchEnable)
            intentBool(bParams,"qr_launch_enable_qr_decoder",params.qrLaunchEnableQrDecoder)
            intentBool(bParams,"qr_launch_show_confirmation_dialog",params.qrLaunchShowConfirmationDialog)
            intentNr(bParams,"nodecode_time",params.noDecodeTime?.toInt())









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

    fun intentBoolToNr(bundle: Bundle,key: String ,input: Boolean?) {

        if(input != null){

            bundle.putString(key, if(input) "1" else "0")
        }
    }


    fun intentBool(bundle: Bundle,key: String ,input: Boolean?) {
        if(input != null){
            bundle.putString(key,input.toString())
        }
    }


}
