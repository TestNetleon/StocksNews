import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';

class ThemeAlertDialog extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? contentPadding;
  final EdgeInsets? insetPadding;
  const ThemeAlertDialog({
    super.key,
    this.children = const <Widget>[],
    this.contentPadding,
    this.insetPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: insetPadding ??
          EdgeInsets.symmetric(horizontal: 35.sp, vertical: 20.sp),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
          side: BorderSide(
              color: ThemeColors.greyText.withOpacity(0.5), width: 2)),
      elevation: 5,
      backgroundColor: ThemeColors.primaryLight,
      contentPadding:
          contentPadding ?? EdgeInsets.fromLTRB(18.sp, 16.sp, 18.sp, 10.sp),
      content: SizedBox(
        width: ScreenUtil().screenWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}
