package com.circuskitchens.flutter_datawedge

import androidx.annotation.NonNull
import org.json.JSONObject

class Scan(
  @NonNull val labelType: String,
  @NonNull val scanData: String,
  @NonNull val source: String
) {
  fun toJson(): String {
    return JSONObject( mapOf(
      "labelType" to this.labelType,
      "scanData" to this.scanData,
      "source" to this.source
    )).toString()
  }
}
