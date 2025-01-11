package com.evemarketapp.eve_online_market_application

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import android.content.Context
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
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
import androidx.glance.layout.Row
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.Text


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

        val typeIDs = listOf(44992, 62628, 4405, 2, 3, 4, 5, 6, 7, 8, 9, 10)

        MaterialTheme {
            Box(
                modifier = GlanceModifier
                    .background(Color.White)
                    .padding(16.dp)
            ) {
                LazyColumn {
                    items(typeIDs.size) { index: Int ->
                        val bmp = getInvTypeIconBitmap(context, typeIDs[index])
                        Row {
                            Image(
                                provider = ImageProvider(bmp),
                                contentDescription = "an image",
                                modifier = GlanceModifier
                                    .size(64.dp)
                            )
                            Text(
                                text = "ID ${typeIDs[index]}",
                            )
                        }
                    }
                }
            }
        }

    }
}