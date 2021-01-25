package ir.pwa.flutter.context

import android.annotation.SuppressLint
import android.content.ComponentName
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.PackageManager.NameNotFoundException
import android.graphics.Bitmap
import android.graphics.Bitmap.CompressFormat
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.util.Base64
import java.io.ByteArrayOutputStream
import java.util.*
import kotlin.collections.HashMap


private const val SYSTEM_APP_MASK = ApplicationInfo.FLAG_SYSTEM or 128

internal fun getBitmapFromDrawable(drawable: Drawable): Bitmap {
    val bmp = Bitmap.createBitmap(
            drawable.intrinsicWidth,
            drawable.intrinsicHeight,
            Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bmp)
    drawable.setBounds(0, 0, canvas.width, canvas.height)
    drawable.draw(canvas)
    return bmp
}

@SuppressLint("InlinedApi")
internal fun encodeToBase64(image: Bitmap, compressFormat: CompressFormat?, quality: Int): String {
    val byteArrayOS = ByteArrayOutputStream()
    image.compress(compressFormat, quality, byteArrayOS)
    return Base64.encodeToString(byteArrayOS.toByteArray(), Base64.NO_WRAP)
}


private fun isSystemApp(pInfo: PackageInfo): Boolean {
    return pInfo.applicationInfo.flags and SYSTEM_APP_MASK != 0
}

@SuppressLint("NewApi")
internal fun getAppData(packageManager: PackageManager, pInfo: PackageInfo, includeAppIcon: Boolean): Map<String, Any?>? {
    val map: MutableMap<String, Any?> = HashMap()
    map["app_name"] = pInfo.applicationInfo.loadLabel(packageManager).toString()
    map["apk_file_path"] = pInfo.applicationInfo.sourceDir
    map["package_name"] = pInfo.packageName
    map["version_code"] = pInfo.versionCode
    map["version_name"] = pInfo.versionName
    map["data_dir"] = pInfo.applicationInfo.dataDir
    map["system_app"] = isSystemApp(pInfo)
    map["install_time"] = pInfo.firstInstallTime
    map["update_time"] = pInfo.lastUpdateTime
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        map["category"] = pInfo.applicationInfo.category
    }
    if (includeAppIcon) {
        try {
            val icon = packageManager.getApplicationIcon(pInfo.packageName)
            val encodedImage = encodeToBase64(getBitmapFromDrawable(icon), CompressFormat.PNG, 100)
            map["app_icon"] = encodedImage
        } catch (ignored: NameNotFoundException) {
        }
    }
    return map
}

fun getIntentFromHashMap(hashMap: HashMap<String, Any?>): Intent {
    val intent = Intent()

    if (hashMap.containsKey("action")) {
        intent.action = hashMap["action"] as String
    }

    if (hashMap.containsKey("data")) {
        val data = hashMap["data"] as String?
        if (data != null) {
            intent.data = Uri.parse(data)
        }
    }

    if (hashMap.containsKey("type")) {
        val type = hashMap["type"] as String?
        intent.type = type
    }

    if (hashMap.containsKey("flags")) {
        intent.flags = hashMap["flags"] as Int
    }


    if (hashMap.containsKey("component")) {
        val c = hashMap["component"] as HashMap<*, *>
        val packageName = c["package"] as String
        val className = c["class"] as String

        intent.component = ComponentName(packageName, className)
    }

    if (hashMap.containsKey("categories")) {
        val cats = hashMap["categories"] as ArrayList<*>;
        for (cat in cats) {
            intent.addCategory(cat as String)
        }
    }

    if (hashMap.containsKey("extras")) {
        val extras = hashMap["extras"] as HashMap<*, *>;

        for (extra in extras) {
            val key = extra.key as String;
            val value = extra.value;
            if (value is Int) {
                intent.putExtra(key, value)
            } else if (value is String) {
                intent.putExtra(key, value)
            }
        }
    }
    return intent;
}