import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:stocks_news_new/fcm/one_signal_service.dart';
import 'package:stocks_news_new/fcm/service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stocks_news_new/firebase_options.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

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

  // Remove this method to stop OneSignal Debugging
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
    );

    FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
    Timer(const Duration(seconds: 8), () {
      Preference.setIsFirstOpen(false);
    });
  } catch (e) {
    Utils().showLog('Error initializing Firebase: $e');
  }

  FirebaseApi().initNotifications();
  // Uri membershipURL =
  //     await DynamicLinkService.instance.getMembershipDynamicLink();
  // Utils().showLog("Membership URL $membershipURL");
  splashLoaded = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}
