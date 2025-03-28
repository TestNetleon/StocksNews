import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../utils/colors.dart';

class BaseHeading extends StatelessWidget {
  final String? title, viewMoreText;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsets? margin;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;
  final Function()? viewMore;
  const BaseHeading({
    super.key,
    this.title,
    this.viewMoreText,
    this.viewMore,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.margin,
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: Pad.pad10),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          OptionalParent(
            addParent: viewMore != null,
            parentBuilder: (child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: child),
                  SpacerHorizontal(width: 10),
                  InkWell(
                    onTap: viewMore,
                    child: Row(
                      children: [
                        Text(
                          viewMoreText ?? 'View More',
                          textAlign: textAlign,
                          style: styleBaseRegular(
                            fontSize: 16,
                            color: ThemeColors.primary120,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: ThemeColors.primary120,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            child: Visibility(
              visible: title != null && title != '',
              child: Text(
                title ?? '',
                textAlign: textAlign,
                style: titleStyle ?? styleBaseBold(fontSize: 28),
                // style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Visibility(
            visible: subtitle != null && subtitle != '',
            child: Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                subtitle ?? '',
                style: subtitleStyle ??
                    styleBaseRegular(fontSize: 14, height: 1.3),
                // style: subtitleStyle ?? Theme.of(context).textTheme.labelSmall,
                textAlign: textAlign,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
