package com.circuskitchens.flutter_datawedge



import android.content.Context
import android.content.IntentFilter
import android.os.Build.*
import android.os.Build.VERSION_CODES.*
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.circuskitchens.flutter_datawedge.pigeon.DataWedgeFlutterApi
import com.circuskitchens.flutter_datawedge.pigeon.DataWedgeHostApi
import io.flutter.embedding.engine.plugins.FlutterPlugin

class FlutterDatawedgePlugin : FlutterPlugin {

    private val profileIntentBroadcast = "2"
    private var flutter: FlutterPlugin.FlutterPluginBinding? = null
    private var flutterApi: DataWedgeFlutterApi? = null
    private var dwInterface: DWInterface? = null
    private lateinit var intentFilter: IntentFilter

    @RequiresApi(LOLLIPOP)
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("FlutterDataWedgeFlugin","Attaching to engine...")
        val api = DataWedgeFlutterApi(flutterPluginBinding.binaryMessenger)
        dwInterface = DWInterface(flutterPluginBinding.applicationContext,api)
        flutterApi = api
        DataWedgeHostApi.setUp(flutterPluginBinding.binaryMessenger,dwInterface)
        dwInterface?.setupBroadcastReceiver()
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        dwInterface?.dispose()
        DataWedgeHostApi.setUp(binding.binaryMessenger,null)
        flutterApi = null
    }

}
