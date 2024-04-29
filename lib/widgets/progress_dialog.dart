import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      strokeWidth: 4,
                    ),
                    const SpacerHorizontal(width: 16),
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
            : Container(
                width: 60.sp,
                height: 60.sp,
                padding: EdgeInsets.all(18.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.sp),
                ),
                child: const CircularProgressIndicator(strokeWidth: 3),
              ),
      ),
    );
  }
}
