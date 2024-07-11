import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ProgressDialog extends StatelessWidget {
  final bool optionalParent;
  const ProgressDialog({super.key, this.optionalParent = false});
//
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (isPoped) {},
      child: Center(
        child: optionalParent
            ? Container(
                constraints: BoxConstraints(
                  maxWidth: ScreenUtil().screenWidth * .7,
                ),
                padding: EdgeInsets.all(18.sp),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(8.r),
                // ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Images.progressGIF,
                      width: 100,
                      height: 100,
                    ),
                    // // TODO: ------
                    // const CircularProgressIndicator(
                    //   color: ThemeColors.themeGreen,
                    //   strokeWidth: 4,
                    // ),
                    // // TODO: ------
                    const SpacerVertical(height: 16),
                    Flexible(
                      child: Text(
                        "Please wait...",
                        style: styleGeorgiaBold(
                          fontSize: 13,
                          color: ThemeColors.background,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Image.asset(
                Images.progressGIF,
                width: 100,
                height: 100,
              ),
      ),
    );
  }
}
