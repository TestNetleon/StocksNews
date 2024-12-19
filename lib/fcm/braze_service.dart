import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:braze_plugin/braze_plugin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/pointsTransaction/trasnsaction.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../providers/home_provider.dart';
import '../providers/user_provider.dart';
import '../screens/auth/base/base_auth.dart';
import '../screens/offerMembership/blackFriday/index.dart';
import '../service/braze/service.dart';
import '../utils/utils.dart';
import 'package:stocks_news_new/screens/affiliate/index.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
import 'package:stocks_news_new/screens/blogDetail/index.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/screens/membership_new/membership.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import '../screens/drawer/widgets/review_app_pop_up.dart';
import '../screens/helpDesk/chats/index.dart';
import '../screens/stockDetail/index.dart';
import '../screens/tabs/news/newsDetail/new_detail.dart';
import '../widgets/custom/alert_popup.dart';

class BrazeNotificationService {
  // BrazePlugin braze = BrazePlugin();
  // static StreamSubscription? pushEventsStreamSubscription;
  // static StreamSubscription? inAppMessageStreamSubscription;

  // brazeNotificationInitialize() {
  //   listenForPushToken();
  //   listenForNotification();
  //   listenForInAppMessage();
  // }

  // listenForInAppMessage() {
  //   try {
  //     inAppMessageStreamSubscription = braze.subscribeToInAppMessages(
  //       (BrazeInAppMessage pushEvent) {
  //         Utils().showLog('in app message event $pushEvent');

  //         braze.logInAppMessageClicked(pushEvent);
  //         braze.logInAppMessageClicked(pushEvent);
  //       },
  //     );
  //   } catch (e) {
  //     Utils().showLog('in app message error: $e');
  //   }
  // }

  // Future<void> listenForPushToken() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   await messaging.requestPermission();

  //   String? deviceToken = await messaging.getAPNSToken();
  //   String? fcmToken;

  //   await messaging.getToken().then((value) async {
  //     if (value != null) {
  //       fcmToken = value;
  //       if (Platform.isAndroid) {
  //         BrazeService().registerFCM(fcmToken);
  //       } else {
  //         // BrazeService().registerFCM(deviceToken);
  //       }
  //       Utils().showLog("FCM Token: $fcmToken");
  //       Utils().showLog("DEVICE Token: $deviceToken");
  //     }
  //   });

  //   String? address = await BrazeNotificationService().getUserLocation();
  //   BrazeNotificationService().saveFCMApi(value: fcmToken, address: address);
  // }

  // void listenForNotification() {
  //   try {
  //     pushEventsStreamSubscription =
  //         braze.subscribeToPushNotificationEvents((BrazePushEvent pushEvent) {
  //       if (pushEvent.payloadType == 'push_opened') {
  //         popHome = true;
  //         Utils().showLog('data received: $pushEvent');

  //         NotificationDataPref notification = NotificationDataPref(
  //           type: pushEvent.payloadType,
  //           android: json.encode(pushEvent.android),
  //           ios: json.encode(pushEvent.ios),
  //           pushEventJsonString: pushEvent.pushEventJsonString,
  //           brazeProperties: json.encode(pushEvent.brazeProperties),
  //         );
  //         NotificationPreferences.saveNotification(notification);
  //         try {
  //           // Parse the push notification JSON
  //           final Map<String, dynamic> notificationData =
  //               jsonDecode(pushEvent.pushEventJsonString);

  //           String? type;
  //           String? slug;

  //           if (Platform.isIOS) {
  //             type = notificationData['ios']['raw_payload']['type'];
  //             slug = notificationData['ios']['raw_payload']['slug'];
  //           } else {
  //             type = pushEvent.brazeProperties['type'];
  //             slug = pushEvent.brazeProperties['slug'];
  //           }

  //           if (type != null && slug != null) {
  //             BrazeNotificationService().navigateToRequiredScreen({
  //               'type': type,
  //               'slug': slug,
  //             });
  //           } else {
  //             Utils().showLog(
  //                 'Required fields "type" or "slug" not found in notification payload.');
  //           }
  //         } catch (e) {
  //           Utils().showLog('Error parsing notification JSON: $e');
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     Utils().showLog('Notification error: $e');
  //   }
  // }

  Future<String?> getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Utils().showLog('location permission $permission');
      if (permission == LocationPermission.denied) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
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

  Future saveFCMApi({String? value, String? address}) async {
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

  Future navigateToRequiredScreen(userInfo,
      // Future _navigateToRequiredScreen(payload,
      {whenAppKilled = false}) async {
    // Log the cleaned payload

    String? type = userInfo["type"];
    String? slug = userInfo['slug'];
    // String? notificationId = userInfo['notification_id'];
    isAppUpdating = false;
    Utils().showLog('Type is $type, Slug is $slug');
    // userInteractionEventCommon(
    //   slug: slug,
    //   type: type,
    // );

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
              // notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.lpPage.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => WebviewLink(
              stringURL: slug,
              // notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.blogDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => BlogDetail(
              slug: slug ?? "",
              // notificationId: notificationId,
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
        // isPhone ? signupSheet() : signupSheetTablet();
        loginFirstSheet();
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
              // notificationId: notificationId,
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
        // Navigator.push(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (_) => NewMembership(
        //       notificationId: notificationId,
        //       // withClickCondition: true,
        //     ),
        //   ),
        // );

        // closeKeyboard();
        // Extra? extra = navigatorKey.currentContext!.read<HomeProvider>().extra;
        if (slug != null && slug != '' && slug == 'black-friday') {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => const BlackFridayMembershipIndex(),
            ),
          );
        } else {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => const NewMembership(),
            ),
          );
        }
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
                // inAppMsgId: notificationId,
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
                // inAppMsgId: notificationId,
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
}
