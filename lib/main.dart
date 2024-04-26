import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/fcm/service.dart';
// import 'package:stocks_news_new/fcm/service.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } catch (e) {
    log(e.toString());
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ThemeColors.background, // Set your primary dark color
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        // // If apply android won't work and if doesn't iOS wont
        // name: "StocksNews",
        options: FirebaseOptions(
          apiKey: ApiKeys.apiKey,
          appId: Platform.isAndroid
              ? ApiKeys.appId
              : "1:661986825229:ios:2958225927da6ea85bb144",
          messagingSenderId: ApiKeys.messagingSenderId,
          projectId: ApiKeys.projectId,
        ),
      );
    } else {
      await Firebase.initializeApp(
        // // If apply android won't work and if doesn't iOS wont
        name: "StocksNews",
        options: FirebaseOptions(
          apiKey: ApiKeys.apiKey,
          appId: Platform.isAndroid
              ? ApiKeys.appId
              : "1:661986825229:ios:2958225927da6ea85bb144",
          messagingSenderId: ApiKeys.messagingSenderId,
          projectId: ApiKeys.projectId,
        ),
      );
    }
  } catch (e) {
    Utils().showLog('Error initializing Firebase: $e');
  }

  FirebaseApi().initNotifications();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}
