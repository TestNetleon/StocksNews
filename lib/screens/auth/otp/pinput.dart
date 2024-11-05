import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';

class CommonPinput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final int length;
  final double separatorWidth;
  final void Function(String)? onCompleted;
  const CommonPinput({
    super.key,
    required this.controller,
    this.onCompleted,
    this.focusNode,
    this.length = 4,
    this.separatorWidth = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Pinput(
        focusNode: focusNode,
        length: length,
        controller: controller,
        closeKeyboardWhenCompleted: true,
        cursor: Text(
          "|",
          style: stylePTSansRegular(color: ThemeColors.white, fontSize: 30),
        ),
        showCursor: true,
        separatorBuilder: (index) {
          return SpacerHorizontal(width: separatorWidth);
        },
        mouseCursor: SystemMouseCursors.basic,
        defaultPinTheme: PinTheme(
          width: 56.sp,
          height: 70.sp,
          textStyle: stylePTSansBold(color: ThemeColors.white, fontSize: 30),
          decoration: BoxDecoration(
            color: ThemeColors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
        ),
        focusedPinTheme: PinTheme(
          width: 56.sp,
          height: 70.sp,
          textStyle: stylePTSansBold(color: ThemeColors.white, fontSize: 30),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ThemeColors.accent),
          ),
        ),
        submittedPinTheme: PinTheme(
          width: 56.sp,
          height: 70.sp,
          textStyle: stylePTSansBold(color: ThemeColors.white, fontSize: 30),
          decoration: BoxDecoration(
            // color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ThemeColors.accent),
          ),
        ),
        onCompleted: onCompleted,
      ),
    );
  }
}
