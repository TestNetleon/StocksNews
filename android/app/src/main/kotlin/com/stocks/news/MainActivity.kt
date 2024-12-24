// package com.stocks.news

// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.android.FlutterFragmentActivity

// class MainActivity: FlutterFragmentActivity()



package com.stocks.news

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannels()
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "stocks_news_channelId"
            val channelName = "Stocks.News Channel"
            val channelDescription = "Channel for notifications"
            val importance = NotificationManager.IMPORTANCE_HIGH

            // Set the custom sound URI
            val soundUri: Uri = Uri.parse("android.resource://${packageName}/raw/notifications")

            val channel = NotificationChannel(channelId, channelName, importance).apply {
                description = channelDescription
                setSound(soundUri, null) // Attach the custom sound
            }

            // Register the channel with the notification manager
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }
}
