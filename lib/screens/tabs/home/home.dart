import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/home_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class Home extends StatefulWidget {
  static const String path = "Home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Home Screen"},
    );

    UserProvider provider = context.watch<UserProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isHome: true,
        widget: provider.user == null
            ? null
            : Align(
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
      isHome: true,
      drawer: BaseDrawer(),
      body: HomeContainer(),
    );
  }
}
