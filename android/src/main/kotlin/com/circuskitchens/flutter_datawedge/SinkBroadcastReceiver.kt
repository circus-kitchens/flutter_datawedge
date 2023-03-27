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
        val action = intent.action

        val b = intent.extras
        //  This is useful for debugging to verify the format of received intents from DataWedge
//        if (b != null) {
//          for (key in b.keySet()) {
//            Log.d("onReceiveExtras:", key);
//          }
//        }

        when {
            action.equals(context.packageName + SCAN_EVENT_INTENT_ACTION) -> {
                //  A barcode has been scanned
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

            action.equals(DWInterface.ACTION_RESULT) -> {
                val result = intent.getStringExtra(DWInterface.EXTRA_RESULT) ?: ""
                val command = intent.getStringExtra(DWInterface.EXTRA_COMMAND) ?: ""
                val commandIdentifier= intent.getStringExtra(DWInterface.EXTRA_COMMAND_IDENTIFIER) ?: ""

                var resultInfo: JSONObject? = null;
                if (intent.hasExtra(DWInterface.EXTRA_RESULT_INFO)) {
                    resultInfo = JSONObject();

                    val bundle = intent.getBundleExtra(DWInterface.EXTRA_RESULT_INFO)
                    val keys: Set<String> = bundle!!.keySet()

                    for (key in keys) {
                        resultInfo.put(key, bundle.get(key))
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
            action.equals(DWInterface.ACTION_RESULT_NOTIFICATION) -> {

                if (intent.hasExtra(DWInterface.EXTRA_RESULT_NOTIFICATION)) {
                    val b = intent.getBundleExtra(DWInterface.EXTRA_RESULT_NOTIFICATION)
                    /*
                    if (b != null) {
                      for (key in b.keySet()) {
                        Log.d("onReceiveBundleExtras:", key);
                      }
                    }*/
                    val NOTIFICATION_TYPE =
                        b!!.getString(DWInterface.EXTRA_RESULT_NOTIFICATION_TYPE)

                    if (NOTIFICATION_TYPE != null) {
                        when (NOTIFICATION_TYPE) {
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
                                val profileEnabled = b.getBoolean("PROFILE_ENABLED")
                                val profileResult = JSONObject()

                                profileResult.put(MyEvents.EVENT_NAME, "PROFILE_SWITCH")
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
                Log.d("onReceive_default_case:", intent.toString());
            }
//  Could handle return values from DW here such as RETURN_GET_ACTIVE_PROFILE
//  or RETURN_ENUMERATE_SCANNERS
        }
        //  Could handle return values from DW here such as RETURN_GET_ACTIVE_PROFILE
        //  or RETURN_ENUMERATE_SCANNERS
    }

}
