import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/home_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/utils.dart';
import '../../affiliate/pointsTransaction/trasnsaction.dart';

class Home extends StatefulWidget {
  static const String path = "Home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  double _snackbarBottomPosition = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addObserver(this);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _snackbarBottomPosition = -100;
        });
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _snackbarBottomPosition = 0;
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Utils().showLog('App resumed');
        _check();
        break;
      case AppLifecycleState.paused:
        Utils().showLog('App paused');
        break;
      case AppLifecycleState.inactive:
        Utils().showLog('App inactive');
        break;
      case AppLifecycleState.detached:
        Utils().showLog('App detached');
        break;
      default:
        break;
    }
  }

  Future _check() async {
    notifySnackbar = await openNotificationsSettings();
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Home Screen"},
    );

    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isHome: true,
        widget: provider.user == null
            ? null
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AffiliateTransaction(
                        fromDrawer: true,
                      ),
                    ),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          ThemeColors.tabBack,
                          ThemeColors.blackShade,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          Images.pointIcon2,
                          width: 14,
                        ),
                        const SpacerHorizontal(width: 8),
                        Text(
                          provider.user?.pointEarn != null
                              ? "${provider.user?.pointEarn}"
                              : "0",
                          style: stylePTSansRegular(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
      isHome: true,
      drawer: BaseDrawer(),
      body: Stack(
        children: [
          CommonRefreshIndicator(
            onRefresh: () async {
              await homeProvider.refreshData(null);
            },
            child: DefaultTextStyle(
              style: styleGeorgiaBold(),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: HomeContainer(),
              ),
            ),
          ),
          if (notifySnackbar && homeProvider.extra?.notifyTextMsg != null)
            CustomSnackbar(
              message: "${homeProvider.extra?.notifyTextMsg}",
              bottomPosition: _snackbarBottomPosition,
              displayDuration: Duration(minutes: 1),
              onTap: () async {
                await openAppSettings();
              },
            ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
// import 'package:stocks_news_new/screens/tabs/home/home_container.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// import '../../../utils/dialogs.dart';
// import '../../../utils/utils.dart';
// import '../../affiliate/pointsTransaction/trasnsaction.dart';
// import '../../auth/base/base_auth.dart';

// class Home extends StatefulWidget {
//   static const String path = "Home";
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> with WidgetsBindingObserver {
//   final ScrollController _scrollController = ScrollController();
//   double _snackbarBottomPosition = 0;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       WidgetsBinding.instance.addObserver(this);
//     });

//     _scrollController.addListener(() {
//       if (_scrollController.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         // Scrolling up
//         setState(() {
//           _snackbarBottomPosition = -100; // Hide snackbar
//         });
//       } else if (_scrollController.position.userScrollDirection ==
//           ScrollDirection.forward) {
//         // Scrolling down
//         setState(() {
//           _snackbarBottomPosition = 0; // Show snackbar
//         });
//       }
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         Utils().showLog('App resumed');
//         _check();
//         break;
//       case AppLifecycleState.paused:
//         Utils().showLog('App paused');
//         break;
//       case AppLifecycleState.inactive:
//         Utils().showLog('App inactive');
//         break;
//       case AppLifecycleState.detached:
//         Utils().showLog('App detached');
//         break;
//       default:
//         break;
//     }
//   }

//   Future _check() async {
//     notifySnackbar = await openNotificationsSettings();
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     FirebaseAnalytics.instance.logEvent(
//       name: 'ScreensVisit',
//       parameters: {'screen_name': "Home Screen"},
//     );

//     UserProvider provider = context.watch<UserProvider>();
//     HomeProvider homeProvider = context.watch<HomeProvider>();

//     return BaseContainer(
//       appBar: AppBarHome(
//         isHome: true,
//         widget: provider.user == null
//             ? null
//             : GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AffiliateTransaction(
//                         fromDrawer: true,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: const [
//                           ThemeColors.tabBack,
//                           ThemeColors.blackShade,
//                         ],
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Image.asset(
//                           Images.pointIcon2,
//                           width: 14,
//                         ),
//                         const SpacerHorizontal(width: 8),
//                         Text(
//                           provider.user?.pointEarn != null
//                               ? "${provider.user?.pointEarn}"
//                               : "0",
//                           style: stylePTSansRegular(
//                             fontSize: 14,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//       isHome: true,
//       drawer: BaseDrawer(),
//       body: Stack(
//         children: [
//           CommonRefreshIndicator(
//             onRefresh: () async {
//               await homeProvider.refreshData(null);
//             },
//             child: DefaultTextStyle(
//               style: styleGeorgiaBold(),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       controller: _scrollController,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       child: HomeContainer(),
//                     ),
//                   ),
//                   BaseAuth(),
//                 ],
//               ),
//             ),
//           ),
//           if (notifySnackbar && homeProvider.extra?.notifyTextMsg != null)
//             CustomSnackbar(
//               message: "${homeProvider.extra?.notifyTextMsg}",
//               bottomPosition: _snackbarBottomPosition,
//               displayDuration: Duration(minutes: 1),
//               onTap: () async {
//                 await openAppSettings();
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }
