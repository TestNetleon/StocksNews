import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/text_input_field.dart';

class MarketDataTextFiledClickable extends StatelessWidget {
  const MarketDataTextFiledClickable(
      {required this.label,
      required this.hintText,
      required this.controller,
      required this.onTap,
      super.key});
  final String label;
  final String hintText;

  final void Function() onTap;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(label, style: stylePTSansRegular()),
          // const SpacerVertical(height: 5),
          TextInputField(
            hintText: hintText,
            suffix: const Icon(
              Icons.arrow_drop_down,
              size: 23,
              color: ThemeColors.background,
            ),
            style: stylePTSansRegular(
              fontSize: 12,
              color: ThemeColors.background,
            ),
            editable: false,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            controller: controller,
          ),
        ],
      ),
    );
  }
}
