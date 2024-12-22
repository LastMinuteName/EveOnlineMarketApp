package com.evemarketapp.eve_online_market_application

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import android.content.Context
import android.content.res.AssetFileDescriptor
import android.content.res.AssetManager
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.lazy.LazyColumn
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Box
import androidx.glance.layout.padding
import androidx.glance.text.Text
import io.flutter.FlutterInjector
import io.flutter.plugin.common.PluginRegistry
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.loader.FlutterLoader
import java.io.InputStream


class WatchlistGlanceWidget : GlanceAppWidget() {

    // Needed for Updating
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceContent(context, currentState())
        }
    }

    @Composable
    private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
        val data = currentState.preferences
        val count = data.getInt("counter", 0)
        val loader : FlutterLoader = FlutterInjector.instance().flutterLoader()
        val key : String = loader.getLookupKeyForAsset("assets/icons/invTypeIcons/0.png")
        val fd : AssetFileDescriptor = context.assets.openFd(key)
        val inputStream : InputStream = fd.createInputStream()
        val bmp = BitmapFactory.decodeStream(inputStream)


        MaterialTheme {
            Box(
                modifier = GlanceModifier
                    .background(Color.White)
                    .padding(16.dp)
            ) {
                LazyColumn {
                    item {
                        Image(
                            provider = ImageProvider(bmp),
                            contentDescription = "an image",
                        )
                    }
                    items(20) { index: Int ->
                        Text(
                            text = "Item $index",
                        )
                    }
                }
            }
        }

    }
}