package com.circuskitchens.flutter_datawedge.domain

import android.content.Context
import android.content.Intent

class DWScannerInputPlugin {
  companion object {
    const val ACTION = "com.symbol.datawedge.api.ACTION"
    const val ID = "com.symbol.datawedge.api.SCANNER_INPUT_PLUGIN"

    const val SUSPEND_SCANNER = "SUSPEND_SCANNER"
    const val RESUME_SCANNER = "RESUME_SCANNER"

    const val ENABLE_SCANNER = "ENABLE_SCANNER"
    const val DISABLE_SCANNER = "RESUME_SCANNER"

    const val PARAM_SUSPEND_PLUGIN = "SUSPEND_PLUGIN"
    const val PARAM_RESUME_PLUGIN  = "RESUME_PLUGIN"
    const val PARAM_ENABLE_PLUGIN  = "ENABLE_PLUGIN"
    const val PARAM_DISABLE_PLUGIN  = "DISABLE_PLUGIN"
  }

  private fun suspendScanner(context: Context) {
    val i = Intent()
    i.action = ACTION
    i.putExtra(ID, PARAM_SUSPEND_PLUGIN)
    i.putExtra("SEND_RESULT", "true")
    i.putExtra("COMMAND_IDENTIFIER", SUSPEND_SCANNER)
    context.sendBroadcast(i)
  }

  private fun resumeScanner(context: Context) {
    val i = Intent()
    i.action = ACTION
    i.putExtra(ID, PARAM_RESUME_PLUGIN)
    i.putExtra("SEND_RESULT", "true")
    i.putExtra("COMMAND_IDENTIFIER", RESUME_SCANNER)
    context.sendBroadcast(i)
  }

  private fun enableScanner(context: Context) {
    val i = Intent()
    i.action = ACTION
    i.putExtra(ID, PARAM_ENABLE_PLUGIN)
    i.putExtra("SEND_RESULT", "true")
    i.putExtra("COMMAND_IDENTIFIER", ENABLE_SCANNER)
    context.sendBroadcast(i)
  }

  private fun disableScanner(context: Context) {
    val i = Intent()
    i.action = ACTION
    i.putExtra(ID, PARAM_DISABLE_PLUGIN)
    i.putExtra("SEND_RESULT", "true")
    i.putExtra("COMMAND_IDENTIFIER", DISABLE_SCANNER)
    context.sendBroadcast(i)
  }

}
