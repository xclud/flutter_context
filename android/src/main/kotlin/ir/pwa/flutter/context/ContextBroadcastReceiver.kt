package ir.pwa.flutter.context

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONException

import org.json.JSONObject


class ContextBroadcastReceiver(private val methodChannel: MethodChannel) : BroadcastReceiver() {

    @SuppressLint("NewApi")
    override fun onReceive(p0: Context?, p1: Intent?) {
        if (p1 == null) {
            return;
        }


        val json = HashMap<String, Any?>()
        json["action"] = p1.action
        json["data"] = p1.data?.toString()
        json["flags"] = p1.flags
        json["type"] = p1.type

        if (p1.extras != null) {
            val keys = p1.extras!!.keySet()
            val extras = HashMap<String, Any?>()

            for (key in keys) {
                try {
                    extras[key] = p1.extras!!.get(key)
                } catch (e: JSONException) {
                    //Handle exception here
                }
            }
            json["extras"] = extras
        }

        methodChannel.invokeMethod("packagemanager", json)
    }
}