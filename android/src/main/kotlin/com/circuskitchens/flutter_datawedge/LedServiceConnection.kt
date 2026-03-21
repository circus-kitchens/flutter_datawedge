package com.circuskitchens.flutter_datawedge

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
import android.util.Log
import com.circuskitchens.flutter_datawedge.pigeon.LedLightBarHostApi
import com.zebra.ledbarlightservice.ILedBarLightService

class LedServiceConnection(private val context: Context) : LedLightBarHostApi, ServiceConnection {

    private val TAG = "LedServiceConnection"
    private var ledService: ILedBarLightService? = null
    private val commandQueue: MutableList<(ILedBarLightService) -> Unit> = mutableListOf()
    private var isBinding = false

    init {
        bindService()
    }

    private fun bindService() {
        if (ledService != null || isBinding) return
        
        isBinding = true
        Log.d(TAG, "Attempting to bind to LED service...")
        
        var intent = Intent("LedBarLightService")
        intent.setPackage("com.zebra.ledbarlightservice")
        
        var bound = context.bindService(intent, this, Context.BIND_AUTO_CREATE)
        
        if (!bound) {
            Log.d(TAG, "Primary intent failed. Attempting fallback intent...")
            intent = Intent()
            intent.component = ComponentName("com.zebra.led", "com.zebra.led.LedService")
            bound = context.bindService(intent, this, Context.BIND_AUTO_CREATE)
        }
        
        if (!bound) {
            Log.e(TAG, "Failed to bind to LED service.")
            isBinding = false
        }
    }

    fun dispose() {
        if (ledService != null || isBinding) {
            context.unbindService(this)
            ledService = null
            isBinding = false
        }
    }

    override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
        Log.d(TAG, "LED Service Connected")
        ledService = ILedBarLightService.Stub.asInterface(service)
        isBinding = false
        
        // Execute any queued commands
        synchronized(commandQueue) {
            commandQueue.forEach { it.invoke(ledService!!) }
            commandQueue.clear()
        }
    }

    override fun onServiceDisconnected(name: ComponentName?) {
        Log.d(TAG, "LED Service Disconnected")
        ledService = null
        isBinding = false
    }

    private fun queueOrExecute(command: (ILedBarLightService) -> Unit) {
        val service = ledService
        if (service != null) {
            try {
                command(service)
            } catch (e: Exception) {
                Log.e(TAG, "Error executing LED command", e)
            }
        } else {
            synchronized(commandQueue) {
                commandQueue.add(command)
            }
            bindService()
        }
    }

    override fun setLight(ledId: Long, color: Long) {
        queueOrExecute {
            it.setLight(ledId.toInt(), color.toInt())
        }
    }

    override fun setLedOff() {
        queueOrExecute {
            it.setLedOff()
        }
    }

    override fun setLightSequence(
        ledId: Long,
        color1: Long,
        period1: Long,
        color2: Long,
        period2: Long
    ) {
        queueOrExecute {
            it.setLightSequence(ledId.toInt(), color1.toInt(), period1.toInt(), color2.toInt(), period2.toInt())
        }
    }

    override fun setLedSequenceOff(ledId: Long, color: Long) {
        queueOrExecute {
            it.setLedSequenceOff(ledId.toInt(), color.toInt())
        }
    }
}
