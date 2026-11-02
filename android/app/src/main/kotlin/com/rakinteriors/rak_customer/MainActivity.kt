package com.rakinteriors.rak_customer

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.rakinteriors.rak_customer/floor_placement",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "availability" -> reportAvailability(result, 0)
                "requestInstall" -> requestArInstall(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun reportAvailability(result: MethodChannel.Result, attempt: Int) {
        try {
            val apkClass = Class.forName("com.google.ar.core.ArCoreApk")
            val instance = apkClass.getMethod("getInstance").invoke(null)
            val availability = apkClass
                .getMethod("checkAvailability", Context::class.java)
                .invoke(instance, this)
            val checking = availability.javaClass
                .getMethod("isTransient")
                .invoke(availability) as Boolean
            if (checking && attempt < 15) {
                Handler(Looper.getMainLooper()).postDelayed({
                    reportAvailability(result, attempt + 1)
                }, 200)
                return
            }
            result.success(availability.toString())
        } catch (_: Throwable) {
            result.success("UNKNOWN_ERROR")
        }
    }

    private fun requestArInstall(result: MethodChannel.Result) {
        try {
            val apkClass = Class.forName("com.google.ar.core.ArCoreApk")
            val instance = apkClass.getMethod("getInstance").invoke(null)
            val status = apkClass
                .getMethod(
                    "requestInstall",
                    Activity::class.java,
                    Boolean::class.javaPrimitiveType,
                )
                .invoke(instance, this, true)
            result.success(status.toString())
        } catch (_: Throwable) {
            result.success("UNAVAILABLE")
        }
    }
}
