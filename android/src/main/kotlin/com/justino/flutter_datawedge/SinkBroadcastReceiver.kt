package com.justino.flutter_datawedge

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.EventChannel.EventSink

class SinkBroadcastReceiver(private var events: EventSink? = null) : BroadcastReceiver() {
  private val profileIntentAction = "com.justino.flutter_datawedge.SCAN"

  override fun onReceive(context: Context, intent: Intent) {
    val action = intent.action
    //val b = intent.extras
    //  This is useful for debugging to verify the format of received intents from DataWedge
    //for (String key : b.keySet())
    //{
    //    Log.v("DataWedgeIntent:", key);
    //}

    if (action.equals(profileIntentAction)){
      //  A barcode has been scanned
      val source = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_SOURCE) ?: ""
      val scanData = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_DATA_STRING) ?: ""
      val labelType = intent.getStringExtra(DWInterface.DATAWEDGE_SCAN_EXTRA_LABEL_TYPE) ?: ""

      val currentScan =  Scan(scanData, labelType, source)
      // Sending data to Flutter side
      events!!.success(currentScan.toJson())
    }
    //  Could handle return values from DW here such as RETURN_GET_ACTIVE_PROFILE
    //  or RETURN_ENUMERATE_SCANNERS
  }

}