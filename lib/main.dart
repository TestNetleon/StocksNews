import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/fcm/service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stocks_news_new/firebase_options.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
// import 'package:firebase_auth/firebase_auth.dart';

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

  String? initialRoute;
  String? slug;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);

    // // Check if you received the link via getInitialLink first
    // final PendingDynamicLinkData? initialLink =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // if (initialLink != null) {
    //   final Uri deepLink = initialLink.link;
    //   initialRoute = containsSpecificPath(deepLink);
    //   slug = extractLastPathComponent(deepLink);
    //   log(
    //     "Initial link Received ** => ${"\n\n"}${deepLink.path}${"\n\n"}$deepLink${"\n\n"}${deepLink.path.contains("/install")}${"\n\n"}${deepLink.hasQuery}${"\n\n"}${deepLink.origin}${"\n\n"}${"\n\n"}",
    //   );
    //   if (deepLink.path.contains("page.link") ||
    //       deepLink.path.contains("/install") ||
    //       deepLink.path.contains("?code=") ||
    //       deepLink.path.contains("?referrer=") ||
    //       deepLink.path.contains("?ref=") ||
    //       deepLink.path.contains("?referral_code=")) {
    //     String? referralCode = deepLink.queryParameters['code'];
    //     if (referralCode == null || referralCode == '') {
    //       referralCode = deepLink.queryParameters['referrer'];
    //     }
    //     if (referralCode == null || referralCode == '') {
    //       referralCode = deepLink.queryParameters['ref'];
    //     }
    //     if (referralCode == null || referralCode == '') {
    //       referralCode = deepLink.queryParameters['referral_code'];
    //     }
    //     if (referralCode != null && referralCode != "") {
    //       log("CODE HERE @@@++++=========>  $referralCode");
    //       Preference.saveReferral(referralCode);
    //       FirebaseAnalytics.instance.logEvent(
    //         name: 'referrals',
    //         parameters: {'referral_code': referralCode},
    //       );
    //     }
    //   }
    //   // navigateDeepLinks(uri: deepLink);
    // }
    // FirebaseDynamicLinks.instance.onLink.listen((pendingDynamicLinkData) {
    //   // Set up the onLink event listener next as it may be received here
    //   if (pendingDynamicLinkData != null) {
    //     final Uri deepLink = pendingDynamicLinkData.link;
    //     // Example of using the dynamic link to push the user to a different screen
    //     // Navigator.pushNamed(context, deepLink.path);
    //     log(
    //       "Link Received onListen ** => ${"\n\n"}${deepLink.path}${"\n\nn"}$deepLink${"\n\n"}",
    //     );
    //     navigateDeepLinks(uri: deepLink);
    //   }
    // }, onDone: () {
    //   Utils().showLog(
    //     "onDone ** => ${"\n\n\n\n\n\n\n"}",
    //   );
    // }, onError: (error) {
    //   Utils().showLog(
    //     "onError ** => ${"\n\n\n\n\n\n\n"}$error${"\n\n\n\n\n\n\n"}",
    //   );
    // });
  } catch (e) {
    Utils().showLog('Error initializing Firebase: $e');
  }

  FirebaseApi().initNotifications();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(initialPath: initialRoute, slug: slug));
  });
}
