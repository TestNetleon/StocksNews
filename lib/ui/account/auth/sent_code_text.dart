import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class AccountSentCodeText extends StatelessWidget {
  final String text;
  final int digit;
  const AccountSentCodeText({
    super.key,
    required this.text,
    this.digit = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Please enter the $digit-digit code sent to',
            style: styleBaseRegular(fontSize: 18),
          ),
          SpacerVertical(height: 8),
          Text(
            text,
            style: styleBaseBold(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
