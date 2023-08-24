package com.circuskitchens.flutter_datawedge

import android.os.Bundle

// Utilities to add parameters to a bundle

fun intentString(bundle: Bundle, key: String, input: String?) {
    if (input != null) {
        bundle.putString(key, input)
    }
}

fun intentNr(bundle: Bundle, key: String, input: Int?) {
    if (input != null) {
        bundle.putString(key, input.toString())
    }
}

fun intentBoolToNr(bundle: Bundle, key: String, input: Boolean?) {
    if (input != null) {
        bundle.putString(key, if (input) "1" else "0")
    }
}


fun intentBool(bundle: Bundle, key: String, input: Boolean?) {
    if (input != null) {
        bundle.putString(key, input.toString())
    }
}