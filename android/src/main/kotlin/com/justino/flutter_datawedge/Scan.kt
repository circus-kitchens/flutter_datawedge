package com.justino.flutter_datawedge

import androidx.annotation.NonNull
import org.json.JSONObject;

class Scan(@NonNull val data: String, @NonNull val symbology: String, @NonNull val dateTime: String) {
  fun toJson(): String{
    return JSONObject(mapOf(
      "scanData" to this.data,
      "symbology" to this.symbology,
      "dateTime" to this.dateTime
    )).toString();
  }
}
