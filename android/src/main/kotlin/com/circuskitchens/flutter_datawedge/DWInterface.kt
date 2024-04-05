package com.circuskitchens.flutter_datawedge


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import com.circuskitchens.flutter_datawedge.pigeon.*
import java.util.function.IntConsumer


enum class DWCommand(val cmd: String) {
    CreateProfile("com.symbol.datawedge.api.CREATE_PROFILE"),
    SetConfig("com.symbol.datawedge.api.SET_CONFIG"),
    SetPluginState("com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN"),
    RegisterForNotification("com.symbol.datawedge.api.REGISTER_FOR_NOTIFICATION"),
    UnregisterForNotification("com.symbol.datawedge.api.UNREGISTER_FOR_NOTIFICATION"),
    SoftScanTrigger("com.symbol.datawedge.api.SOFT_SCAN_TRIGGER"),
}


enum class DWEvent(val value: String) {
    ResultAction("com.symbol.datawedge.api.RESULT_ACTION"),
    Action("com.symbol.datawedge.api.ACTION"),
    ResultNotification("com.symbol.datawedge.api.NOTIFICATION_ACTION")

}

enum class DWKeys(val value: String) {


    ApplicationName("com.symbol.datawedge.api.APPLICATION_NAME"),
    NotificationType("com.symbol.datawedge.api.NOTIFICATION_TYPE"),
    ScannerStatus("SCANNER_STATUS"),

    SoftScanTriggerStart("START_SCANNING"),
    SoftScanTriggerStop("STOP_SCANNING")
}

class CommandResult(
    val command: String,
    val commandIdentifier: String,
    val extras: Bundle,
    val result: String
) {

}

class DWInterface(val context: Context, val flutterApi: DataWedgeFlutterApi) : BroadcastReceiver(),
    DataWedgeHostApi {


    // Registers a broadcast receive that listens to datawedge intents
    fun setupBroadcastReceiver() {
        val intentFilter = IntentFilter()
        intentFilter.addAction(context.packageName + ".SCAN_EVENT")
        intentFilter.addAction(DWEvent.ResultAction.value)
        intentFilter.addAction(DWEvent.Action.value)
        intentFilter.addAction(DWEvent.ResultNotification.value)
        intentFilter.addCategory(Intent.CATEGORY_DEFAULT)
        context.registerReceiver(this, intentFilter)
    }


    // A map that contains the callbacks that are associated to the command identifier
    val callbacks = HashMap<String, (Result<CommandResult>) -> Unit>()


    companion object {


        // DataWedge Extras
        const val EXTRA_GET_VERSION_INFO = "com.symbol.datawedge.api.GET_VERSION_INFO"

        const val EXTRA_KEY_APPLICATION_NAME = "com.symbol.datawedge.api.APPLICATION_NAME"
        const val EXTRA_KEY_NOTIFICATION_TYPE = "NOTIFICATION_TYPE"
        const val EXTRA_SOFT_SCAN_TRIGGER = "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER"
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


        const val ACTION_GET_SCANNER_STATUS = "com.symbol.datawedge.api.GET_SCANNER_STATUS"
        const val ACTION_SET_CONFIG = "com.symbol.datawedge.api.SET_CONFIG"

        const val DATAWEDGE_SCAN_EXTRA_SOURCE = "com.symbol.datawedge.source"
        const val DATAWEDGE_SCAN_EXTRA_DATA_STRING = "com.symbol.datawedge.data_string"
        const val DATAWEDGE_SCAN_EXTRA_LABEL_TYPE = "com.symbol.datawedge.label_type"
        const val DATAWEDGE_SCAN_EXTRA_DECODE_DATA = "com.symbol.datawedge.decode_data"
        const val DATAWEDGE_SCAN_EXTRA_DECODE_MODE = "com.symbol.datawedge.decoded_mode"

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

        if (intent == null) {
            return
        }

        val action = intent.action
        val b = intent.extras



        when (action) {
            (DWEvent.ResultAction.value) -> {


                val result = intent.getStringExtra(DWInterface.EXTRA_RESULT) ?: ""
                val command = intent.getStringExtra(DWInterface.EXTRA_COMMAND) ?: ""
                val commandIdentifier =
                    intent.getStringExtra(DWInterface.EXTRA_COMMAND_IDENTIFIER) ?: ""

                // Callback the function we have stored in our hashmap
                if (callbacks.containsKey(commandIdentifier)) {
                    callbacks[commandIdentifier]?.let {
                        it(
                            Result.success(
                                CommandResult(
                                    command = command,
                                    result = result,
                                    commandIdentifier = commandIdentifier,
                                    extras = intent.extras!!
                                )
                            )
                        )
                    }
                    // Remove the pending command as it is resolved now
                    callbacks.remove(commandIdentifier)
                } else {
                    Log.e("DWInterface", "Unknown command was returned")
                }

            }

            (context.packageName + ".SCAN_EVENT") -> {
                //  A barcode has been scanned
                val source = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_SOURCE) ?: ""
                val scanData =
                    intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_DATA_STRING) ?: ""
                val labelType =
                    intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_LABEL_TYPE) ?: ""
                val decodedData =
                    intent.getSerializableExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_DECODE_DATA) as (ArrayList<ByteArray>?)
                val decodeMode = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_DECODE_MODE)

                flutterApi.onScanResult(
                    ScanEvent(
                        labelType = convertLabelType(labelType),
                        source = when (source) {
                            "msr" -> ScanSource.MSR
                            "scanner" -> ScanSource.SCANNER
                            "simulscan" -> ScanSource.SIMULSCAN
                            "serial" -> ScanSource.SERIAL
                            "voice" -> ScanSource.VOICE
                            "rfid" -> ScanSource.RFID
                            else -> throw Error("Unknown source")
                        },
                        dataString = scanData,
                        decodeData = decodedData?.toList() ?: listOf<ByteArray>(),
                        decodeMode = when (decodeMode) {
                            "multiple_decode" -> DecodeMode.MULTIPLE
                            "single_decode" -> DecodeMode.SINGLE
                            else -> throw Error("Unknown decode mode")
                        }
                    )
                ) { ->

                }


            }

            (DWEvent.ResultNotification.value) -> {


                if (!intent.hasExtra(EXTRA_RESULT_NOTIFICATION)) {
                    return
                }
                val notification = intent.getBundleExtra(EXTRA_RESULT_NOTIFICATION) ?: return


                val keys = notification.keySet()

                val notificationType = notification.getString(EXTRA_KEY_NOTIFICATION_TYPE) ?: return

                Log.d("Notification", notificationType)

                when (notificationType) {
                    EXTRA_KEY_VALUE_SCANNER_STATUS -> {
                        val status =
                            notification.getString(DWInterface.EXTRA_KEY_VALUE_NOTIFICATION_STATUS)

                        flutterApi.onScannerStatusChanged(
                            StatusChangeEvent(
                                newState = when (status) {
                                    "WAITING" -> ScannerState.WAITING
                                    "DISABLED" -> ScannerState.DISABLED
                                    "SCANNING" -> ScannerState.SCANNING
                                    "IDLE" -> ScannerState.IDLE
                                    "CONNECTED" -> ScannerState.CONNECTED
                                    "DISCONNECTED" -> ScannerState.DISCONNECTED
                                    else -> throw Error("Unknown scanner state")
                                }
                            )
                        ) { }
                    }

                    EXTRA_KEY_VALUE_PROFILE_SWITCH -> {
                        flutterApi.onProfileChange { }
                    }

                    EXTRA_KEY_VALUE_CONFIGURATION_UPDATE -> {
                        flutterApi.onConfigUpdate {}

                    }


                }
            }


        }


    }

    // Clear all callbacks to prevent holding unresolvable references and unregister the broadcast receiver
    fun dispose() {
        for (callback in callbacks) {
            callback.value(Result.failure(Error("DataWedge interface was disposed")))
        }

        context.unregisterReceiver(this)
    }


    // from https://stackoverflow.com/questions/46943860/idiomatic-way-to-generate-a-random-alphanumeric-string-in-kotlin
    private fun getRandomString(length: Int): String {
        val allowedChars = ('A'..'Z') + ('a'..'z') + ('0'..'9')
        return (1..length)
            .map { allowedChars.random() }
            .joinToString("")
    }

    fun sendCommandString(
        command: DWCommand,
        parameter: String,
        callback: (Result<CommandResult>) -> Unit
    ) {
        sendCommand(command, parameter, callback)
    }

    fun sendCommandBundle(

        command: DWCommand,
        parameter: Bundle,
        callback: (Result<CommandResult>) -> Unit
    ) {
        sendCommand(command, parameter, callback)
    }

    private fun sendCommand(
        command: DWCommand,
        parameter: Any,
        callback: (Result<CommandResult>) -> Unit
    ) {
        // Generate a random command identifier
        val commandIdentifier = getRandomString(10)
        // Keep a reference to the callback by the command id
        callbacks[commandIdentifier] = callback

        val dwIntent = Intent()
        dwIntent.action = DWEvent.Action.value


        // This is certainly not elegant... not sure how this could be done more elegantly
        if (parameter is String) {
            dwIntent.putExtra(command.cmd, parameter)
        } else if (parameter is Bundle) {
            dwIntent.putExtra(command.cmd, parameter)
        } else {
            callback(Result.failure(Error("Unsupported payload type")))
            return
        }

        dwIntent.putExtra(EXTRA_SEND_RESULT, "true")
        dwIntent.putExtra(EXTRA_COMMAND_IDENTIFIER, commandIdentifier)

        context.sendBroadcast(dwIntent)

    }


    override fun createProfile(
        profileName: String,
        callback: (kotlin.Result<Unit>) -> Unit
    ) {
        sendCommand(DWCommand.CreateProfile, profileName) { result ->
            if (result.isFailure) {
                callback(Result.failure(result.exceptionOrNull()!!))
            } else {
                val cmd = result.getOrThrow()
                when (cmd.result) {
                    "SUCCESS" -> callback(Result.success(Unit))
                    else -> callback(Result.failure(Error(cmd.result)))
                }
            }
        }
    }

    override fun suspendPlugin(callback: (Result<String>) -> Unit) {
        sendCommandString(DWCommand.SetPluginState, "SUSPEND_PLUGIN") { result ->
            if (result.isFailure) {
                callback(Result.failure(result.exceptionOrNull()!!))

            } else {
                val cmd = result.getOrThrow()
                when (cmd.result) {
                    // Unsure whether this exists, not in the docs
                    "SCANNER_SUSPEND_FAILED" -> callback(Result.failure(Error(cmd.result)))
                    "SCANNER_ALREADY_SUSPENDED" -> callback(Result.failure(Error(cmd.result)))
                    "PLUGIN_DISABLED" -> callback(Result.failure(Error(cmd.result)))
                    else -> callback(Result.success(cmd.result))
                }
            }

        }
    }

    override fun resumePlugin(callback: (Result<String>) -> Unit) {
        sendCommandString(DWCommand.SetPluginState, "RESUME_PLUGIN") { result ->
            if (result.isFailure) {
                callback(Result.failure(result.exceptionOrNull()!!))

            } else {
                val cmd = result.getOrThrow()
                when (cmd.result) {
                    "SCANNER_RESUME_FAILED" -> callback(Result.failure(Error(cmd.result)))
                    "SCANNER_ALREADY_RESUMED" -> callback(Result.failure(Error(cmd.result)))
                    "PLUGIN_DISABLED" -> callback(Result.failure(Error(cmd.result)))
                    else -> callback(Result.success(cmd.result))
                }
            }
        }
    }

    override fun enablePlugin(callback: (Result<String>) -> Unit) {
        sendCommandString(DWCommand.SetPluginState, "ENABLE_PLUGIN") { result ->
            if (result.isFailure) {
                callback(Result.failure(result.exceptionOrNull()!!))

            } else {
                val cmd = result.getOrThrow()
                when (cmd.result) {
                    "SCANNER_ALREADY_ENABLED" -> callback(Result.failure(Error(cmd.result)))
                    "SCANNER_ENABLE_FAILED" -> callback(Result.failure(Error(cmd.result)))
                    else -> callback(Result.success(cmd.result))
                }
            }
        }
    }


    override fun disablePlugin(callback: (Result<String>) -> Unit) {
        sendCommandString(DWCommand.SetPluginState, "DISABLE_PLUGIN") { result ->
            if (result.isFailure) {
                callback(Result.failure(result.exceptionOrNull()!!))

            } else {
                val cmd = result.getOrThrow()
                when (cmd.result) {
                    "SCANNER_ALREADY_DISABLED" -> callback(Result.failure(Error(cmd.result)))
                    "SCANNER_DISABLE_FAILED" -> callback(Result.failure(Error(cmd.result)))
                    else -> callback(Result.success(cmd.result))
                }
            }
        }
    }


    override fun getPackageIdentifer(): String {
        return context.applicationInfo.packageName
    }

    override fun registerForNotifications(): Unit {

        val params = Bundle()

        params.putString(DWKeys.ApplicationName.value, getPackageIdentifer())
        params.putString(DWKeys.NotificationType.value, DWKeys.ScannerStatus.value)


        sendCommandBundle(DWCommand.RegisterForNotification, params) { res ->
            // This command never returns
        }
    }

    override fun softScanTrigger(on: Boolean, callback: (Result<String>) -> Unit) {

        var cmdValue = DWKeys.SoftScanTriggerStart.value

        if (!on)
            cmdValue = DWKeys.SoftScanTriggerStop.value



        sendCommandString(DWCommand.SoftScanTrigger, cmdValue) { result ->
            if (result.isFailure) {
                callback(Result.failure(result.exceptionOrNull()!!))

            } else {
                val cmd = result.getOrThrow()
                when (cmd.result) {
                    "SCANNER_ALREADY_DISABLED" -> callback(Result.failure(Error(cmd.result)))
                    "SCANNER_DISABLE_FAILED" -> callback(Result.failure(Error(cmd.result)))
                    else -> callback(Result.success(cmd.result))
                }
            }
        }


    }

    override fun unregisterForNotifications(): Unit {
        TODO("Not yet implemented")
    }


    // Tries to call set config with each of the known decoders set to false.
    override fun setDecoder(
        decoder: Decoder,
        enabled: Boolean,
        profileName: String,
        callback: (Result<Unit>) -> Unit
    ): Unit {


        val configBundle = Bundle()

        // Base config
        configBundle.putString("PROFILE_NAME", profileName)
        configBundle.putString("CONFIG_MODE", "UPDATE")

        val bConfig = Bundle()
        val bParams = Bundle()

        intentBool(bParams, decoderToString[decoder]!!, enabled)

        bParams.putString("scanner_selection_by_identifier","AUTO")

        bConfig.putString("PLUGIN_NAME", "BARCODE")
        bConfig.putBundle("PARAM_LIST", bParams)

        val plugins = arrayListOf<Bundle>(
            bConfig
        )

        configBundle.putParcelableArrayList("PLUGIN_CONFIG", plugins)

        sendCommand(DWCommand.SetConfig, configBundle) { res ->
            if (res.isFailure) {
                callback(Result.failure(res.exceptionOrNull()!!))

            } else {
                val cmd = res.getOrThrow()

                when (cmd.result) {
                    "SUCCESS" -> callback(Result.success(Unit))
                    else -> callback(Result.failure(Error(cmd.result)))
                }


            }
        }


    }


    override fun setProfileConfig(config: ProfileConfig, callback: (kotlin.Result<Unit>) -> Unit) {
        // We somehow need to convert the profile config to a bundle...

        val configBundle = Bundle()

        // Base config
        configBundle.putString("PROFILE_NAME", config.profileName)
        configBundle.putString("PROFILE_ENABLED", config.profileEnabled.toString())
        configBundle.putString(
            "CONFIG_MODE", when (config.configMode) {
                ConfigMode.CREATEIFNOTEXISTS -> "CREATE_IF_NOT_EXIST"
                ConfigMode.UPDATE -> "UPDATE"
                ConfigMode.OVERWRITE -> "OVERWRITE"
            }
        )

        // Apps that this profile is active for
        if (config.appList != null) {

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

        // Prepare a list of plugins that we will process. Maybe we will need to split this into
        // multiple calls in the future, because older version of DW don't support multiple plugins
        // at once
        val plugins = arrayListOf<Bundle>()

        // Intent parameters
        if (config.intentParamters != null) {
            plugins.add(buildIntentConfig(config.intentParamters))
        }

        // Barcode parameters
        if (config.barcodeParamters != null) {
            plugins.add(buildBarcodeConfig(config.barcodeParamters))
        }

        // Add all plugins
        configBundle.putParcelableArrayList("PLUGIN_CONFIG", plugins)


        sendCommand(DWCommand.SetConfig, configBundle) { res ->
            if (res.isFailure) {
                callback(Result.failure(res.exceptionOrNull()!!))

            } else {
                val cmd = res.getOrThrow()

                when (cmd.result) {
                    "SUCCESS" -> callback(Result.success(Unit))
                    else -> callback(Result.failure(Error(cmd.result)))
                }


            }
        }


    }


}
