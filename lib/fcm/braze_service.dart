import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/ui/account/auth/login.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/subscription/screens/start/subscription.dart';
import 'package:stocks_news_new/ui/tabs/more/articles/detail.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/chats/index.dart';
import 'package:stocks_news_new/ui/tabs/more/news/detail.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_pending.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';

import '../ui/tabs/tabs.dart';
import '../utils/utils.dart';
import 'package:stocks_news_new/ui/landing/page.dart';

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

  Future getTemUser({String? value}) async {
    try {
      Map request = {
        'fcm_token': value,
      };

      ApiResponse response = await apiRequest(
        url: Apis.getTempUser,
        request: request,
        showProgress: false,
        showErrorOnFull: false,
        checkAppUpdate: false,
        removeForceLogin: true,
      );

      if (response.status) {
        UserRes? tempUser;
        tempUser = userResFromJson(jsonEncode(response.data));
        BrazeService.brazeUserEvent(randomID: tempUser.userId);
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
        /// done
        // if (!whenAppKilled) return null;
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        // Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path);

        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.ticketDetail.name) {
        /// done
/*
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
        );*/

        // Navigator.pushNamed(
        //     navigatorKey.currentContext!, HelpDeskAllChatsIndex.path,
        //     arguments: {'ticketId': slug});

        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => HelpDeskAllChatsIndex(
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
            builder: (_) => NewsDetailIndex(
              slug: slug,
              // notificationId: notificationId,
            ),
          ),
        );

        // Navigator.pushNamed(navigatorKey.currentContext!, NewsDetailIndex.path,
        //     arguments: {
        //       'slug': slug,
        //     });
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.lpPage.name) {
        /// done
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => LandingPageIndex(
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
            builder: (context) => BlogsDetailIndex(
              slug: slug,
              // notificationId: notificationId,
            ),
          ),
        );
        // Navigator.pushNamed(navigatorKey.currentContext!, BlogsDetailIndex.path,
        //     arguments: {
        //       'slug': slug,
        //     });
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

        /// done
        // isPhone ? signupSheet() : signupSheetTablet();
        //loginFirstSheet();
        Navigator.push(
          navigatorKey.currentContext!,
          createRoute(AccountLoginIndex()),
        );
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.review.name) {
        popHome = false;
        if (whenAppKilled) await Future.delayed(const Duration(seconds: 3));
        //review pop up
      } else if (slug != '' &&
              slug != null &&
              type == NotificationType.stockDetail.name ||
          isValidTickerSymbol(type ?? "")) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => SDIndex(
              symbol: "$slug",
              // notificationId: notificationId,
            ),
          ),
        );
        // Navigator.pushNamed(navigatorKey.currentContext!, SDIndex.path,
        //     arguments: {
        //       'symbol': slug,
        //     });
      } else if (slug != '' &&
          slug != null &&
          type == NotificationType.nudgeFriend.name) {
        popHome = false;
        if (whenAppKilled) await Future.delayed(const Duration(seconds: 3));
        //  referLogin();
      } else if (type == NotificationType.referRegistration.name) {
        /// done
        // Navigator.pushNamed(navigatorKey.currentContext!, ReferralIndex.path);
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const ReferralIndex()),
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
        if (slug != null && slug != '') {
          popHome = false;
          if (whenAppKilled) await Future.delayed(const Duration(seconds: 3));

          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => const SubscriptionIndex(),
            ),
          );

          /// done
          // Navigator.pushNamed(
          //     navigatorKey.currentContext!, SubscriptionIndex.path);

          // subscribe();
        }
      } else if (type == NotificationType.pointTransaction.name) {
        ///
      } else if (type == NotificationType.appUpdate.name) {
        /// done
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);

        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => Tabs(),
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
          /// done
          // Navigator.pushNamed(
          //     navigatorKey.currentContext!, SimulatorIndex.path);

          // Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path,
          //     arguments: {'index': 2});

          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => Tabs(index: 2)),
          );
        } else {
          /// done
          popHome = true;
          navigatorKey.currentContext!.read<SPendingManager>().getData();
        }
      } else {
        /// done
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => Tabs(),
          ),
        );
      }
    } catch (e) {
      Utils().showLog("Exception ===>> $e");
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Tabs()),
      );
      // arguments: {"notificationId": notificationId},
    }
  }
}
