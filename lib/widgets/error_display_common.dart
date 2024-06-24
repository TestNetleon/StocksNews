import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';

//
class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    this.error,
    this.onRefresh,
    this.onNavigate,
    this.postJobButton,
    this.smallHeight = false,
    this.showHeight = true,
    this.fontSize = 18,
    this.navBtnText,
    super.key,
  });
  final String? error;
  final String? navBtnText;
  final Function()? onRefresh;
  final Function()? onNavigate;
  final bool? postJobButton;
  final bool smallHeight;
  final bool showHeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: ScreenUtil().screenWidth,
        height: showHeight
            ? smallHeight
                ? ScreenUtil().screenHeight * .4
                : ScreenUtil().screenHeight
            : null,
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
                    error ?? Const.errSomethingWrong,
                    style: stylePTSansRegular(fontSize: fontSize),
                    textAlign: TextAlign.center,
                  ),
                  const SpacerVertical(),
                  Visibility(
                    visible: onRefresh != null,
                    child: GestureDetector(
                      onTap: () {
                        if (onRefresh != null) onRefresh!();
                      },
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: ThemeColors.primary,
                        child: Icon(
                          Icons.replay_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: onNavigate != null,
                    child: ThemeButtonSmall(
                      onPressed: () {
                        if (onNavigate != null) onNavigate!();
                      },
                      text: navBtnText ?? "",
                      showArrow: false,
                      // fullWidth: false,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );

    // return Center(
    //   child: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 10),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           // Visibility(
    //           //   visible: showDivider,
    //           //   child: const Divider(
    //           //     color: ThemeColors.greyBorder,
    //           //     height: 30,
    //           //   ),
    //           // ),
    //           const Visibility(
    //             visible: true,
    //             child: SpacerVertical(
    //               height: 30,
    //             ),
    //           ),
    //           Text(
    //             error ?? Const.errSomethingWrong,
    //             textAlign: TextAlign.center,
    //             style: stylePTSansRegular(color: ThemeColors.white),
    //           ),
    //           const SpacerVertical(height: 40),
    //           Image.asset(
    //             Images.noDataGIF,
    //             height: 165,
    //             width: double.infinity,
    //             fit: BoxFit.contain,
    //           ),
    //           const SpacerVertical(height: 40),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               // Visibility(
    //               //   visible: showHome,
    //               //   child: ThemeButtonSmall(
    //               //     icon: Icons.home,
    //               //     onPressed: () {
    //               //       Navigator.pushAndRemoveUntil(
    //               //           context, Tabs.path, (route) => false);
    //               //     },
    //               //     text: "Go to Home",
    //               //   ),
    //               // ),
    //               Visibility(
    //                 visible: onRefresh != null,
    //                 child: ThemeButtonSmall(
    //                   icon: Icons.refresh,
    //                   onPressed: onRefresh ?? () => null,
    //                   text: "Refresh",
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
