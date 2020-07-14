package com.pocket4d.io.pocket4d

import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object Methods {
    private const val ON_LOAD = "onLoad"
    private const val ATTACH_PAGE = "attachPage"
    private const val GET_PLATFORMVERSION = "getPlatformVersion"
    private const val INIT_COMPLETE = "initComplete"


    fun methodCaller(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            ATTACH_PAGE -> {
                Log.i(ATTACH_PAGE, "wait")
            }
            GET_PLATFORMVERSION -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}