import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/service/braze/service.dart';
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

//-----------------------------------------------------
//-----------------------------------------------------
//-----------------------------------------------------
//Remove this method to stop OneSignal Debugging
  // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // OneSignal.initialize("da811ab1-8239-4155-99f1-ebc15b20160b");
  // OneSignal.Notifications.requestPermission(true);
  // OneSignalService().initNotifications();

//-----------------------------------------------------
//-----------------------------------------------------
//-----------------------------------------------------

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      // options: FirebaseOptions(
      //   apiKey: ApiKeys.apiKey,
      //   appId: ApiKeys.appId,
      //   messagingSenderId: ApiKeys.messagingSenderId,
      //   projectId: ApiKeys.projectId,
      // ),
    );
    // BrazeNotificationService().initialize();

    FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
    BrazeService().initialize();
    // BrazeNotificationService.initializeNotificationService();

    AmplitudeService.initialize();
    Timer(const Duration(seconds: 8), () {
      Preference.setIsFirstOpen(false);
    });
  } catch (e) {
    Utils().showLog('Error initializing Firebase: $e');
  }

  // FirebaseApi().initNotifications();
  splashLoaded = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}
