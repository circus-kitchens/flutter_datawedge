package com.justino.flutter_datawedge

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.EventChannel.EventSink
import org.json.JSONObject


class SinkBroadcastReceiver : BroadcastReceiver() {
  var sink: EventSink? = null

  fun SinkBroadcastReceiver(sink: EventSink?) {
    this.sink = sink
  }

  override fun onReceive(context: Context?, intent: Intent?) {
    val action = intent!!.action
    val b = intent.extras
    //  This is useful for debugging to verify the format of received intents from DataWedge
    //for (String key : b.keySet())
    //{
    //    Log.v("DataWedgeIntent:", key);
    //}
    //  This is useful for debugging to verify the format of received intents from DataWedge
    //for (String key : b.keySet())
    //{
    //    Log.v("DataWedgeIntent:", key);
    //}
    if (action == "com.justino.flutter_datawedge.ACTION") {

      //Get data from Intent
      val decodedSource = intent.getStringExtra("com.symbol.datawedge.source")
      val decodedData = intent.getStringExtra("com.symbol.datawedge.data_string")
      val decodedLabelType = intent.getStringExtra("com.symbol.datawedge.label_type")

      // create a json object which will be returned to Flutter part
      val json = JSONObject()
      try {
        json.put("decodedSource", decodedSource)
        json.put("decodedData", decodedData)
        json.put("decodedLabelType", decodedLabelType)
        sink!!.success(json.toString())
      } catch (e: Exception) {
        // catch json exceptions
        sink!!.success(e.toString())
      }
    }
  }
}