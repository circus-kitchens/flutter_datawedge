package com.circuskitchens.flutter_datawedge

import android.content.BroadcastReceiver
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.util.Log
import com.circuskitchens.flutter_datawedge.consts.MyEvents
import com.circuskitchens.flutter_datawedge.consts.MyIntents.Companion.SCAN_EVENT_INTENT_ACTION
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject

class SinkBroadcastReceiver(private var events: EventSink? = null) : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        when (intent.action) {
            ///  A barcode has been scanned
            context.packageName + SCAN_EVENT_INTENT_ACTION -> {
                handleScannedBarcode(intent)
            }

            DWInterface.ACTION_RESULT -> {
                if (intent.hasExtra(DWInterface.EXTRA_RESULT_GET_ACTIVE_PROFILE)) {
                    handleGetActiveProfile(intent)
                    return
                }
                if (intent.hasExtra(DWInterface.EXTRA_RESULT_GET_PROFILES_LIST)) {
                    handleGetProfiles(intent)
                    return
                }
                handleOtherActionResults(intent)
            }

            DWInterface.ACTION_RESULT_NOTIFICATION -> {
                if (intent.hasExtra(DWInterface.EXTRA_RESULT_NOTIFICATION)) {
                    val b = intent.getBundleExtra(DWInterface.EXTRA_RESULT_NOTIFICATION)
                    /*
                        if (b != null) {
                          for (key in b.keySet()) {
                            Log.d("onReceiveBundleExtras:", key)
                          }
                        }*/
                    val notificationType =
                        b!!.getString(DWInterface.EXTRA_RESULT_NOTIFICATION_TYPE)

                    if (notificationType != null) {
                        when (notificationType) {
                            DWInterface.EXTRA_KEY_VALUE_SCANNER_STATUS -> {
                                val status =
                                    b.getString(DWInterface.EXTRA_KEY_VALUE_NOTIFICATION_STATUS)
                                val profile =
                                    b.getString(DWInterface.EXTRA_KEY_VALUE_NOTIFICATION_PROFILE_NAME)

                                val notificationResult = JSONObject()
                                notificationResult.put(MyEvents.EVENT_NAME, MyEvents.SCANNER_STATUS)
                                notificationResult.put("status", status)
                                notificationResult.put("profile", profile)
                                events!!.success(notificationResult.toString())
                            }

                            DWInterface.EXTRA_KEY_VALUE_PROFILE_SWITCH -> {
                                val profile =
                                    b.getString(DWInterface.EXTRA_KEY_VALUE_NOTIFICATION_PROFILE_NAME)
                                val profileEnabled = b.getBoolean(DWInterface.EXTRA_KEY_VALUE_PROFILE_ENABLED)
                                val profileResult = JSONObject()

                                profileResult.put(MyEvents.EVENT_NAME, DWInterface.EXTRA_KEY_VALUE_PROFILE_SWITCH)
                                profileResult.put("profileEnabled", profileEnabled)
                                profileResult.put("profile", profile)
                                events!!.success(profileResult.toString())
                            }

                            DWInterface.EXTRA_KEY_VALUE_CONFIGURATION_UPDATE -> {
                                Log.d(TAG, "onReceive: Configuration Update")
                            }
                        }

                    }
                }

            }

            else -> {
                // Log.d("flutter_datawedge:onReceive:default", intentToString(intent))
                Log.d(TAG, "default_case")
            }
        }
    }

    private fun handleScannedBarcode(intent: Intent) {
        val source = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_SOURCE) ?: ""
        val scanData =
            intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_DATA_STRING) ?: ""
        val labelType =
            intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_LABEL_TYPE) ?: ""

        val scanResult = JSONObject()
        scanResult.put(MyEvents.EVENT_NAME, MyEvents.SCAN_RESULT)
        scanResult.put("scanData", scanData)
        scanResult.put("labelType", labelType)
        scanResult.put("source", source)

        events!!.success(scanResult.toString())
    }

    private fun handleOtherActionResults(intent: Intent) {
        val result = intent.getStringExtra(DWInterface.EXTRA_RESULT) ?: ""
        val command = intent.getStringExtra(DWInterface.EXTRA_COMMAND) ?: ""
        val commandIdentifier =
            intent.getStringExtra(DWInterface.EXTRA_COMMAND_IDENTIFIER) ?: ""

        var resultInfo: JSONObject? = null
        if (intent.hasExtra(DWInterface.EXTRA_RESULT_INFO)) {
            resultInfo = JSONObject()

            val bundle = intent.getBundleExtra(DWInterface.EXTRA_RESULT_INFO)
            val keys: Set<String> = bundle!!.keySet()

            for (key in keys) {
                resultInfo.put(key, bundle.getString(key))
            }
        }


        val actionResult = JSONObject()
        actionResult.put(MyEvents.EVENT_NAME, MyEvents.ACTION_RESULT)
        actionResult.put("result", result)
        actionResult.put("command", command)
        actionResult.put("resultInfo", resultInfo)
        actionResult.put("commandIdentifier", commandIdentifier)
        events!!.success(actionResult.toString())
    }

    private fun handleGetProfiles(intent: Intent) {
        // We are requesting the profiles
        val profilesList: Array<String>? =
            intent.getStringArrayExtra(DWInterface.EXTRA_RESULT_GET_PROFILES_LIST)
        val actionResult = JSONObject()
        actionResult.put(MyEvents.EVENT_NAME, MyEvents.ACTION_RESULT)

        actionResult.put("resultInfo", JSONObject(mapOf("profiles" to profilesList)))


        val result = intent.getStringExtra(DWInterface.EXTRA_RESULT) ?: "SUCCESS"
        val commandIdentifier =
            intent.getStringExtra(DWInterface.EXTRA_COMMAND_IDENTIFIER) ?: ""

        actionResult.put("result", result)
        actionResult.put("command", DWInterface.EXTRA_GET_PROFILES)
        actionResult.put("commandIdentifier", commandIdentifier)

        events!!.success(actionResult.toString())
    }

    private fun handleGetActiveProfile(intent: Intent) {
        val activeProfile: String? =
            intent.getStringExtra(DWInterface.EXTRA_RESULT_GET_ACTIVE_PROFILE)

        val actionResult = JSONObject()
        actionResult.put(MyEvents.EVENT_NAME, MyEvents.ACTION_RESULT)

        val result = intent.getStringExtra(DWInterface.EXTRA_RESULT) ?: "SUCCESS"

        val commandIdentifier =
            intent.getStringExtra(DWInterface.EXTRA_COMMAND_IDENTIFIER) ?: ""

        actionResult.put("result", result)
        actionResult.put("resultInfo", JSONObject(mapOf("activeProfile" to activeProfile)))
        actionResult.put("command", DWInterface.EXTRA_ACTIVE_PROFILE)
        actionResult.put("commandIdentifier", commandIdentifier)

        Log.d(TAG, "onReceive: $actionResult")

        events!!.success(actionResult.toString())
    }

//    private fun intentToString(intent: Intent): String {
//        // This is useful for debugging to verify the format of received intents from DataWedge
//        val action = intent.action
//        val b = intent.extras
//        val resultStringBuilder = StringBuilder()
//
//        resultStringBuilder.append("{\n")
//        resultStringBuilder.append("  \"Action\": \"$action\",\n")
//
//        if (b != null) {
//            resultStringBuilder.append("  \"Extras\": {\n")
//            for (key in b.keySet()) {
//                val value = b.getString(key)
//                resultStringBuilder.append("    \"$key\": \"$value\",\n")
//            }
//            resultStringBuilder.append("  }\n")
//        }
//
//        resultStringBuilder.append("}\n")
//
//        return resultStringBuilder.toString()
//    }


}
