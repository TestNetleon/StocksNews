import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/in_app_msg_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/index.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet_tablet.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/screens/help/chatScreen/chat_screen.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import '../screens/drawer/widgets/review_app_pop_up.dart';
import '../screens/stockDetail/index.dart';
import '../screens/tabs/news/newsDetail/new_detail.dart';
import '../utils/utils.dart';
import '../widgets/custom/alert_popup.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  // provider.user?.notificationSeen = false;
  HomeProvider? provider = navigatorKey.currentContext?.read<HomeProvider>();
  // provider.notificationSeen = false;
  if (provider != null) {
    provider.setNotification(false);
    Utils().showLog("Data Payload: ${message.data}");
    Utils().showLog("Notification Payload: ${message.notification}");
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    "StocksNews_New",
    "StocksNews_New",
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notifications'),
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message, {whenAppKilled = false}) {
    if (message == null) return;
    Timer(Duration(seconds: Platform.isIOS ? 0 : 0), () {
      _navigateToRequiredScreen(
        message.data,
        whenAppKilled: whenAppKilled,
      );
    });
  }

  Future _navigateToRequiredScreen(payload, {whenAppKilled = false}) async {
    String? type = payload["type"];
    String? slug = payload['slug'];
    String? notificationId = payload['notification_id'];
    isAppUpdating = false;
    try {
      if (type == NotificationType.dashboard.name) {
        if (whenAppKilled) return null;
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
      } else if (slug != '' && type == NotificationType.ticketDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              slug: "1",
              ticketId: slug,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.newsDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => NewsDetails(
              slug: slug,
              notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.lpPage.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => WebviewLink(
              stringURL: slug,
              notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.blogDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => BlogDetail(
              slug: slug ?? "",
              notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.register.name) {
        if (await Preference.isLoggedIn()) {
          popUpAlert(
            message: "Welcome to the Home Screen!",
            title: "Alert",
            icon: Images.alertPopGIF,
          );
          return;
        }
        isPhone ? signupSheet() : signupSheetTablet();
      } else if (slug != '' && type == NotificationType.review.name) {
        //review pop up
        showDialog(
          context: navigatorKey.currentContext!,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) {
            return const ReviewAppPopUp();
          },
        );
      } else if (slug != '' && type == NotificationType.stockDetail.name ||
          isValidTickerSymbol(type ?? "")) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => StockDetail(
              symbol: "$slug",
              notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.nudgeFriend.name) {
        referLogin();
      } else if (type == NotificationType.referRegistration.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const ReferAFriend()),
        );
      } else if (type == NotificationType.appUpdate.name) {
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => Tabs(
              inAppMsgId: notificationId,
            ),
          ),
        );
        Timer(const Duration(milliseconds: 300), () {
          if (Platform.isAndroid) {
            openUrl(
                "https://play.google.com/store/apps/details?id=com.stocks.news");
          } else {
            openUrl("https://apps.apple.com/us/app/stocks-news/id6476615803");
          }
        });
      } else {
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => Tabs(
              inAppMsgId: notificationId,
            ),
          ),
        );
      }
    } catch (e) {
      Utils().showLog("Exception ===>> $e");

      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Tabs()),
      );
      // arguments: {"notificationId": notificationId},
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';
      final http.Response response = await http.get(Uri.parse(url));
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } catch (e) {
      Utils().showLog("$e");
      return "";
    }
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings("mipmap/ic_launcher_round");
    DarwinInitializationSettings iOS = const DarwinInitializationSettings(
      defaultPresentSound: true,
      requestSoundPermission: true,
    );
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          Utils().showLog("onDidReceiveNotificationResponse");
          final message =
              RemoteMessage.fromMap(jsonDecode(details.payload ?? ""));
          handleMessage(message);
        }
      },
    );

    final playform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await playform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   Utils().showLog("getInitialMessage");
    //   Future.delayed(const Duration(seconds: 4), () {
    //     handleMessage(message, whenAppKilled: true);
    //   });
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Utils().showLog("OnMessageOpenedApp ==> ${message.data}");
      Future.delayed(Duration(seconds: Platform.isIOS ? 0 : 0), () {
        handleMessage(message);
      });
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        Utils().showLog("on Message  0 ==>  ${message.toMap()}");
        Utils().showLog("on Message  1 ==>  ${message.toString()}");
        // Utils().showLog("on Message  ==> Notification ${message.notification}");
        // Utils().showLog("on Message  ==> Data ${message.data}");
      } catch (e) {
        if (kDebugMode) print(e.toString());
      }
      // bool inAppMsg = message.data["in_app_msg"] ?? false;
      HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();
      if (message.data["in_app_msg"] == true ||
          message.data["in_app_msg"] == 'true') {
        if (isAppInForeground) {
          provider.updateInAppMsgStatus(message.data["_id"]);
          checkForInAppMessage(
            InAppNotification(
              id: message.data["_id"],
              title: message.data["title"],
              description: message.data["description"],
              image: message.data["image"],
              popupType: message.data["popup_type"],
              redirectOn: message.data["redirect_on"],
              slug: message.data["slug"],
            ),
          );
        }
        return;
      }
      provider.setNotification(false);

      final data = message.data;
      String? image = data["image"];
      Utils().showLog("THIS is an image $image");

      if (data.isEmpty) return;
      BigPictureStyleInformation? information;

      if (image != null) {
        final String bigPicturePath =
            await _downloadAndSaveFile(image, 'bigPicture');
        information = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          contentTitle: data["title"],
          summaryText: data["message"],
        );
      }

      // Utils().showLog("THIS IS BIGIMAGE NOTIFICATION ${information != null}");

      if (Platform.isAndroid) {
        _localNotifications.show(
          data.hashCode,
          data["title"],
          data["message"],
          // null, null,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              playSound: true,
              sound: const RawResourceAndroidNotificationSound('notifications'),
              enableVibration: true,
              importance: Importance.max,
              icon: "mipmap/ic_launcher_round", //CHANGE ICON
              styleInformation: image != null
                  ? information
                  : BigTextStyleInformation(
                      contentTitle: data["title"],
                      data["message"].toString(),
                    ),
            ),
            iOS: const DarwinNotificationDetails(
              sound: "notifications.wav",
              presentSound: true,
            ),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    if (Platform.isIOS) {
      await _firebaseMessaging.getAPNSToken().then((value) async {
        Utils().showLog("APNS TOKEN  ******   $value");
      });
    }

    await _firebaseMessaging.getToken().then((value) async {
      Utils().showLog("FCM TOKEN  ******   $value");
      String? address = await _getUserLocation();
      fcmTokenGlobal = value;
      if (!isShowingError) {
        saveFCMapi(value: value, address: address);
      }
    });

    // Stream<String> token = await _firebaseMessaging.onTokenRefresh;

    initPushNotification();
    initLocalNotifications();
  }
}

Future<String?> _getUserLocation() async {
  try {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Reverse geocoding

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    String address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    Utils().showLog("Address:  $address");
    return address;
  } catch (e) {
    Utils().showLog('Error: $e');
    return null;
  }
}

Future saveFCMapi({String? value, String? address}) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String versionName = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  bool granted = await Permission.notification.isGranted;

  try {
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "fcm_token": value ?? "",
      "platform": Platform.operatingSystem,
      "address": address ?? "",
      "build_version": versionName,
      "build_code": buildNumber,
      "fcm_permission": "$granted",
    };

    ApiResponse response = await apiRequest(
      url: Apis.saveFCM,
      request: request,
      showProgress: false,
      showErrorOnFull: false,
      checkAppUpdate: false,
      removeForceLogin: true,
    );

    if (response.status) {
      navigatorKey.currentContext!.read<HomeProvider>().setSheetText(
            loginText: response.extra?.loginText,
            signupText: response.extra?.signUpText,
          );
      Preference.saveFcmToken(value);
      Preference.saveLocation(address);
    } else {
      //
    }
  } catch (e) {
    Utils().showLog("Catch error $e");
  }
}
