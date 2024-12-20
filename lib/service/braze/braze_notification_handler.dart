// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:braze_plugin/braze_plugin.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/utils/dialogs.dart';

// class NotificationHandler {
//   static final BrazePlugin _braze = BrazePlugin();
//   static StreamSubscription? _pushSubscription;

//   static Future<void> initialize() async {
//     try {
//       // Enable SDK
//       _braze.enableSDK();

//       // Setup notification listeners
//       _setupNotificationListeners();

//       // Register for push notifications
//       // await _braze.requestPushPermission();

//       debugPrint('Braze notification system initialized successfully');
//     } catch (e) {
//       debugPrint('Error initializing Braze: $e');
//     }
//   }

//   static void _setupNotificationListeners() {
//     _pushSubscription?.cancel();
//     _pushSubscription =
//         _braze.subscribeToPushNotificationEvents((BrazePushEvent event) {
//       Timer(const Duration(seconds: 2), () {
//         showConfirmAlertDialog(
//           context: navigatorKey.currentContext!,
//           title: "Notification RECEIVED NEW",
//           message: event.toString(),
//         );
//       });

//       debugPrint('Notification event received: ${event.toString()}');

//       _handleNotificationPayload(event);
//     });
//   }

//   static void _handleNotificationPayload(BrazePushEvent event) {}

//   static void dispose() {
//     _pushSubscription?.cancel();
//   }
// }
