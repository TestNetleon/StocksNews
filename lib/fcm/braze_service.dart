import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/pointsTransaction/trasnsaction.dart';
import 'package:stocks_news_new/screens/offerMembership/christmas/index.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../providers/home_provider.dart';
import '../providers/user_provider.dart';
import '../screens/auth/base/base_auth.dart';
import '../screens/offerMembership/blackFriday/index.dart';
import '../tradingSimulator/providers/ts_pending_list_provider.dart';
import '../tradingSimulator/screens/dashboard/index.dart';
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

class BrazeNotificationService {
  BrazeNotificationService._internal();

  static final BrazeNotificationService _instance =
      BrazeNotificationService._internal();

  static BrazeNotificationService get instance => _instance;

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

      Extra? extra = response.extra is Extra ? response.extra : null;

      if (response.status) {
        navigatorKey.currentContext!.read<HomeProvider>().setSheetText(
              loginText: extra?.loginText,
              signupText: extra?.signUpText,
            );
        if (extra?.tempUser != null) {
          BrazeService.brazeUserEvent(randomID: extra?.tempUser?.userId);
        }
      } else {
        //
      }
    } catch (e) {
      Utils().showLog("Catch error $e");
    }
  }

  Future navigateToRequiredScreen({
    whenAppKilled = false,
    String? type,
    String? slug,
  }) async {
    isAppUpdating = false;
    Utils().showLog('Type is $type, Slug is $slug');
    // userInteractionEventCommon(
    //   slug: slug,
    //   type: type,
    // );
    await Future.delayed(Duration(milliseconds: 400));
    try {
      if (type == NotificationType.dashboard.name) {
        // if (!whenAppKilled) return null;
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.ticketDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            // builder: (_) => ChatScreen(
            //   slug: "1",
            //   ticketId: slug,
            // ),
            builder: (_) => HelpDeskAllChatsNew(
              ticketId: slug,
            ),
          ),
        );
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.newsDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => NewsDetails(
              slug: slug,
              // notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.lpPage.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => WebviewLink(
              stringURL: slug,
              // notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.blogDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => BlogDetail(
              slug: slug,
              // notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.register.name) {
        popHome = false;
        if (whenAppKilled) await Future.delayed(const Duration(seconds: 3));
        if (await Preference.isLoggedIn()) {
          // popUpAlert(
          //   message: "Welcome to the Home Screen!",
          //   title: "Alert",
          //   icon: Images.alertPopGIF,
          // );
          return;
        }

        // isPhone ? signupSheet() : signupSheetTablet();
        loginFirstSheet();
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.review.name) {
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
      } else if (slug != '' &&
              slug != null &&
              type == NotificationType.stockDetail.name ||
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
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.nudgeFriend.name) {
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
        if (slug != null &&
            slug != '' &&
            (slug == 'christmas' || slug == 'new-year')) {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => const ChristmasMembershipIndex(),
            ),
          );
        } else if (slug != null && slug != '' && slug == 'black-friday') {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => const BlackFridayMembershipIndex(),
            ),
          );
        } else {
          // Navigator.push(
          //   navigatorKey.currentContext!,
          //   MaterialPageRoute(
          //     builder: (context) => const NewMembership(),
          //   ),
          // );
          subscribe();
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
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.simulator.name) {
        if (whenAppKilled || !isOnTsScreen) {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => TsDashboard()),
          );
        } else {
          popHome = true;
          navigatorKey.currentContext!.read<TsPendingListProvider>().getData();
        }
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
