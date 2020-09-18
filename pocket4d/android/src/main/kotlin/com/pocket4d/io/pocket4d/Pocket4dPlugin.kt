package com.pocket4d.io.pocket4d

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Message
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import org.json.JSONObject


/** Pocket4dPlugin */
class Pocket4dPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {



    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        messenger = flutterPluginBinding.binaryMessenger
        onAttachedToEngine(flutterPluginBinding.applicationContext, messenger)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        println("onAttachedToEngine yet implemented")
        appContext = applicationContext
        methodChannel = MethodChannel(messenger, Basic.Constant.METHOD_CHANNEL_NAME)
        methodChannel.setMethodCallHandler(this)
        basicChannel = BasicMessageChannel<String>(messenger, Basic.Constant.BASIC_CHANNEL_NAME, StringCodec.INSTANCE)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }


    override fun onDetachedFromActivity() {
        println("onDetachedFromActivity Not yet implemented")

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mActivity = binding.activity
        // TODO("Not yet implemented")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
        println("onAttachedToActivity yet implemented")

        // TODO("Not yet implemented")
    }


    override fun onDetachedFromActivityForConfigChanges() {
        // TODO("Not yet implemented")
    }



    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        lateinit var appContext: Context
        lateinit var messenger: BinaryMessenger
        lateinit var methodChannel: MethodChannel
        lateinit var basicChannel: BasicMessageChannel<String>
        lateinit var mActivity: Activity


        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val instance = Pocket4dPlugin()
            instance.onAttachedToEngine(registrar.activity(), registrar.messenger())
        }

        @JvmStatic
        fun sendMessage2Flutter(type: Int, pageId: String, content: String) {
            val jsonObject = JSONObject()
            jsonObject.put("type", type)
            jsonObject.put("pageId", pageId)
            jsonObject.put("message", content)
            basicChannel.send(jsonObject.toString())
        }
    }

}
