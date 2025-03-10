import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/myAccount/my_account_container.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/delete_account.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/login_error.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../auth/base/base_auth.dart';

import '../../utils/constants.dart';

class MyAccount extends StatelessWidget {
  static const String path = "MyAccount";
  const MyAccount({super.key});
//
  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();

    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': 'My Account'},
    );
    return BaseContainer(
      appBar: const AppBarHome(isPopBack: true, title: "My Account"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimen.padding),
        child: provider.user == null
            ? Column(
                children: [
                  // const ScreenTitle(title: "My Profile"),
                  Expanded(
                      child: LoginError(
                    title: "My Account",
                    onClick: () async {
                      // isPhone ? await loginSheet() : await loginSheetTablet();
                      await loginFirstSheet();
                    },
                  ))
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // ScreenTitle(title: "My Profile"),
                    const MyAccountContainer(),
                    Visibility(
                      visible: provider.user != null,
                      child: const MyAccountDelete(),
                    ),
                    const SpacerVertical(),
                  ],
                ),
              ),
      ),
    );
  }
}
