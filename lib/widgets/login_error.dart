// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet_tablet.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button_small.dart';

// import '../screens/auth/bottomSheets/login_sheet.dart';

// //
// class LoginError extends StatelessWidget {
//   const LoginError({
//     this.error,
//     this.onRefresh,
//     this.postJobButton,
//     this.state,
//     this.smallHeight = false,
//     super.key,
//   });

//   final String? error;
//   final String? state;
//   final Function()? onRefresh;
//   final bool? postJobButton;
//   final bool smallHeight;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: ScreenUtil().screenWidth,
//       height: smallHeight
//           ? ScreenUtil().screenHeight * .4
//           : ScreenUtil().screenHeight,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.sp),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Please log in to continue",
//                   style: stylePTSansRegular(fontSize: 18),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SpacerVertical(),
//                 ThemeButtonSmall(
//                   onPressed: () async {
//                     // Navigator.push(context, Login.path);

//                     // await Navigator.push(
//                     //   context,
//                     //   createRoute(Login(
//                     //     state: state,
//                     //   )),
//                     // );
//                     isPhone
//                         ? await loginSheet(state: state)
//                         : await loginSheetTablet(state: state);
//                   },
//                   text: "Log in",
//                   showArrow: false,
//                   // fullWidth: false,
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import '../screens/auth/signup/signup_sheet.dart';
import '../screens/auth/signup/signup_sheet_tablet.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

//
class LoginError extends StatelessWidget {
  const LoginError({
    this.error,
    this.onRefresh,
    this.postJobButton,
    this.state,
    this.smallHeight = false,
    super.key,
    required this.onClick,
    this.title,
  });
  final Function() onClick;
  final String? error;
  final String? state;
  final Function()? onRefresh;
  final bool? postJobButton;
  final bool smallHeight;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: smallHeight
          ? ScreenUtil().screenHeight * .4
          : ScreenUtil().screenHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  // visible: title != null && title != '',
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      title ?? "",
                      style: stylePTSansBold(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Visibility(
                  // visible: title != null && title != '',
                  child: Text(
                    "This page is for registered users. Please log in or sign up to access.",
                    style: stylePTSansRegular(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SpacerVertical(height: 10),
                ThemeButtonSmall(
                  onPressed: onClick,
                  text: "Already have an account? Log in",
                  iconFront: true,
                  icon: Icons.login,
                  radius: 30,
                  mainAxisSize: MainAxisSize.max,
                  textSize: 15,
                  fontBold: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          isPhone
                              ? await signupSheet()
                              : await signupSheetTablet();
                        },
                        child: Text(
                          "Don't have an account? Sign up ",
                          style: stylePTSansRegular(
                            fontSize: 18,
                            color: ThemeColors.accent,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
