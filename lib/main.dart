import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stocks_news_new/fcm/braze_notification_handler.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'firebase_options.dart';

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

    AmplitudeService.initialize();
    Timer(const Duration(seconds: 8), () {
      Preference.setIsFirstOpen(false);
    });

    try {
      NotificationHandler.instance.initialize();
    } catch (e) {
      //
    }
  } catch (e) {
    Utils().showLog('Error initializing Firebase: $e');
  }

  splashLoaded = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}
