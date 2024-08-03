import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/linear_bar.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdAnalysisItem extends StatelessWidget {
  final num? value;
  final String heading;
  const SdAnalysisItem({super.key, this.value, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ThemeColors.greyBorder.withOpacity(0.3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  heading,
                  style: stylePTSansBold(),
                ),
              ),
              Text(
                "$value",
                style: stylePTSansBold(),
              ),
            ],
          ),
          const SpacerVertical(height: 10),
          LinearBarCommon(
            showText: false,
            showAnimation: true,
            value: value ?? 0,
          ),
        ],
      ),
    );
  }
}
