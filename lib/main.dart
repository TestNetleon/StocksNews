import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:stocks_news_new/fcm/service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stocks_news_new/firebase_options.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/help/deeplinks/deeplink_data.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } catch (e) {
    if (kDebugMode) print(e.toString());
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Set your primary dark color
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);

    Timer(const Duration(seconds: 10), () {
      Preference.setIsFirstOpen(false);
    });
  } catch (e) {
    Utils().showLog('Error initializing Firebase: $e');
  }
  FirebaseApi().initNotifications();
  Preference.saveDataList(
    DeeplinkData(
      uri: null,
      from: "Run App at Starting",
      onDeepLink: onDeepLinking,
    ),
  );

  // --------- initially ---------–
  // Uri? initialUri;
  // try {
  //   initialUri = await AppLinks().getInitialLink();
  //   Preference.saveDataList(
  //     DeeplinkData(
  //       uri: initialUri,
  //       from: "AppLinks getInitialLink on app open before RUN().",
  //     ),
  //   );
  // } catch (e) {
  //   print('Error Receiving referral $e');
  // }

  splashLoaded = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp(initialUri: null));
  });
}
