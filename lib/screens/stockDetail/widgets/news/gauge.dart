import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../stockDetails/widgets/technicalAnalysis/widgets/item.dart';

class SDNewsGauge extends StatefulWidget {
  final String? symbol;
  const SDNewsGauge({super.key, this.symbol});

  @override
  State<SDNewsGauge> createState() => _SDNewsGaugeState();
}

class _SDNewsGaugeState extends State<SDNewsGauge> {
  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    num value = provider.value ?? 0;
    log("---value is $value");
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            value >= -100 && value <= -49
                ? const Color.fromARGB(255, 76, 18, 2)
                : value >= -50 && value <= -1
                    ? const Color.fromARGB(255, 87, 50, 2)
                    : value >= 0 && value <= 49
                        ? const Color.fromARGB(255, 2, 71, 12)
                        : value >= 50 && value <= 100
                            ? const Color.fromARGB(255, 1, 47, 8)
                            : const Color.fromARGB(255, 2, 71, 12),
            value >= -100 && value <= -49
                ? const Color.fromARGB(255, 236, 56, 6)
                : value >= -50 && value <= -1
                    ? const Color.fromARGB(255, 231, 112, 7)
                    : value >= 0 && value <= 49
                        ? const Color.fromARGB(255, 7, 235, 41)
                        : value >= 50 && value <= 100
                            ? const Color.fromARGB(255, 4, 148, 25)
                            : const Color.fromARGB(255, 2, 71, 12),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Text(
              "Market Mood Indicator",
              style: styleGeorgiaBold(fontSize: 20),
            ),
            Text(
              "Real-Time Market Mood Measured by News Analysis",
              textAlign: TextAlign.center,
              style: stylePTSansRegular(fontSize: 15, height: 1.5),
            ),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  TechnicalAnalysisGaugeItem(
                    width: 10,
                    tickOffset: 4,
                    value: value.toDouble(),
                  ),
                  Positioned(
                    left: 30,
                    bottom: 0,
                    child: Text(
                      "Bearish",
                      style: stylePTSansBold(),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: 0,
                    child: Text(
                      "Bullish",
                      style: stylePTSansBold(),
                    ),
                  ),
                ],
              ),
            ),
            const SpacerVertical(height: 15),
            CupertinoSlidingSegmentedControl<int>(
              groupValue: provider.selectedIndex,
              thumbColor: ThemeColors.greyBorder.withOpacity(0.4),
              padding: const EdgeInsets.all(4),
              backgroundColor: const Color.fromARGB(255, 28, 28, 28),
              onValueChanged: (int? index) {
                // setState(() {
                //   _selectedIndex = index!;
                //   if (index == 0) {
                //     value = -30;
                //   } else if (index == 1) {
                //     value = -70;
                //   } else if (index == 2) {
                //     value = 20;
                //   } else if (index == 3) {
                //     value = 70;
                //   }
                // });

                provider.onGaugeChange(
                    index: index,
                    day: index == 0
                        ? "1D"
                        : index == 1
                            ? "7D"
                            : index == 2
                                ? "15D"
                                : "30D",
                    symbol: widget.symbol);
              },
              children: {
                for (int i = 0; i < provider.range.length; i++)
                  i: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Text(
                      provider.range[i],
                      style: styleGeorgiaRegular(
                        fontSize: 13,
                        color: provider.selectedIndex == i
                            ? ThemeColors.accent
                            : ThemeColors.white,
                        // color: ThemeColors.white,
                      ),
                    ),
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
