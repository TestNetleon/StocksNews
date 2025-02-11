import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import '../../api/api_response.dart';
import '../../database/preference.dart';
import '../../providers/home_provider.dart';
import '../../service/revenue_cat.dart';
import '../../ui/tabs/tabs.dart';
import '../auth/base/base_auth.dart';
import '../auth/refer/refer_code.dart';
import '../offerMembership/blackFriday/index.dart';
import '../blogDetail/index.dart';
import '../deepLinkScreen/webscreen.dart';
import '../drawer/widgets/review_app_pop_up.dart';
import '../helpDesk/chats/index.dart';
import '../offerMembership/christmas/index.dart';
import '../stockDetail/index.dart';

class HomeSplash extends StatefulWidget {
  static const path = "HomeSplash";

  const HomeSplash({super.key});

  @override
  State<HomeSplash> createState() => _HomeSplashState();
}

class _HomeSplashState extends State<HomeSplash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _navigation();
    });
  }

  _navigation() async {
    // FirebaseMessaging.instance.getInitialMessage().then((value) {
    //   // if (onDeepLinking) return;
    //   if (value == null) {
    //     Preference.saveDataList(
    //       DeeplinkData(
    //         uri: null,
    //         from: "New Home Screen to Tab navigate on Notification 1",
    //         type: value?.data.toString(),
    //       ),
    //     );
    //     Navigator.pushAndRemoveUntil(context, Tabs.path, (route) => false);
    //   } else {
    //     Preference.saveDataList(
    //       DeeplinkData(
    //         uri: null,
    //         from: "New Home Screen to Tab navigate on Notification 2",
    //       ),
    //     );
    //     popHome = true;
    //     _navigateToRequiredScreen(value.data);
    //   }
    // });

    RemoteMessage? value = await FirebaseMessaging.instance.getInitialMessage();

    if (value == null) {
      // Preference.saveDataList(
      //   DeeplinkData(
      //     from: "** getInitialLink "
      //         "\n"
      //         " FirebaseMessaging.instance.getInitialMessage",
      //   ),
      // );
      if (onDeepLinking) {
        popHome = true;
        return;
      }

      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);

      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Tabs()),
      );
    } else {
      // Preference.saveDataList(
      //   DeeplinkData(
      //     from: "** getInitialLink "
      //         "\n"
      //         " FirebaseMessaging.instance.getInitialMessage  else",
      //   ),
      // );
      if (onDeepLinking) {
        popHome = true;
        return;
      }

      popHome = true;
      _navigateToRequiredScreen(value.data);
    }
  }

  _navigateToRequiredScreen(payload) async {
    Utils().showLog("----Navigating to req screen...");
    popHome = true;
    String? type = payload["type"];
    String? slug = payload['slug'];
    String? notificationId = payload['notification_id'];

    try {
      // String? type = payload["type"];
      // String? slug = payload['slug'];
      // String? notificationId = payload['notification_id'];

      if (type == NotificationType.dashboard.name) {
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);

        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
      } else if (slug != '' && type == NotificationType.ticketDetail.name) {
        Navigator.pushReplacement(
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
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => NewsDetails(
              slug: slug,
              notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.lpPage.name) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => WebviewLink(
              stringURL: slug,
              notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.blogDetail.name) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => BlogDetail(
              slug: slug,
              notificationId: notificationId,
            ),
          ),
        );

        // Navigator.push(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (context) => BlogDetail(
        //       slug: slug ?? "",
        //     ),
        //   ),
        // );
      } else if (slug != '' && type == NotificationType.register.name) {
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);

        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
        if (await Preference.isLoggedIn()) {
          // popUpAlert(
          //     message: "Welcome to the Home Screen!",
          //     title: "Alert",
          //     icon: Images.alertPopGIF);
          return;
        }
        // isPhone ? signupSheet() : signupSheetTablet();
        await loginFirstSheet();
      } else if (slug != '' && type == NotificationType.review.name) {
        //review pop up
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);

        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
        Timer(const Duration(seconds: 1), () {
          showDialog(
            context: navigatorKey.currentContext!,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (context) {
              return const ReviewAppPopUp();
            },
          );
        });
      } else if (slug != '' && type == NotificationType.stockDetail.name ||
          isValidTickerSymbol(type ?? "")) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => StockDetail(
              symbol: slug!,
              notificationId: notificationId,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.nudgeFriend.name) {
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
        Timer(const Duration(milliseconds: 300), () {
          referLogin();
        });
      } else if (type == NotificationType.referRegistration.name) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const ReferAFriend()),
        );
      } else if (type == NotificationType.membership.name) {
        // popUpAlert(message: "IN HERE IN HOME SPLASH");
        // Navigator.pushReplacement(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (_) => NewMembership(
        //       notificationId: notificationId,
        //     ),
        //   ),
        // );
        closeKeyboard();

        Extra? extra = navigatorKey.currentContext!.read<HomeProvider>().extra;

        if (extra?.showBlackFriday == true) {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => BlackFridayMembershipIndex(
                notificationId: notificationId,
              ),
            ),
          );
        } else if (extra?.christmasMembership == true ||
            extra?.newYearMembership == true) {
          Navigator.push(
            navigatorKey.currentContext!,
            createRoute(
              ChristmasMembershipIndex(
                notificationId: notificationId,
              ),
            ),
          );
        } else {
          subscribe();
          // Navigator.push(
          //   navigatorKey.currentContext!,
          //   MaterialPageRoute(
          //     builder: (context) => NewMembership(
          //       notificationId: notificationId,
          //     ),
          //   ),
          // );
        }
      } else {
        // arguments: {"notificationId": notificationId},
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
      }
      //  else {
      //   Navigator.push(
      //     navigatorKey.currentContext!,
      //     StockDetails.path,
      //     arguments: {"slug": type, "notificationId": notificationId},
      //   );
      // }
    } catch (e) {
      Utils().showLog("Exception ===>> $e");
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);

      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Tabs()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      appBar: AppBarHome(canSearch: true),
      body: SizedBox(),
    );
  }
}
