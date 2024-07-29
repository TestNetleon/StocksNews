import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/auth/authFlow/complete_login.dart';
import 'package:stocks_news_new/screens/auth/authFlow/login_first.dart';
import 'package:stocks_news_new/screens/auth/authFlow/otp_sheet_login.dart';

import 'package:stocks_news_new/widgets/base_container.dart';

class CompleteAuth extends StatefulWidget {
  const CompleteAuth({super.key});

  @override
  State<CompleteAuth> createState() => _CompleteAuthState();
}

class _CompleteAuthState extends State<CompleteAuth> {
  int step = 1;
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: step == 1
                ? ScreenUtil().screenHeight -
                    ScreenUtil().bottomBarHeight -
                    ScreenUtil().statusBarHeight
                : 0,
            curve: Curves.fastOutSlowIn,
            child: LoginFirst(
              onLogin: () {
                setState(() {
                  step = 2;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: step == 2
                ? ScreenUtil().screenHeight -
                    ScreenUtil().bottomBarHeight -
                    ScreenUtil().statusBarHeight
                : 0,
            curve: Curves.fastOutSlowIn,
            child: OTPLoginBottom(
              mobile: "mobile",
              onSubmit: () {
                setState(() {
                  step = 3;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: step == 3
                ? ScreenUtil().screenHeight -
                    ScreenUtil().bottomBarHeight -
                    ScreenUtil().statusBarHeight
                : 0,
            curve: Curves.fastOutSlowIn,
            child: CompleteLogin(scrollController: ScrollController()),
          ),
        ],
      ),
    );
  }
}
