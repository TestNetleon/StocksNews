import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class ScannerPreparing extends StatelessWidget {
  const ScannerPreparing({
    super.key,
    this.message = "Please wait while we are preparing...",
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().screenHeight * 2 / 3,
      width: ScreenUtil().screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.progressGIF, width: 100, height: 100),
          Text(message, style: stylePTSansBold()),
        ],
      ),
    );
  }
}
