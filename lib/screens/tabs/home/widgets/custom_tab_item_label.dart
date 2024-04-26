import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class CustomTabLabel extends StatelessWidget {
  final String text;
  final List<String>? coloredLetters;
  final bool selected;
  final Function() onTap;

  const CustomTabLabel(
    this.text, {
    super.key,
    this.coloredLetters,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: selected ? Colors.white : ThemeColors.background,
          padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 5.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                maxLines: 1,
                text: TextSpan(
                  style: stylePTSansRegular(
                    color: selected ? Colors.black : Colors.white,
                    fontSize: 13,
                  ),
                  children: [
                    for (int i = 0; i < text.length; i++)
                      TextSpan(
                        text: text[i],
                        style: stylePTSansBold(
                          fontSize: 13,
                          // color: coloredLetters.contains(text[i])
                          //     ? Colors.green
                          //     : selected
                          //         ? Colors.black
                          //         : Colors.white,
                          color: selected ? Colors.black : Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTabLabelNews extends StatelessWidget {
  final String text;
  final bool selected;
  final Function() onTap;

  const CustomTabLabelNews(
    this.text, {
    super.key,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected ? Colors.white : ThemeColors.background,
        padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 8.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              maxLines: 1,
              text: TextSpan(
                style: stylePTSansRegular(
                  color: selected ? Colors.black : Colors.white,
                  fontSize: 13,
                ),
                children: [
                  for (int i = 0; i < text.length; i++)
                    TextSpan(
                      text: text[i],
                      style: stylePTSansBold(
                        fontSize: 13,
                        // color: coloredLetters.contains(text[i])
                        //     ? Colors.green
                        //     : selected
                        //         ? Colors.black
                        //         : Colors.white,
                        color: selected ? Colors.black : Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
