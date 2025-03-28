import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';

import '../../utils/colors.dart';
import '../../utils/theme.dart';

class BaseReadMore extends StatelessWidget {
  final String text;
  final int trimLines;
  final TextStyle? textStyle;
  final String readMoreText;
  final String readLessText;

  const BaseReadMore({
    super.key,
    required this.text,
    this.trimLines = 2,
    this.textStyle,
    this.readMoreText = " Read More",
    this.readLessText = " Read Less",
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, value, child) {
        return ReadMoreText(
          textAlign: TextAlign.start,
          text,
          trimLines: trimLines,
          colorClickableText: ThemeColors.primary120,
          trimMode: TrimMode.Line,
          trimCollapsedText: readMoreText,
          trimExpandedText: readLessText,
          moreStyle: styleBaseRegular(color: ThemeColors.primary120),
          style: styleBaseRegular(
            height: 1.4,
            color: //value.isDarkMode ? ThemeColors.white :
                ThemeColors.black,
          ),
        );
      },
    );
  }
}
