package com.evemarketapp.eve_online_market_application

import android.content.Context
import android.content.res.AssetFileDescriptor
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.loader.FlutterLoader
import java.io.InputStream

fun getInvTypeIconBitmap(context : Context, typeID : Int) : Bitmap {
    val loader : FlutterLoader = FlutterInjector.instance().flutterLoader()
    lateinit var bmp : Bitmap
    try {
        val key : String = loader.getLookupKeyForAsset("assets/icons/invTypeIcons/${typeID}.png")
        val fd : AssetFileDescriptor = context.assets.openFd(key)
        val inputStream : InputStream = fd.createInputStream()
        bmp = BitmapFactory.decodeStream(inputStream)

        inputStream.close()
    }
    catch (_: Exception) {
        val key : String = loader.getLookupKeyForAsset("assets/icons/invTypeIcons/0.png")
        val fd : AssetFileDescriptor = context.assets.openFd(key)
        val inputStream : InputStream = fd.createInputStream()
        bmp = BitmapFactory.decodeStream(inputStream)
    }

    return bmp
}