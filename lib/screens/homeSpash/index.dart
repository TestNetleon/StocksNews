import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/index.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet_tablet.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet.dart';
import 'package:stocks_news_new/screens/help/chatScreen/chat_screen.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../utils/preference.dart';
import '../../widgets/custom/alert_popup.dart';
import '../auth/refer/refer_code.dart';
import '../blogDetail/index.dart';
import '../deepLinkScreen/webscreen.dart';
import '../drawer/widgets/review_app_pop_up.dart';
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
            builder: (_) => ChatScreen(
              slug: "1",
              ticketId: slug,
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
          popUpAlert(
              message: "Welcome to the Home Screen!",
              title: "Alert",
              icon: Images.alertPopGIF);
          return;
        }
        isPhone ? signupSheet() : signupSheetTablet();
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
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const ReferAFriend()),
        );
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
      appBar: AppBarHome(canSearch: true, showTrailing: true),
      body: SizedBox(),
    );
  }
}

// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
// import 'package:stocks_news_new/screens/tabs/tabs.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
// import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet.dart';
// import 'package:stocks_news_new/screens/blogDetail/index.dart';
// import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
// import 'package:provider/provider.dart';
// import '../drawer/widgets/review_app_pop_up.dart';
// // import 'package:stocks_news_new/screens/marketData/congressionalData/index.dart';
// // import 'package:stocks_news_new/screens/marketData/dividends/dividends.dart';
// // import 'package:stocks_news_new/screens/marketData/earnings/earnings.dart';
// // import 'package:stocks_news_new/screens/marketData/fiftyTwoWeeks/index.dart';
// // import 'package:stocks_news_new/screens/marketData/gainersLosers/index.dart';
// // import 'package:stocks_news_new/screens/marketData/gapUpDown/index.dart';
// // import 'package:stocks_news_new/screens/marketData/highLowPE/index.dart';
// // import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/index.dart';
// // import 'package:stocks_news_new/screens/marketData/indices/index.dart';
// // import 'package:stocks_news_new/screens/marketData/lowPriceStocks/index.dart';
// // import 'package:stocks_news_new/screens/marketData/mostActive/index.dart';
// // import 'package:stocks_news_new/screens/marketData/pennyStocks/index.dart';
// // import 'package:stocks_news_new/screens/stocks/index.dart';

// class HomeSplash extends StatefulWidget {
//   static const path = "HomeSplash";

//   const HomeSplash({super.key});

//   @override
//   State<HomeSplash> createState() => _HomeSplashState();
// }

// class _HomeSplashState extends State<HomeSplash> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _getAppLinks();
//     });
//   }

//   void _getAppLinks() {
//     if (deepLinkData != null) {
//       String type = containsSpecificPath(deepLinkData!);
//       String slug = extractLastPathComponent(deepLinkData!);

//       // Timer(const Duration(seconds: 5), () {
//       //   _navigation(uri: event, slug: slug, type: type);
//       // });

//       _navigationToDeepLink(uri: deepLinkData!, slug: slug, type: type);
//     } else {
//       _navigation();
//     }
//   }

//   _navigationToDeepLink({String? type, required Uri uri, String? slug}) async {
//     try {
//       Utils().showLog("---Type $type, -----Uri $uri,-----Slug $slug");
//       String slugForTicker = extractSymbolValue(uri);
//       Utils().showLog("slug for ticker $slugForTicker");
//       bool userPresent = false;

//       UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
//       if (await provider.checkForUser()) {
//         userPresent = true;
//       }
//       Utils().showLog("----$userPresent---");
//       if (type == "blog") {
//         Navigator.push(
//             navigatorKey.currentContext!,
//             MaterialPageRoute(
//                 builder: (context) => BlogDetail(
//                       // id: "",
//                       slug: slug,
//                     )));
//       } else if (type == "news") {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             builder: (context) => NewsDetails(
//               slug: slug,
//             ),
//           ),
//         );
//       }
//       //will go with NEW DRAWER from here
//       // else if (type == "gainer_loser") {
//       //   Navigator.push(
//       //     navigatorKey.currentContext!,
//       //     GainersLosersIndex.path,
//       //     arguments: {"type": StocksType.gainers},
//       //   );
//       // } else if (type == "indices") {
//       //   Navigator.push(navigatorKey.currentContext!, IndicesIndex.path);
//       // } else if (type == "gapup_gapdown") {
//       //   Navigator.push(navigatorKey.currentContext!, GapUpDownStocks.path);
//       // } else if (type == "insider") {
//       //   Navigator.pushAndRemoveUntil(
//       //       navigatorKey.currentContext!, Tabs.path, (route) => false,
//       //       arguments: 2);
//       // } else if (type == "sentiments") {
//       //   Navigator.pushAndRemoveUntil(
//       //       navigatorKey.currentContext!, Tabs.path, (route) => false,
//       //       arguments: 3);
//       // } else if (type == "high_lowPE") {
//       //   Navigator.push(navigatorKey.currentContext!, HighLowPEIndex.path);
//       // } else if (type == "52_weeks") {
//       //   Navigator.push(
//       //       navigatorKey.currentContext!, FiftyTwoWeeksIndex.path);
//       // } else if (type == "high_low_beta") {
//       //   Navigator.push(
//       //       navigatorKey.currentContext!, HighLowsBetaStocksIndex.path);
//       // } else if (type == "low_prices") {
//       //   Navigator.push(
//       //       navigatorKey.currentContext!, LowPriceStocksIndex.path);
//       // } else if (type == "most_active") {
//       //   Navigator.push(navigatorKey.currentContext!, MostActiveIndex.path);
//       // } else if (type == "penny") {
//       //   Navigator.push(navigatorKey.currentContext!, PennyStocks.path);
//       // } else if (type == "congress") {
//       //   Navigator.push(
//       //       navigatorKey.currentContext!, CongressionalIndex.path);
//       // } else if (type == "dividend") {
//       //   Navigator.push(navigatorKey.currentContext!, DividendsScreen.path);
//       // } else if (type == "earning") {
//       //   Navigator.push(navigatorKey.currentContext!, EarningsScreen.path);
//       // } else if (type == "stocks") {
//       //   Navigator.push(navigatorKey.currentContext!, StocksIndex.path);
//       // }

//       //will go with NEW DRAWER to here.

//       else if (type == "stock_detail") {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             builder: (context) => StockDetails(symbol: slugForTicker),
//           ),
//         );
//       } else if (type == "login") {
//         Navigator.pushAndRemoveUntil(
//           navigatorKey.currentContext!,
//           Tabs.path,
//           (route) => false,
//         );

//         if (userPresent) {
//           //
//         } else {
//           // loginSheet();
//           Timer(const Duration(seconds: 1), () {
//             loginSheet();
//           });
//         }
//         deepLinkData = null;
//       } else if (type == "signUp") {
//         Navigator.pushAndRemoveUntil(
//           navigatorKey.currentContext!,
//           Tabs.path,
//           (route) => false,
//         );

//         if (userPresent) {
//           //
//         } else {
//           Timer(const Duration(seconds: 1), () {
//             signupSheet();
//           });
//         }
//         deepLinkData = null;
//       } else if (type == "dashboard") {
//         Navigator.pushAndRemoveUntil(
//           navigatorKey.currentContext!,
//           Tabs.path,
//           (route) => false,
//         );

//         //
//         Utils().showLog("--goto dashboard---");
//         deepLinkData = null;
//       } else {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             builder: ((context) => WebviewLink(url: uri)),
//           ),
//         );
//       }
//     } catch (e) {
//       Navigator.pushAndRemoveUntil(
//         navigatorKey.currentContext!,
//         Tabs.path,
//         (route) => false,
//       );
//       deepLinkData = null;
//     }
//   }

//   _navigation() {
//     FirebaseMessaging.instance.getInitialMessage().then((value) {
//       if (value == null) {
//         Navigator.pushAndRemoveUntil(context, Tabs.path, (route) => false);
//       } else {
//         _navigateToRequiredScreen(value.data);
//       }
//     });
//   }

//   _navigateToRequiredScreen(payload) {
//     popHome = true;
//     String? type = payload["type"];
//     String? slug = payload['slug'];
//     String? notificationId = payload['notification_id'];
//     try {
//       // String? type = payload["type"];
//       // String? slug = payload['slug'];
//       // String? notificationId = payload['notification_id'];

//       if (type == NotificationType.dashboard.name) {
//         Navigator.pushAndRemoveUntil(
//           navigatorKey.currentContext!,
//           Tabs.path,
//           (route) => false,
//         );
//       } else if (slug != '' && type == NotificationType.newsDetail.name) {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           NewsDetails.path,
//           arguments: {"slug": slug, "notificationId": notificationId},
//         );
//       } else if (slug != '' && type == NotificationType.lpPage.name) {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//             builder: (context) => WebviewLink(
//               stringURL: slug,
//               notificationId: notificationId,
//             ),
//           ),
//         );
//       } else if (slug != '' && type == NotificationType.blogDetail.name) {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           BlogDetail.path,
//           arguments: {"slug": slug, "notificationId": notificationId},
//         );
//         // Navigator.push(
//         //   navigatorKey.currentContext!,
//         //   MaterialPageRoute(
//         //     builder: (context) => BlogDetail(
//         //       slug: slug ?? "",
//         //     ),
//         //   ),
//         // );
//       } else if (slug != '' && type == NotificationType.register.name) {
//         Navigator.pushAndRemoveUntil(
//           navigatorKey.currentContext!,
//           Tabs.path,
//           (route) => false,
//         );
//         Timer(const Duration(seconds: 1), () {
//           signupSheet();
//           popHome = false;
//         });
//       } else if (slug != '' && type == NotificationType.review.name) {
//         //review pop up
//         Navigator.pushAndRemoveUntil(
//           navigatorKey.currentContext!,
//           Tabs.path,
//           (route) => false,
//         );

//         Timer(const Duration(seconds: 1), () {
//           showDialog(
//             context: navigatorKey.currentContext!,
//             barrierColor: Colors.black.withOpacity(0.5),
//             builder: (context) {
//               return const ReviewAppPopUp();
//             },
//           );
//           popHome = false;
//         });
//       } else {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           StockDetails.path,
//           arguments: {"slug": type, "notificationId": notificationId},
//         );
//       }
//     } catch (e) {
//       Utils().showLog("Exception ===>> $e");
//       Navigator.pushAndRemoveUntil(
//         navigatorKey.currentContext!,
//         Tabs.path,
//         (route) => false,
//       );
//       popHome = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const BaseContainer(
//         appBar: AppBarHome(
//           canSearch: true,
//           showTrailing: true,
//         ),
//         body: SizedBox());
//   }
// }
