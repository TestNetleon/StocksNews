import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

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
      borderRadius: BorderRadius.circular(5),
      onTap: () {
        onCardTapped(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Visibility(
              visible: isOpen,
              child: const Divider(
                color: ThemeColors.white,
                height: 20,
                thickness: 2,
              ),
            ),
            if (isOpen) ...[
              const SizedBox(height: 10),
              ...data?.toMap().entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "${entry.key}: ${entry.value ?? 'N/A'}",
                        //   style: stylePTSansRegular(height: 1.7),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                entry.key,
                                style: stylePTSansRegular(fontSize: 14),
                              ),
                            ),
                            entry.key == "Link"
                                ? InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {
                                      openUrl(entry.value);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.info_rounded,
                                        color: ThemeColors.accent,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                : Flexible(
                                    child: Text(
                                      "${entry.value ?? 'N/A'}",
                                      style: stylePTSansRegular(fontSize: 14),
                                    ),
                                  ),
                          ],
                        ),

                        const Divider(
                          color: ThemeColors.greyBorder,
                          height: 20,
                        ),
                      ],
                    );
                  }).toList() ??
                  [],
            ],
          ],
        ),
      ),
    );
  }
}
