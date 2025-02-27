import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';

class CommonPinputPhone extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function(String)? onCompleted;
  final int length;
  const CommonPinputPhone({
    super.key,
    required this.controller,
    this.onCompleted,
    this.focusNode,
    this.length = 6,
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
          style: stylePTSansRegular(color: ThemeColors.black, fontSize: 30),
        ),
        showCursor: true,
        separatorBuilder: (index) {
          return const SpacerHorizontal(width: 5);
        },
        mouseCursor: SystemMouseCursors.basic,
        defaultPinTheme: PinTheme(
          width: 56.sp,
          height: 56.sp,
          textStyle: stylePTSansBold(color: ThemeColors.white, fontSize: 30),
          decoration: BoxDecoration(
            color: ThemeColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ThemeColors.neutral10),
          ),
        ),
        focusedPinTheme: PinTheme(
          width: 56.sp,
          height: 56.sp,
          textStyle: stylePTSansBold(color: ThemeColors.black, fontSize: 30),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ThemeColors.neutral80),
          ),
        ),
        submittedPinTheme: PinTheme(
          width: 56.sp,
          height: 56.sp,
          textStyle: stylePTSansBold(color: ThemeColors.black, fontSize: 30),
          decoration: BoxDecoration(
            // color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ThemeColors.neutral10),
          ),
        ),
        onCompleted: onCompleted,
      ),
    );
  }
}
