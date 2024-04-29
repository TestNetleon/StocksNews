import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/auth/login/login.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

//
class LoginError extends StatelessWidget {
  const LoginError({
    this.error,
    this.onRefresh,
    this.postJobButton,
    this.state,
    this.smallHeight = false,
    super.key,
  });
  final String? error;
  final String? state;
  final Function()? onRefresh;
  final bool? postJobButton;
  final bool smallHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: smallHeight
          ? ScreenUtil().screenHeight * .4
          : ScreenUtil().screenHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please log in to continue",
                  style: stylePTSansRegular(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SpacerVerticel(),
                ThemeButtonSmall(
                  onPressed: () async {
                    // Navigator.pushNamed(context, Login.path);

                    await Navigator.push(
                      context,
                      createRoute(Login(
                        state: state,
                      )),
                    );
                  },
                  text: "Log in",
                  showArrow: false,
                  // fullWidth: false,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
