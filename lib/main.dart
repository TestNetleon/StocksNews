import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stocks_news_new/fcm/braze_notification_handler.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'firebase_options.dart';

// Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
//   // This will be called when the app is terminated or in the background
//   print('Handling a background message: ${message.messageId}');

//   // Process the push notification data here, you can extract data from `message.data`
//   if (message.data.isNotEmpty) {
//     // Handle the data (push notification payload)
//     print('Push Notification Data: ${message.data}');
//   }
// }

// void onMessageOpened(RemoteMessage message) {
//   Timer(const Duration(seconds: 2), () {
//     showConfirmAlertDialog(
//       context: navigatorKey.currentContext!,
//       title: "Notification Click",
//       message: "App is opened from terminated state",
//     );
//   });
//   // This will be called when the app is launched from a notification tap
//   print('App opened via notification: ${message.messageId}');

//   // Handle the data (push notification payload)
//   if (message.data.isNotEmpty) {
//     // Process your data here
//     print('Push Notification Data: ${message.data}');
//   }
// }

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } catch (e) {
    if (kDebugMode) print(e.toString());
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  try {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,

        // options: FirebaseOptions(

        //   apiKey: Platform.isAndroid
        //       ? ApiKeys.apiKey
        //       : "AIzaSyAT0DHf6hY6rEHqXS6eQJ_-8Fqa8pLnMio",
        //   appId: ApiKeys.appId,
        //   messagingSenderId: ApiKeys.messagingSenderId,
        //   projectId: ApiKeys.projectId,
        // ),
      );
      FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
    } catch (e) {
      Utils().showLog('Firebase catch: $e');
    }

    BrazeService().initialize();
    // BrazeNotificationService.initializeNotificationService();

    AmplitudeService.initialize();
    Timer(const Duration(seconds: 8), () {
      Preference.setIsFirstOpen(false);
    });

    try {
      NotificationHandler.instance.initialize();
      // FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
      // // Check if notification data is received when the app is launched from a terminated state
      // FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpened);
    } catch (e) {
      //
    }
  } catch (e) {
    Utils().showLog('Error initializing Firebase: $e');
  }

  // FirebaseApi().initNotifications();
  // BrazeNotificationService().brazeNotificationInitialize();
  splashLoaded = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}
