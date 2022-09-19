package com.nikitavasin.dynamic_launch_icon

import android.app.Activity
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.AdaptiveIconDrawable
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.graphics.drawable.LayerDrawable
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream
import kotlin.math.roundToInt

// channels
private const val CHANNEL_NAME = "dynamic_icon"

// events
private const val GET_DYNAMIC_ICONS_AVAILABLE_STATE = "getDynamicIconsAvailableState"
private const val GET_AVAILABLE_DYNAMIC_ICONS = "getAvailableDynamicIcons"
private const val GET_ACTIVE_DYNAMIC_ICON = "getActiveDynamicIcon"
private const val SET_ACTIVE_DYNAMIC_ICON = "setActiveDynamicIcon"

// constants
private const val ICON_ID = "id"
private const val ICON_NAME = "name"
private const val ICON_PREVIEW = "iconPreview"
private const val DYNAMIC_ICON_NAME = "dynamicIconName"
private const val DYNAMIC_ICON_PREVIEW = "dynamicIconPreview"

/** DynamicLaunchIconPlugin */
class DynamicLaunchIconPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var context: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    private fun getActiveIconActivityName(activity: Context): String {
        val mainIntent = Intent(Intent.ACTION_MAIN, null)
        mainIntent.addCategory(Intent.CATEGORY_LAUNCHER)
        val infoList = activity.packageManager.queryIntentActivities(
            mainIntent,
            0,
        ).filter {
            activity.packageName.equals(it.activityInfo.packageName)
        }
        return infoList.first().activityInfo.name
    }

    private fun getAvailableIcons(activity: Context): List<Map<String, Any?>> {
        val mainIntent = Intent(Intent.ACTION_MAIN, null)
        mainIntent.addCategory(Intent.CATEGORY_LAUNCHER)

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            activity.packageManager.queryIntentActivities(
                mainIntent,
                PackageManager.GET_META_DATA
                        or PackageManager.MATCH_DISABLED_COMPONENTS,
            )
        } else {
            activity.packageManager.queryIntentActivities(
                mainIntent,
                PackageManager.GET_META_DATA
                        or PackageManager.GET_DISABLED_COMPONENTS,
            )
        }.filter {
            it.activityInfo.packageName.equals(activity.packageName)
        }.map {
            val activityInfo = it.activityInfo

            val map = HashMap<String, Any?>()
            val preview = activityInfo.metaData?.getInt(DYNAMIC_ICON_PREVIEW)

            map[ICON_ID] = activityInfo.name
            map[ICON_NAME] = activityInfo.metaData?.getString(DYNAMIC_ICON_NAME)

            map[ICON_PREVIEW] = try {
                if (preview != null && preview != 0) {
                    ContextCompat.getDrawable(activity, preview)
                } else {
                    activityInfo.loadIcon(activity.packageManager)
                }?.let { drawable ->
                    val bmp = getBitmapFromDrawable(drawable)
                    val stream = ByteArrayOutputStream()
                    bmp?.compress(Bitmap.CompressFormat.PNG, 100, stream)
                    stream.toByteArray()
                }
            } catch (e: Exception) {
                null
            }
            map
        }
    }

    private fun getBitmapFromDrawable(drawable: Drawable): Bitmap? {
        if (drawable is BitmapDrawable) {
            return drawable.bitmap
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && drawable is AdaptiveIconDrawable) {
            val backgroundDr = drawable.background
            val foregroundDr = drawable.foreground
            val drr = arrayOfNulls<Drawable>(2)

            drr[0] = backgroundDr
            drr[1] = foregroundDr
            val layerDrawable = LayerDrawable(drr)
            val width = layerDrawable.intrinsicWidth
            val height = layerDrawable.intrinsicHeight
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            layerDrawable.apply {
                setBounds(0, 0, canvas.width, canvas.height)
                draw(canvas)
            }
            return bitmap
        } else {
            return null
        }
    }

    private fun setActiveIcon(activity: Activity, name: String) {
        val activeActivityName = getActiveIconActivityName(activity)
        if (name != activeActivityName) {
            activity.packageManager.setComponentEnabledSetting(
                ComponentName(
                    activity,
                    name,
                ),
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP,
            )
            activity.packageManager.setComponentEnabledSetting(
                ComponentName(
                    activity,
                    activeActivityName,
                ),
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP,
            )
        }
        activity.finish()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val activity = context
        if (activity != null) {
            when (call.method) {
                GET_ACTIVE_DYNAMIC_ICON -> result.success(getActiveIconActivityName(activity))
                GET_AVAILABLE_DYNAMIC_ICONS -> result.success(getAvailableIcons(activity))
                GET_DYNAMIC_ICONS_AVAILABLE_STATE -> result.success(true)
                SET_ACTIVE_DYNAMIC_ICON -> {
                    setActiveIcon(activity, call.arguments as String)
                    result.success(null)
                }
            }
        } else {
            result.error("1", "Context not available", null)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        context = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        context = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        context = binding.activity
    }

    override fun onDetachedFromActivity() {
        context = null
    }
}
