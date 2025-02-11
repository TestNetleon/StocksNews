import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class BaseHeading extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsets? margin;

  const BaseHeading({
    super.key,
    this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: Pad.pad10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null && title != '',
            child: Text(
              title ?? '',
              style: titleStyle ?? styleBaseBold(fontSize: 28),
            ),
          ),
          Visibility(
            visible: subtitle != null && subtitle != '',
            child: Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                subtitle ?? '',
                style: subtitleStyle ?? styleBaseRegular(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
