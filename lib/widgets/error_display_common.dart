import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';

//
class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    this.error,
    this.onRefresh,
    this.postJobButton,
    this.smallHeight = false,
    this.showHeight = true,
    this.fontSize = 18,
    super.key,
  });
  final String? error;
  final Function()? onRefresh;
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
