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
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/pointsTransaction/trasnsaction.dart';
import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import '../screens/auth/base/base_auth.dart';
import '../screens/blackFridayMembership/index.dart';
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

    userInteractionEventCommon(
      slug: slug,
      type: type,
    );

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
        // Navigator.push(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (_) => NewMembership(
        //       notificationId: notificationId,
        //       // withClickCondition: true,
        //     ),
        //   ),
        // );

        closeKeyboard();
        UserRes? userRes =
            navigatorKey.currentContext!.read<UserProvider>().user;
        if (userRes?.showBlackFriday == true) {
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
    Utils().showLog('FCM Token Before $fcmTokenGlobal');

    OneSignal.User.pushSubscription.addObserver((state) async {
      fcmTokenGlobal = OneSignal.User.pushSubscription.id;
      String? address = await _getUserLocation();
      Utils().showLog('FCM Token After $fcmTokenGlobal');

      if (!isShowingError) {
        saveFCMapi(value: fcmTokenGlobal, address: address);
      }
    });

    String? address = await _getUserLocation();
    if (fcmTokenGlobal != null) {
      if (!isShowingError) {
        saveFCMapi(value: fcmTokenGlobal, address: address);
      }
    }

    OneSignal.Notifications.addClickListener((OSNotificationClickEvent event) {
      if (oneSignalInitialized && navigatorKey.currentContext != null) {
        log('Going to navigate IF');
        popHome = true;
        _navigateToRequiredScreen(event.notification);
      } else {
        log('Going to navigate ELSE');

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
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      // desiredAccuracy: LocationAccuracy.high,
    );
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

void userInteractionEventCommon({String? type, String? slug}) async {
  Utils().showLog('User interaction started');
  try {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    if (provider.user == null) {
      bool userPresent = await provider.checkForUser();
      Utils().showLog('User present while interacting with event $userPresent');
    }

    String eventType;
    String selfText;
    if (type == NotificationType.dashboard.name) {
      eventType = "Notification Clicked: Home";
      selfText = "Navigated to the home page from notification.";
    } else if (type == NotificationType.ticketDetail.name) {
      eventType = "Notification Clicked: Support Ticket";
      selfText = "Viewed support ticket with ID: $slug";
    } else if (type == NotificationType.newsDetail.name) {
      eventType = "Notification Clicked: News Detail";
      selfText = "Opened news with ID: $slug";
    } else if (type == NotificationType.lpPage.name) {
      eventType = "Notification Clicked: Landing Page";
      selfText = "Viewed landing page with URL: $slug";
    } else if (type == NotificationType.blogDetail.name) {
      eventType = "Notification Clicked: Blog Detail";
      selfText = "Read blog article with ID: $slug";
    } else if (type == NotificationType.register.name) {
      eventType = "Notification Clicked: Register";
      selfText = "Initiated registration process.";
    } else if (type == NotificationType.review.name) {
      eventType = "Notification Clicked: App Review";
      selfText = "Prompted to review the app.";
    } else if (type == NotificationType.stockDetail.name) {
      eventType = "Notification Clicked: Stock Detail";
      selfText = "Viewed stock details for ticker: $slug";
    } else if (type == NotificationType.nudgeFriend.name) {
      eventType = "Notification Clicked: Friend Referral";
      selfText = "Prompted to refer a friend.";
    } else if (type == NotificationType.referRegistration.name) {
      eventType = "Notification Clicked: Referral Register";
      selfText = "Opened referral registration page.";
    } else if (type == NotificationType.membership.name) {
      eventType = "Notification Clicked: Membership";
      selfText = "Viewed membership information.";
    } else if (type == NotificationType.pointTransaction.name) {
      eventType = "Notification Clicked: Points Transaction";
      selfText = "Viewed points transaction details.";
    } else if (type == NotificationType.appUpdate.name) {
      eventType = "Notification Clicked: App Update";
      selfText = "Notification received to update the app.";
    } else {
      eventType = "Notification Clicked: Home";
      selfText = "Navigated to the home page from notification.";
    }

    AmplitudeService.logUserInteractionEvent(
      type: eventType,
      selfText: selfText,
    );
  } catch (e) {
    //
  }
}
