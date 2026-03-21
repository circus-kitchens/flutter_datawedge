package com.circuskitchens.flutter_datawedge

import android.os.Bundle
import com.circuskitchens.flutter_datawedge.pigeon.IntentDelivery
import com.circuskitchens.flutter_datawedge.pigeon.PluginBarcodeParamters
import com.circuskitchens.flutter_datawedge.pigeon.PluginIntentParamters

// This function builds the bundle to configure the intetn plugin
// It takes the flutter config in and returns a bundle that can be passed to data wedge
fun buildIntentConfig(params: PluginIntentParamters): Bundle {

    val iConfig = Bundle()

    iConfig.putString("PLUGIN_NAME","INTENT")
    val iParams = Bundle();

    intentBool(iParams,"intent_output_enabled",params.intentOutputEnabled)
    intentString(iParams,"intent_action",params.intentAction)
    intentString(iParams,"intent_category",params.intentCategory)

    if(params.intentDelivery != null){
        iParams.putString("intent_delivery",when(params.intentDelivery) {
            IntentDelivery.BROADCAST -> "2"
            IntentDelivery.START_ACTIVITY -> "0"
            IntentDelivery.START_SERVICE -> "1"
        })
    }

    intentBool(iParams,"intent_use_content_provider",params.intentUseContentProvider)


    iConfig.putBundle("PARAM_LIST", iParams)

    return iConfig
}