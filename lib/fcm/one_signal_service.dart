import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/pointsTransaction/trasnsaction.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import '../utils/utils.dart';

import 'package:stocks_news_new/screens/affiliate/index.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet_tablet.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/screens/membership_new/membership.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import '../screens/drawer/widgets/review_app_pop_up.dart';
import '../screens/helpDesk/chats/index.dart';
import '../screens/stockDetail/index.dart';
import '../screens/tabs/news/newsDetail/new_detail.dart';
import '../widgets/custom/alert_popup.dart';

class OneSignalService {
  Future _navigateToRequiredScreen(OSNotification payload,
      // Future _navigateToRequiredScreen(payload,
      {whenAppKilled = false}) async {
    // Log the cleaned payload

    var data = payload.rawPayload!['custom'] is String
        ? jsonDecode(payload.rawPayload!['custom'])["a"]
        : payload.rawPayload!['custom']['a'];
    String? type = data["type"];
    String? slug = data['slug'];
    String? notificationId = data['notification_id'];
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
            // builder: (_) => ChatScreen(
            //   slug: "1",
            //   ticketId: slug,
            // ),
            builder: (_) => HelpDeskAllChatsNew(
              ticketId: slug ?? "N/A",
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
        popHome = false;
        if (whenAppKilled) await Future.delayed(const Duration(seconds: 3));
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
        popHome = false;
        if (whenAppKilled) await Future.delayed(const Duration(seconds: 3));
        referLogin();
      } else if (type == NotificationType.referRegistration.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const ReferAFriend()),
        );
      } else if (type == NotificationType.membership.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => NewMembership(
              notificationId: notificationId,
              // withClickCondition: true,
            ),
          ),
        );
      } else if (type == NotificationType.pointTransaction.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => AffiliateTransaction(
              fromDrawer: true,
              // notificationId: notificationId,
              // withClickCondition: true,
            ),
          ),
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
            builder: (_) => Tabs(inAppMsgId: notificationId),
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

  Future<void> initNotifications() async {
    fcmTokenGlobal = OneSignal.User.pushSubscription.id;

    OneSignal.User.pushSubscription.addObserver((state) async {
      print(OneSignal.User.pushSubscription.id);
      String? address = await _getUserLocation();
      fcmTokenGlobal = OneSignal.User.pushSubscription.id;
      if (!isShowingError) {
        saveFCMapi(value: fcmTokenGlobal, address: address);
      }
    });

    if (fcmTokenGlobal != null) {
      String? address = await _getUserLocation();
      if (!isShowingError) {
        saveFCMapi(value: fcmTokenGlobal, address: address);
      }
    }

    OneSignal.Notifications.addClickListener((OSNotificationClickEvent event) {
      if (oneSignalInitialized && navigatorKey.currentContext != null) {
        _navigateToRequiredScreen(event.notification);
      } else {
        popHome = true;
        Timer(const Duration(seconds: 2), () {
          _navigateToRequiredScreen(event.notification, whenAppKilled: true);
        });
      }
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      log('NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
      event.notification.display();
    });
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
    geoCountryCode = place.isoCountryCode;
    String address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    Utils().showLog("Address:  $address  $geoCountryCode");
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
