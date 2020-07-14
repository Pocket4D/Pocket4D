package com.pocket4d.io.pocket4d.bridge

import android.annotation.SuppressLint
import android.util.Log
import de.prosiebensat1digital.oasisjsbridge.JsBridge
import de.prosiebensat1digital.oasisjsbridge.JsBridgeConfig
import de.prosiebensat1digital.oasisjsbridge.JsBridgeError
import de.prosiebensat1digital.oasisjsbridge.JsonObjectWrapper
import kotlinx.coroutines.*

class JSEngine {
    private val messages = mutableListOf<Pair<Int, String>>()
    private val config = JsBridgeConfig.bareConfig().apply {
        consoleConfig.enabled = true
        consoleConfig.mode = JsBridgeConfig.ConsoleConfig.Mode.AsString
        consoleConfig.appendMessage = { priority, message ->
            messages.add(priority to message)
        }
    }
    private var runtime: JsBridge
    private val errorTag = "JSEngine"
    var runtimeInitialized = false

    init {
        runtime = JsBridge(config)
        // log()
        val errorListener = object : JsBridge.ErrorListener(Dispatchers.Main) {
            @SuppressLint("LogNotTimber")
            override fun onError(error: JsBridgeError) {
                Log.e(errorTag, error.errorString())
            }
        }
        runtime.registerErrorListener(errorListener)

    }


    fun eval(script: String): JsonObjectWrapper {
        return runtime.evaluateBlocking(script, JsonObjectWrapper::class.java) as JsonObjectWrapper
    }

    fun evalVoid(script: String) {
        runtime.evaluateNoRetVal(script)
    }

    fun release() {
        runtime.release()
    }

    suspend fun waitForDone() {
        try {
            yield()

            // ensure that triggered coroutines are processed
            withContext(this.runtime.coroutineContext) {
                delay(100)
            }

            yield()
        } catch (e: CancellationException) {
            // Ignore cancellation
        }
    }
}