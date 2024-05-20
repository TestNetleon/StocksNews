import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';

import '../screens/tabs/news/newsDetail/new_detail.dart';
import '../utils/utils.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  // provider.user?.notificationSeen = false;
  HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();
  // provider.notificationSeen = false;
  provider.setNotification(false);
  Utils().showLog("Notification Title: ${message.notification?.title}");
  Utils().showLog("Notification body Body: ${message.notification?.body}");
  Utils().showLog("Data Payload: ${message.data}");
  Utils().showLog("Image ${message.data["image"]}");
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
    Timer(const Duration(seconds: 1), () {
      _navigateToRequiredScreen(
        message.data,
        whenAppKilled: whenAppKilled,
      );
    });
  }

  void _navigateToRequiredScreen(payload, {whenAppKilled = false}) async {
    // log("--------- => notification => $payload");

    // bool isLoggedIn = await Preference.isLoggedIn();

    // if (isLoggedIn) {
    //   log("is logged in");

    //   try {
    //     String type = payload["type"];

    //     // Navigator.popUntil(
    //     //   navigatorKey.currentContext!,
    //     //   (route) => route.isFirst,
    //     // );

    //     if (type == NotificationType.dashboard.name) {
    //       if (whenAppKilled) return null;
    //       Navigator.pushNamedAndRemoveUntil(
    //           navigatorKey.currentContext!, Tabs.path, (route) => false);
    //     } else {
    //       Navigator.pushNamed(navigatorKey.currentContext!, StockDetails.path,
    //           arguments: {"slug": type},);
    //     }
    //   } catch (e) {
    //     log("Exception ===>> $e");
    //   }
    // } else {
    //   log("is not logged in");
    //   try {
    //     Navigator.popUntil(
    //       navigatorKey.currentContext!,
    //       (route) => route.isFirst,
    //     );
    //     Navigator.push(
    //       navigatorKey.currentContext!,
    //       MaterialPageRoute(
    //         builder: (_) {
    //           return const Login();
    //         },
    //       ),
    //     );
    //   } catch (e) {
    //     //
    //   }
    // }
    try {
      String? type = payload["type"];
      String? slug = payload['slug'];
      // Navigator.popUntil(
      //   navigatorKey.currentContext!,
      //   (route) => route.isFirst,
      // );

      if (type == NotificationType.dashboard.name) {
        if (whenAppKilled) return null;
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!, Tabs.path, (route) => false);
      } else if (slug != '' && type == NotificationType.newsDetail.name) {
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          NewsDetails.path,
          arguments: {"slug": slug},
        );
      } else if (slug != '' && type == NotificationType.lpPage.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => WebviewLink(
              stringURL: slug,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.blogDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => BlogDetail(
              id: slug ?? "",
            ),
          ),
        );
      } else {
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          StockDetails.path,
          arguments: {"slug": type},
        );
      }
    } catch (e) {
      Utils().showLog("Exception ===>> $e");
      Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!, Tabs.path, (route) => false);
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
    DarwinInitializationSettings iOS = const DarwinInitializationSettings();
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

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      Utils().showLog("getInitialMessage");

      Future.delayed(const Duration(seconds: 4), () {
        handleMessage(message, whenAppKilled: true);
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Utils().showLog("OnMessageOpenedApp ==> ${message.data}");

      Future.delayed(
        const Duration(seconds: 1),
        () {
          handleMessage(message);
        },
      );
    });
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) async {
      HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();
      // provider.notificationSeen = false;
      provider.setNotification(false);

      Utils().showLog("on Message called ==>${message.data}");

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

      // log("THIS IS BIGIMAGE NOTIFICATION ${information != null}");

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
            iOS: const DarwinNotificationDetails(),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.getToken().then((value) async {
      Utils().showLog("FCM TOKEN  ******   $value");
      String? address = await _getUserLocation();
      saveFCMapi(value: value, address: address);
    });

    initPushNotification();
    initLocalNotifications();
  }
}

Future<String?> _getUserLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    return null;
  }

  // Get current position
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  // Reverse geocoding
  try {
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
  try {
    Map request = {
      "token": "",
      "fcm_token": value ?? "",
      "platform": Platform.operatingSystem,
      "address": address ?? "",
    };
    ApiResponse response = await apiRequest(
      url: Apis.saveFCM,
      request: request,
      showProgress: false,
    );

    if (response.status) {
      Preference.saveFcmToken(value);
      Preference.saveLocation(address);
    } else {
      //
    }
  } catch (e) {
    Utils().showLog("Catch error $e");
  }
}
