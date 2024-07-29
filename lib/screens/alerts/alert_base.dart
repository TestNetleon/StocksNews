// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/alert_provider.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
// import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/screens/tabs/tabs.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/login_error.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import '../../widgets/screen_title.dart';
// import 'alert_container.dart';

// class AlertBase extends StatefulWidget {
//   const AlertBase({super.key});

//   @override
//   State<AlertBase> createState() => _AlertBaseState();
// }

// class _AlertBaseState extends State<AlertBase> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _getData();
//       FirebaseAnalytics.instance.logEvent(
//         name: 'ScreensVisit',
//         parameters: {'screen_name': "Stock Alerts"},
//       );
//     });
//   }

//   Future _getData() async {
//     UserProvider provider = context.read<UserProvider>();
//     if (provider.user != null) {
//       context.read<AlertProvider>().getAlerts(showProgress: false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     AlertProvider provider = context.watch<AlertProvider>();
//     UserProvider userProvider = context.watch<UserProvider>();
//     HomeProvider homeProvider = context.watch<HomeProvider>();

//     return BaseContainer(
//       appBar: const AppBarHome(isPopback: true, canSearch: true),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(
//           Dimen.padding.sp,
//           Dimen.padding.sp,
//           Dimen.padding.sp,
//           0,
//         ),
//         child: Column(
//           children: [
//             ScreenTitle(
//               title: provider.textRes?.title ??
//                   (homeProvider.totalAlerts == 1
//                       ? "Stock Alert"
//                       : "Stock Alerts"),
//             ),
//             userProvider.user == null
//                 ? Expanded(
//                     child: LoginError(
//                       error: "User Not logged in",
//                       onClick: () async {
//                         isPhone ? await loginSheet() : await loginSheetTablet();
//                         await _getData();
//                       },
//                     ),
//                   )
//                 : Expanded(
//                     child: Column(
//                       children: [
//                         Visibility(
//                           visible: provider.textRes?.subTitle != '' &&
//                               userProvider.user != null,
//                           child: Text(
//                             provider.textRes?.subTitle ?? "",
//                             style: stylePTSansRegular(fontSize: 12),
//                           ),
//                         ),
//                         Visibility(
//                           visible: provider.textRes?.note != null,
//                           child: Container(
//                             margin: EdgeInsets.symmetric(vertical: 10.sp),
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 5.sp, horizontal: 5.sp),
//                             decoration: const BoxDecoration(
//                               color: ThemeColors.greyBorder,
//                               border: Border(
//                                 left: BorderSide(
//                                   color: ThemeColors.white,
//                                   width: 3,
//                                 ),
//                               ),
//                             ),
//                             child: Text(
//                               provider.textRes?.note ?? "",
//                               style: stylePTSansRegular(fontSize: 12),
//                             ),
//                           ),
//                         ),
//                         Visibility(
//                           visible: provider.textRes?.other != '' &&
//                               userProvider.user != null,
//                           child: Text(
//                             provider.textRes?.other ?? "",
//                             style: stylePTSansRegular(fontSize: 12),
//                           ),
//                         ),
//                         const SpacerVertical(height: 5),
//                         Expanded(
//                           child: BaseUiContainer(
//                             isLoading:
//                                 provider.isLoading && provider.data == null,
//                             hasData: provider.data != null &&
//                                 provider.data!.isNotEmpty,
//                             error: provider.error,
//                             errorDispCommon: true,
//                             showPreparingText: true,
//                             // onRefresh: () => provider.getAlerts(showProgress: false),
//                             navBtnText: "Add First Stock Alert",
//                             onNavigate: () {
//                               Navigator.popUntil(
//                                   context, (route) => route.isFirst);
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const Tabs(index: 1),
//                                 ),
//                               );
//                             },
//                             child: const AlertContainer(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// //

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/alert_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/login_error.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'alert_container.dart';

class AlertBase extends StatefulWidget {
  const AlertBase({super.key});

  @override
  State<AlertBase> createState() => _AlertBaseState();
}

class _AlertBaseState extends State<AlertBase> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Stock Alerts"},
      );
    });
  }

  Future _getData() async {
    UserProvider provider = context.read<UserProvider>();
    if (provider.user != null) {
      context.read<AlertProvider>().getAlerts(showProgress: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AlertProvider provider = context.watch<AlertProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        title: userProvider.user == null
            ? null
            : provider.textRes?.title ??
                (homeProvider.totalAlerts == 1
                    ? "Stock Alert"
                    : "Stock Alerts"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          0,
          Dimen.padding.sp,
          0,
        ),
        child: Column(
          children: [
            // userProvider.user == null
            //     ? const SizedBox()
            //     : ScreenTitle(
            //         title: provider.textRes?.title ??
            //             (homeProvider.totalAlerts == 1
            //                 ? "Stock Alert"
            //                 : "Stock Alerts"),
            //       ),
            userProvider.user == null
                ? Expanded(
                    child: LoginError(
                      error: "User Not logged in",
                      title: "Stock Alerts",
                      onClick: () async {
                        isPhone ? await loginSheet() : await loginSheetTablet();
                        await _getData();
                      },
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Visibility(
                          visible: provider.textRes?.subTitle != '' &&
                              userProvider.user != null,
                          child: Text(
                            provider.textRes?.subTitle ?? "",
                            style: stylePTSansRegular(fontSize: 12),
                          ),
                        ),
                        Visibility(
                          visible: provider.textRes?.note != null,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.sp),
                            padding: EdgeInsets.symmetric(
                                vertical: 5.sp, horizontal: 5.sp),
                            decoration: const BoxDecoration(
                              color: ThemeColors.greyBorder,
                              border: Border(
                                left: BorderSide(
                                  color: ThemeColors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              provider.textRes?.note ?? "",
                              style: stylePTSansRegular(fontSize: 12),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: provider.textRes?.other != '' &&
                              userProvider.user != null,
                          child: Text(
                            provider.textRes?.other ?? "",
                            style: stylePTSansRegular(fontSize: 12),
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Expanded(
                          child: BaseUiContainer(
                            isLoading:
                                provider.isLoading && provider.data == null,
                            hasData: provider.data != null &&
                                provider.data!.isNotEmpty,
                            error: provider.error,
                            errorDispCommon: true,
                            showPreparingText: true,
                            // onRefresh: () => provider.getAlerts(showProgress: false),
                            navBtnText: "Add First Stock Alert",
                            onNavigate: () {
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Tabs(index: 1),
                                ),
                              );
                            },
                            child: const AlertContainer(),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
//
