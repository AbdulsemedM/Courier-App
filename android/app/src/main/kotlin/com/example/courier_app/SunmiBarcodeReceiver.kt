package com.hudhud.courier

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log

class SunmiBarcodeReceiver(private val onBarcodeScanned: (String) -> Unit) : BroadcastReceiver() {
    
    override fun onReceive(context: Context, intent: Intent) {
        try {
            val action = intent.action
            Log.d("SunmiBarcodeReceiver", "Received broadcast: action=$action")
            
            // Log all extras for debugging
            val extras = intent.extras
            if (extras != null) {
                val keys = extras.keySet()
                Log.d("SunmiBarcodeReceiver", "Intent extras keys: ${keys.joinToString(", ")}")
                for (key in keys) {
                    val value = extras.get(key)
                    Log.d("SunmiBarcodeReceiver", "  $key = $value")
                }
            }
            
            // Try to extract barcode from various possible keys
            var barcode: String? = null
            
            // First, try to extract from all possible keys regardless of action
            if (extras != null) {
                val possibleKeys = listOf(
                    "data", "barcode", "value", "SCAN_BARCODE1", "SCAN_BARCODE",
                    "code", "result", "content", "text", "string"
                )
                for (key in possibleKeys) {
                    val value = extras.get(key)
                    if (value is String && value.isNotEmpty()) {
                        barcode = value
                        Log.d("SunmiBarcodeReceiver", "Found barcode in key '$key': $barcode")
                        break
                    }
                }
            }
            
            // If not found, try action-specific extraction
            if (barcode.isNullOrEmpty()) {
            when (action) {
                "com.sunmi.scanner.ACTION_DATA_CODE_RECEIVED" -> {
                    barcode = intent.getStringExtra("data") ?: 
                             intent.getStringExtra("barcode") ?:
                             intent.getStringExtra("value")
                    val type = intent.getIntExtra("type", -1)
                    Log.d("SunmiBarcodeReceiver", "Sunmi scanner - barcode: $barcode, type: $type")
                }
                "com.sunmi.scanner.ACTION_DECODE" -> {
                    barcode = intent.getStringExtra("barcode") ?:
                             intent.getStringExtra("data")
                    Log.d("SunmiBarcodeReceiver", "Sunmi decode - barcode: $barcode")
                }
                "com.sunmi.scanner.ACTION_DECODE_DATA" -> {
                    barcode = intent.getStringExtra("data") ?:
                             intent.getStringExtra("barcode")
                    Log.d("SunmiBarcodeReceiver", "Sunmi decode data - barcode: $barcode")
                }
                "nlscan.action.SCANNER_RESULT" -> {
                    barcode = intent.getStringExtra("SCAN_BARCODE1") ?:
                             intent.getStringExtra("barcode") ?:
                             intent.getStringExtra("data")
                    Log.d("SunmiBarcodeReceiver", "NLScan - barcode: $barcode")
                }
                "com.seuic.scanner.action.SCANNER_RESULT" -> {
                    barcode = intent.getStringExtra("barcode") ?:
                             intent.getStringExtra("data")
                    Log.d("SunmiBarcodeReceiver", "Seuic - barcode: $barcode")
                }
                "com.scanner.action.BARCODE_DECODING_DATA" -> {
                    barcode = intent.getStringExtra("data") ?:
                             intent.getStringExtra("barcode")
                    Log.d("SunmiBarcodeReceiver", "Scanner decoding - barcode: $barcode")
                }
                "com.sunmi.scanner.ACTION_DECODE_FAILURE" -> {
                    Log.w("SunmiBarcodeReceiver", "Scan failed")
                    return
                }
                else -> {
                    // Already tried extracting above, just log
                    if (barcode.isNullOrEmpty()) {
                        Log.d("SunmiBarcodeReceiver", "Unknown action: $action, no barcode found in common keys")
                    }
                }
            }
            }
            
            // Process barcode if found
            if (!barcode.isNullOrEmpty()) {
                Log.d("SunmiBarcodeReceiver", "✅ Processing barcode: $barcode")
                Log.d("SunmiBarcodeReceiver", "Calling onBarcodeScanned callback...")
                onBarcodeScanned(barcode)
                Log.d("SunmiBarcodeReceiver", "Callback completed")
            } else {
                Log.w("SunmiBarcodeReceiver", "⚠️ Barcode is null or empty, not processing")
            }
        } catch (e: Exception) {
            Log.e("SunmiBarcodeReceiver", "Error processing barcode: ${e.message}", e)
        }
    }
}

