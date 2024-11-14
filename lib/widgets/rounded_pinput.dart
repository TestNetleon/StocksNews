import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class InputOTP extends StatelessWidget {
  final TextEditingController pinController;
  final FocusNode focusNode;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  const InputOTP({
    super.key,
    required this.pinController,
    required this.focusNode,
    this.onCompleted,
    this.onSubmitted,
    this.onChanged,
  });
//
  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 4,
      separatorBuilder: (index) {
        return const SpacerHorizontal(width: 18);
      },
      controller: pinController,
      focusNode: focusNode,
      onCompleted: onCompleted,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      defaultPinTheme: PinTheme(
        // width: 60,
        width: ScreenUtil().screenWidth / 4,
        height: 50,
        textStyle: stylePTSansBold(fontSize: 28),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ThemeColors.greyText),
          ),
        ),
      ),
      focusedPinTheme: PinTheme(
        // width: 60,
        width: ScreenUtil().screenWidth / 4,
        height: 50,
        textStyle: stylePTSansBold(fontSize: 28),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ThemeColors.greyText),
          ),
        ),
      ),
      submittedPinTheme: PinTheme(
        // width: 60,
        width: ScreenUtil().screenWidth / 4,
        height: 50,
        textStyle: stylePTSansBold(fontSize: 28),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ThemeColors.greyText),
          ),
        ),
      ),
    );
  }
}
