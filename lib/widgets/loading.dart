import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class Loading extends StatelessWidget {
  final String? text;
  const Loading({this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Images.progressGIF,
            width: 100,
            height: 100,
          ),
          Text(
            textAlign: TextAlign.center,
            text ?? Const.loadingMessage,
            style: styleGeorgiaRegular(color: ThemeColors.primary100),
          ),
        ],
      ),
    );
  }
}
