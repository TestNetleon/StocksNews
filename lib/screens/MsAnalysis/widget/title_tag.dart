import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stocks_news_new/utils/colors.dart';
import '../../../utils/theme.dart';

class MsTitle extends StatelessWidget {
  final String title;
  final EdgeInsets? margin;
  const MsTitle({super.key, required this.title, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            title,
            colors: const [
              Color.fromARGB(255, 156, 131, 9),
              Color.fromARGB(255, 153, 153, 5),
              Color.fromARGB(255, 236, 232, 133),
              Color.fromARGB(255, 228, 216, 89),
              // Color.fromARGB(255, 156, 131, 9),
              // Color.fromARGB(255, 156, 131, 9),
              // Color.fromARGB(255, 156, 131, 9),
            ],
            style: styleSansBold(fontSize: 30).copyWith(
              shadows: [
                Shadow(
                  offset: Offset(1.0, 3.0),
                  blurRadius: 3.0,
                  color: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),
          Text(
            "This is a short description",
            style: stylePTSansRegular(color: ThemeColors.greyText),
          ),
        ],
      ),
    );
  }
}
