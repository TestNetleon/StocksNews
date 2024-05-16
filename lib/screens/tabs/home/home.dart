import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/tabs/home/home_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Home extends StatelessWidget {
  static const String path = "Home";
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Home Screen"},
    );

    return BaseContainer(
      drawer: const BaseDrawer(),
      // appBar: AppBarHome(showQR: userProvider.user != null, isHome: true),
      appBar: const AppBarHome(
        isHome: true,
        canSearch: true,
      ),
      body: provider.isLoadingSlider
          ? const Loading()
          :
          // provider.data != null
          //     ?
          const HomeContainer()
      // :
      // ErrorDisplayWidget(
      //     error: provider.error,
      //     onRefresh: provider.getHomeData,
      //   )
      ,
    );
  }
}

// class Home extends StatelessWidget {
//   static const String path = "Home";
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(20.0),
//         topRight: Radius.circular(20.0),
//       ),
//       child: CupertinoScaffold(
//         topRadius: CupertinoScrollbar.defaultRadiusWhileDragging,
//         body: CupertinoPageScaffold(
//           navigationBar: CupertinoNavigationBar(
//             backgroundColor: ThemeColors.greyText,
//             leading: IconButton(
//                 onPressed: () {
//                   loginIOS();
//                 },
//                 icon: const Icon(Icons.menu)),
//           ),
//           child: Container(),
//         ),
//       ),
//     );
//   }
// }

void loginIOS() {
  showCupertinoModalBottomSheet(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 100),
        color: ThemeColors.greyBorder,
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  loginIOS();
                },
                child: Text("AAAA")),
          ],
        ),
      );
    },
  );
}
