import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../../modals/stockDetailRes/financial.dart';

class SdFinancialItem extends StatelessWidget {
  final FinanceStatement? data;
  final int index;
  final int openIndex;
  final Function(int) onCardTapped;
  const SdFinancialItem(
      {super.key,
      this.data,
      required this.index,
      required this.openIndex,
      required this.onCardTapped});

  @override
  Widget build(BuildContext context) {
    bool isOpen = openIndex == index;
    return InkWell(
      onTap: () {
        onCardTapped(index);
      },
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: ThemeColors.greyBorder.withOpacity(0.4)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    "${data?.period}",
                    style: stylePTSansBold(),
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: isOpen ? 1 : 0.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, double value, child) {
                    return Transform.rotate(
                      angle: value * 3.14159,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_drop_down,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
