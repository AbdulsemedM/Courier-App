package com.hudhud.courier

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.hudhud.courier/sunmi_scanner"
    private var barcodeReceiver: BroadcastReceiver? = null
    private var flutterEngineInstance: FlutterEngine? = null
    private var methodChannel: MethodChannel? = null
    private var scanServiceConnection: android.content.ServiceConnection? = null
    private var scanInterface: Any? = null // Will hold the AIDL interface

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngineInstance = flutterEngine
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        
        // Auto-register receiver if device is Sunmi (for immediate scanning)
        val isSunmi = Build.MANUFACTURER.equals("SUNMI", ignoreCase = true) ||
                     Build.MODEL.contains("SUNMI", ignoreCase = true) ||
                     Build.MODEL.contains("V3", ignoreCase = true)
        if (isSunmi) {
            Log.d("MainActivity", "Sunmi device detected - Manufacturer: ${Build.MANUFACTURER}, Model: ${Build.MODEL}")
            Log.d("MainActivity", "Auto-registering receiver and enabling scanner")
            registerBarcodeReceiver()
            
            // Try multiple ways to enable scanner immediately
            val enableActions = listOf(
                "com.sunmi.scanner.ACTION_ENABLE_SCANNER",
                "com.sunmi.scanner.ACTION_OPEN_SCANNER",
                "com.sunmi.scanner.ACTION_START_SCAN"
            )
            
            enableActions.forEach { action ->
                try {
                    val enableIntent = Intent(action)
                    sendBroadcast(enableIntent)
                    Log.d("MainActivity", "Sent initial scanner intent: $action")
                } catch (e: Exception) {
                    Log.d("MainActivity", "Could not send $action: ${e.message}")
                }
            }
            
            // Also try to open scanner service
            try {
                val serviceIntent = Intent().apply {
                    action = "com.sunmi.scanner.ACTION_OPEN_SCANNER"
                }
                startService(serviceIntent)
                Log.d("MainActivity", "Tried to start scanner service on init")
            } catch (e: Exception) {
                Log.d("MainActivity", "Could not start scanner service on init: ${e.message}")
            }
        } else {
            Log.d("MainActivity", "Not a Sunmi device - Manufacturer: ${Build.MANUFACTURER}, Model: ${Build.MODEL}")
        }
        
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "isScannerAvailable" -> {
                    try {
                        // Check if device is Sunmi
                        val isSunmi = Build.MANUFACTURER.equals("SUNMI", ignoreCase = true) ||
                                     Build.MODEL.contains("SUNMI", ignoreCase = true) ||
                                     Build.MODEL.contains("V3", ignoreCase = true)
                        Log.d("MainActivity", "Device check - Manufacturer: ${Build.MANUFACTURER}, Model: ${Build.MODEL}, IsSunmi: $isSunmi")
                        result.success(isSunmi)
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error checking scanner: ${e.message}", e)
                        result.success(false)
                    }
                }
                "startScan" -> {
                    try {
                        Log.d("MainActivity", "startScan called - registering receiver and activating scanner")
                        
                        // Register broadcast receiver for Sunmi barcode scans
                        registerBarcodeReceiver()
                        
                        // Try multiple ways to enable/start/open the scanner
                        val scannerActions = listOf(
                            "com.sunmi.scanner.ACTION_ENABLE_SCANNER",
                            "com.sunmi.scanner.ACTION_START_SCAN",
                            "com.sunmi.scanner.ACTION_OPEN_SCANNER",
                            "com.sunmi.scanner.ACTION_TRIGGER_SCAN",
                            "com.sunmi.scanner.ACTION_SCAN",
                            "com.sunmi.scanner.START_SCAN",
                            "com.sunmi.scanner.ENABLE",
                            "com.sunmi.scanner.OPEN"
                        )
                        
                        scannerActions.forEach { action ->
                            try {
                                val intent = Intent(action)
                                sendBroadcast(intent)
                                Log.d("MainActivity", "Sent broadcast: $action")
                            } catch (e: Exception) {
                                Log.d("MainActivity", "Failed to send $action: ${e.message}")
                            }
                        }
                        
                        // Try to open scanner via intent to system scanner service
                        val scannerPackages = listOf(
                            "com.sunmi.scanner",
                            "com.sunmi.service",
                            "com.sunmi.hardware",
                            "com.sunmi.scanner.service"
                        )
                        
                        scannerPackages.forEach { packageName ->
                            try {
                                val scannerIntent = Intent().apply {
                                    action = "com.sunmi.scanner.ACTION_OPEN_SCANNER"
                                    setPackage(packageName)
                                }
                                startActivity(scannerIntent)
                                Log.d("MainActivity", "Tried to start scanner activity with package: $packageName")
                            } catch (e: Exception) {
                                Log.d("MainActivity", "Could not start scanner activity with $packageName: ${e.message}")
                            }
                        }
                        
                        // Try to request scanner focus (some devices need this)
                        try {
                            val focusIntent = Intent("com.sunmi.scanner.ACTION_REQUEST_FOCUS")
                            sendBroadcast(focusIntent)
                            Log.d("MainActivity", "Sent request focus intent")
                        } catch (e: Exception) {
                            Log.d("MainActivity", "Could not request focus: ${e.message}")
                        }
                        
                        // Try to open scanner using system service (if available)
                        try {
                            val serviceIntent = Intent().apply {
                                action = "android.intent.action.VIEW"
                                setClassName("com.sunmi.scanner", "com.sunmi.scanner.ScannerService")
                            }
                            startService(serviceIntent)
                            Log.d("MainActivity", "Tried to start scanner service")
                        } catch (e: Exception) {
                            Log.d("MainActivity", "Could not start scanner service: ${e.message}")
                        }
                        
                        // Try using AIDL service (common Sunmi approach)
                        // Sunmi scanners require binding to AIDL service and calling scan()
                        val aidlPackages = listOf(
                            "com.sunmi.scanner",
                            "com.sunmi.service",
                            "com.sunmi.hardware",
                            "com.sunmi.scanner.service"
                        )
                        
                        aidlPackages.forEach { packageName ->
                            try {
                                val aidlIntent = Intent("com.sunmi.scanner.IScanInterface")
                                aidlIntent.setPackage(packageName)
                                
                                scanServiceConnection = object : android.content.ServiceConnection {
                                    override fun onServiceConnected(name: android.content.ComponentName?, service: android.os.IBinder?) {
                                        Log.d("MainActivity", "✅ AIDL service connected: $packageName")
                                        scanInterface = service
                                        
                                        // Try to call scan() method via reflection
                                        try {
                                            // Use reflection to call scan() method
                                            val scanMethod = service?.javaClass?.getMethod("scan")
                                            scanMethod?.invoke(service)
                                            Log.d("MainActivity", "✅ Called scan() via reflection on AIDL service")
                                        } catch (e: Exception) {
                                            Log.d("MainActivity", "Could not call scan() via reflection: ${e.message}")
                                            // Try alternative: use asInterface if we have the AIDL stub
                                            try {
                                                // Some Sunmi devices use this pattern
                                                val transactMethod = android.os.Binder::class.java.getMethod("transact", Int::class.java, android.os.Parcel::class.java, android.os.Parcel::class.java, Int::class.java)
                                                Log.d("MainActivity", "Trying transact method")
                                            } catch (e2: Exception) {
                                                Log.d("MainActivity", "Could not use transact: ${e2.message}")
                                            }
                                        }
                                    }
                                    
                                    override fun onServiceDisconnected(name: android.content.ComponentName?) {
                                        Log.d("MainActivity", "AIDL service disconnected: $packageName")
                                        scanInterface = null
                                    }
                                }
                                
                                val bound = bindService(aidlIntent, scanServiceConnection!!, Context.BIND_AUTO_CREATE)
                                if (bound) {
                                    Log.d("MainActivity", "✅ Successfully bound to AIDL service: $packageName")
                                } else {
                                    Log.d("MainActivity", "Could not bind to AIDL service: $packageName")
                                }
                            } catch (e: Exception) {
                                Log.d("MainActivity", "Could not bind to AIDL service $packageName: ${e.message}")
                            }
                        }
                        
                        // Also try the broadcast approach as fallback
                        try {
                            val aidlBroadcast = Intent("com.sunmi.scanner.IScanInterface")
                            sendBroadcast(aidlBroadcast)
                            Log.d("MainActivity", "Sent AIDL scanner broadcast (fallback)")
                        } catch (e: Exception) {
                            Log.d("MainActivity", "Could not send AIDL broadcast: ${e.message}")
                        }
                        
                        // Try KeyEvent simulation (some Sunmi devices can be triggered this way)
                        try {
                            val keyEvent = KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_F1)
                            dispatchKeyEvent(keyEvent)
                            Log.d("MainActivity", "Sent KeyEvent to trigger scanner")
                        } catch (e: Exception) {
                            Log.d("MainActivity", "Could not send KeyEvent: ${e.message}")
                        }
                        
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error starting scan: ${e.message}", e)
                        result.error("START_SCAN_ERROR", e.message, null)
                    }
                }
                "stopScan" -> {
                    try {
                        unregisterBarcodeReceiver()
                        
                        // Unbind AIDL service
                        scanServiceConnection?.let { connection ->
                            try {
                                unbindService(connection)
                                Log.d("MainActivity", "Unbound AIDL service")
                            } catch (e: Exception) {
                                Log.d("MainActivity", "Could not unbind service: ${e.message}")
                            }
                        }
                        scanServiceConnection = null
                        scanInterface = null
                        
                        result.success(true)
                    } catch (e: Exception) {
                        Log.e("MainActivity", "Error stopping scan: ${e.message}", e)
                        result.error("STOP_SCAN_ERROR", e.message, null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun registerBarcodeReceiver() {
        // Always re-register to ensure it's active
        if (barcodeReceiver != null) {
            try {
                unregisterReceiver(barcodeReceiver)
                Log.d("MainActivity", "Unregistered old receiver before re-registering")
            } catch (e: Exception) {
                Log.d("MainActivity", "No old receiver to unregister: ${e.message}")
            }
        }
        
        barcodeReceiver = SunmiBarcodeReceiver { barcode ->
            Log.d("MainActivity", "✅✅✅ Barcode received from scanner: $barcode")
            Log.d("MainActivity", "Method channel exists: ${methodChannel != null}")
            Log.d("MainActivity", "Sending barcode to Flutter via method channel...")
            
            // Run on main thread to ensure proper delivery
            runOnUiThread {
                try {
                    methodChannel?.invokeMethod("onBarcodeScanned", barcode, object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            Log.d("MainActivity", "✅✅✅ Barcode sent to Flutter successfully: $barcode")
                        }
                        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                            Log.e("MainActivity", "❌ Error sending barcode to Flutter: $errorMessage")
                        }
                        override fun notImplemented() {
                            Log.e("MainActivity", "❌ Method channel not implemented")
                        }
                    })
                } catch (e: Exception) {
                    Log.e("MainActivity", "❌ Exception sending barcode: ${e.message}", e)
                    e.printStackTrace()
                }
            }
            
            // Re-activate scanner immediately after scan (keep it open)
            try {
                val reactivateIntent = Intent("com.sunmi.scanner.ACTION_OPEN_SCANNER")
                sendBroadcast(reactivateIntent)
                Log.d("MainActivity", "Re-activated scanner after scan")
            } catch (e: Exception) {
                Log.d("MainActivity", "Could not re-activate scanner: ${e.message}")
            }
        }

        val filter = IntentFilter().apply {
            // Sunmi standard broadcast actions
            addAction("com.sunmi.scanner.ACTION_DATA_CODE_RECEIVED")
            addAction("com.sunmi.scanner.ACTION_DECODE")
            addAction("com.sunmi.scanner.ACTION_DECODE_DATA")
            addAction("com.sunmi.scanner.ACTION_DECODE_FAILURE")
            // Alternative broadcast formats
            addAction("nlscan.action.SCANNER_RESULT")
            addAction("com.seuic.scanner.action.SCANNER_RESULT")
            addAction("com.scanner.action.BARCODE_DECODING_DATA")
            // More possible actions
            addAction("com.sunmi.scanner.SCAN")
            addAction("com.sunmi.scanner.SCAN_RESULT")
            addAction("com.sunmi.scanner.DATA")
            // Generic data code received
            addAction("android.intent.action.VIEW")
            addDataScheme("barcode")
        }
        
        // Also register a catch-all receiver to see ALL broadcasts (for debugging)
        // This will catch ANY broadcast that might be scanner-related
        val debugReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val action = intent.action
                // Log ALL broadcasts (we'll filter in logcat if needed)
                if (action != null) {
                    Log.d("MainActivity", "🔍🔍🔍 DEBUG: Received ANY broadcast - action: $action")
                    val extras = intent.extras
                    if (extras != null && !extras.isEmpty) {
                        Log.d("MainActivity", "🔍🔍🔍 DEBUG: Broadcast has extras:")
                        for (key in extras.keySet()) {
                            val value = extras.get(key)
                            Log.d("MainActivity", "🔍🔍🔍 DEBUG:   $key = $value (type: ${value?.javaClass?.simpleName})")
                        }
                    } else {
                        Log.d("MainActivity", "🔍🔍🔍 DEBUG: Broadcast has no extras")
                    }
                }
            }
        }
        
        // Register for ALL possible scanner-related actions
        try {
            val debugFilter = IntentFilter()
            // Add all possible scanner-related actions
            val allPossibleActions = listOf(
                "com.sunmi.scanner.ACTION_DATA_CODE_RECEIVED",
                "com.sunmi.scanner.ACTION_DECODE",
                "com.sunmi.scanner.ACTION_DECODE_DATA",
                "com.sunmi.scanner.ACTION_DECODE_FAILURE",
                "com.sunmi.scanner.ACTION_ENABLE_SCANNER",
                "com.sunmi.scanner.ACTION_START_SCAN",
                "com.sunmi.scanner.ACTION_OPEN_SCANNER",
                "com.sunmi.scanner.ACTION_TRIGGER_SCAN",
                "com.sunmi.scanner.ACTION_SCAN",
                "com.sunmi.scanner.START_SCAN",
                "com.sunmi.scanner.ENABLE",
                "com.sunmi.scanner.OPEN",
                "nlscan.action.SCANNER_RESULT",
                "com.seuic.scanner.action.SCANNER_RESULT",
                "com.scanner.action.BARCODE_DECODING_DATA",
                "com.sunmi.scanner.SCAN",
                "com.sunmi.scanner.SCAN_RESULT",
                "com.sunmi.scanner.DATA",
                Intent.ACTION_VIEW
            )
            allPossibleActions.forEach { debugFilter.addAction(it) }
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(debugReceiver, debugFilter, Context.RECEIVER_NOT_EXPORTED)
            } else {
                registerReceiver(debugReceiver, debugFilter)
            }
            Log.d("MainActivity", "Debug receiver registered for ${allPossibleActions.size} actions")
        } catch (e: Exception) {
            Log.e("MainActivity", "Error registering debug receiver: ${e.message}", e)
        }

        // Register the main barcode receiver
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(barcodeReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
            } else {
                registerReceiver(barcodeReceiver, filter)
            }
            Log.d("MainActivity", "✅ Barcode receiver registered successfully")
            val actions = mutableListOf<String>()
            filter.actionsIterator().forEach { actions.add(it) }
            Log.d("MainActivity", "Listening for actions: ${actions.joinToString(", ")}")
        } catch (e: Exception) {
            Log.e("MainActivity", "❌ Error registering receiver: ${e.message}", e)
            e.printStackTrace()
        }
    }

    private fun unregisterBarcodeReceiver() {
        barcodeReceiver?.let {
            try {
                unregisterReceiver(it)
                Log.d("MainActivity", "Barcode receiver unregistered")
            } catch (e: Exception) {
                Log.e("MainActivity", "Error unregistering receiver: ${e.message}", e)
            }
            barcodeReceiver = null
        }
    }

    override fun onResume() {
        super.onResume()
        // Re-register receiver when activity resumes
        if (barcodeReceiver != null) {
            registerBarcodeReceiver()
        }
        
        // Re-activate scanner when activity resumes (keeps scanner active)
        val isSunmi = Build.MANUFACTURER.equals("SUNMI", ignoreCase = true) ||
                     Build.MODEL.contains("SUNMI", ignoreCase = true) ||
                     Build.MODEL.contains("V3", ignoreCase = true)
        if (isSunmi && methodChannel != null) {
            try {
                methodChannel?.invokeMethod("startScan", null, object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        Log.d("MainActivity", "Scanner reactivated on resume")
                    }
                    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                        Log.d("MainActivity", "Could not reactivate scanner: $errorMessage")
                    }
                    override fun notImplemented() {
                        Log.d("MainActivity", "startScan not implemented")
                    }
                })
            } catch (e: Exception) {
                Log.d("MainActivity", "Error reactivating scanner on resume: ${e.message}")
            }
        }
    }

    override fun onPause() {
        super.onPause()
        // Keep receiver registered in pause (scanner should work in background)
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterBarcodeReceiver()
        
        // Unbind AIDL service
        scanServiceConnection?.let { connection ->
            try {
                unbindService(connection)
                Log.d("MainActivity", "Unbound AIDL service on destroy")
            } catch (e: Exception) {
                Log.d("MainActivity", "Could not unbind service on destroy: ${e.message}")
            }
        }
        scanServiceConnection = null
        scanInterface = null
        
        methodChannel = null
        flutterEngineInstance = null
    }
}
