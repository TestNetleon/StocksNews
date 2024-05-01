import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/myAccount/my_account_container.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/delete_account.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/login_error.dart';

import '../../utils/constants.dart';
import '../../widgets/screen_title.dart';

class MyAccount extends StatelessWidget {
  static const String path = "MyAccount";
  const MyAccount({super.key});
//
  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, showTrailing: false),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(Dimen.padding.sp),
            child: provider.user == null
                ? const Column(
                    children: [
                      ScreenTitle(title: "My Account"),
                      Expanded(child: LoginError())
                    ],
                  )
                : const SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // SpacerVertical(height: 30),
                        ScreenTitle(title: "My Account"),

                        MyAccountContainer(),
                      ],
                    ),
                  ),
          ),
          Visibility(
            visible: provider.user != null,
            child: const Positioned(bottom: 10, child: MyAccountDelete()),
          ),
        ],
      ),
    );
  }
}
