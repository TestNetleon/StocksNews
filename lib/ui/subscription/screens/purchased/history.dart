import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class PurchasedHistory extends StatelessWidget {
  const PurchasedHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) {
          return Container(
            margin: EdgeInsets.only(bottom: Pad.pad24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '10/16/2024',
                        style: styleBaseRegular(fontSize: 16),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '\$9.99',
                        style: styleBaseBold(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Basic Plan  10/16/2024 - 11/15/2024',
                    style: styleBaseRegular(color: ThemeColors.neutral20),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
