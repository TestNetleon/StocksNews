import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';

class ColoredText extends StatelessWidget {
  final String text;
  final List<String> coloredLetters;
  final TextStyle? style;
  final Color? color;

  const ColoredText({
    required this.text,
    required this.coloredLetters,
    this.style,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      text: TextSpan(
        style: style ?? stylePTSansRegular(),
        children: [
          for (int i = 0; i < text.length; i++)
            TextSpan(
              text: text[i],
              style: style != null
                  ? style!.copyWith(
                      color: coloredLetters.contains(text[i])
                          ? color ?? Colors.green
                          : Colors.white,
                    )
                  : stylePTSansRegular(
                      color: coloredLetters.contains(text[i])
                          ? color ?? Colors.green
                          : Colors.white,
                    ),
            ),
        ],
      ),
    );
  }
}
