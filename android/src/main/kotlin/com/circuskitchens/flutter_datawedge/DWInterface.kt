package com.circuskitchens.flutter_datawedge

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log

class DWInterface() {
  companion object {

    // DataWedge Extras
    const val EXTRA_GET_VERSION_INFO = "com.symbol.datawedge.api.GET_VERSION_INFO"
    const val EXTRA_CREATE_PROFILE = "com.symbol.datawedge.api.CREATE_PROFILE"
    const val EXTRA_KEY_APPLICATION_NAME = "com.symbol.datawedge.api.APPLICATION_NAME"
    const val EXTRA_KEY_NOTIFICATION_TYPE = "com.symbol.datawedge.api.NOTIFICATION_TYPE"
    const val EXTRA_SOFT_SCAN_TRIGGER = "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER"
    const val EXTRA_RESULT_NOTIFICATION = "com.symbol.datawedge.api.NOTIFICATION"
    const val EXTRA_REGISTER_NOTIFICATION = "com.symbol.datawedge.api.REGISTER_FOR_NOTIFICATION"
    const val EXTRA_UNREGISTER_NOTIFICATION = "com.symbol.datawedge.api.UNREGISTER_FOR_NOTIFICATION"

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

    // DataWedge Actions
    const val ACTION_DATAWEDGE = "com.symbol.datawedge.api.ACTION"
    const val ACTION_RESULT_NOTIFICATION = "com.symbol.datawedge.api.NOTIFICATION_ACTION"
    const val ACTION_RESULT = "com.symbol.datawedge.api.RESULT_ACTION"

    const val ACTION_GET_SCANNER_STATUS = "com.symbol.datawedge.api.GET_SCANNER_STATUS"
    const val ACTION_SET_CONFIG = "com.symbol.datawedge.api.SET_CONFIG"

    const val DATAWEDGE_SCAN_EXTRA_SOURCE = "com.symbol.datawedge.source"
    const val DATAWEDGE_SCAN_EXTRA_DATA_STRING = "com.symbol.datawedge.data_string"
    const val DATAWEDGE_SCAN_EXTRA_LABEL_TYPE = "com.symbol.datawedge.label_type"

  }

  fun sendCommandString(context: Context, command: String, parameter: String, sendResult: Boolean = false) {
    val dwIntent = Intent()
    dwIntent.action = ACTION_DATAWEDGE
    dwIntent.putExtra(command, parameter)
    if (sendResult) {
      dwIntent.putExtra(EXTRA_SEND_RESULT, "true")
    }
    context.sendBroadcast(dwIntent)
  }

  fun sendCommandBundle(context: Context, command: String, parameter: Bundle) {
    val dwIntent = Intent()
    dwIntent.action = ACTION_DATAWEDGE
    dwIntent.putExtra(command, parameter)
    context.sendBroadcast(dwIntent)
  }
}
