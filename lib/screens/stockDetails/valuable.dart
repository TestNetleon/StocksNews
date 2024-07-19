import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morning_start_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class Valuable extends StatelessWidget {
  final MorningStar? morningStar;
  final int? value;
  const Valuable({super.key, this.morningStar, this.value});

  @override
  Widget build(BuildContext context) {
    MorningStar? morningStar =
        context.watch<StockDetailProviderNew>().overviewRes?.morningStart;
    int value = morningStar?.quantEconomicMoatLabel == "Narrow"
        ? 70
        : morningStar?.quantEconomicMoatLabel == "Wide"
            ? 99
            : 0;
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [      
              Color(0xff005bef),
              Color.fromARGB(255, 26, 24, 24),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Image.asset(
              Images.newLineBG,
              height: 120,
              fit: BoxFit.fill,
              width: MediaQuery.sizeOf(context).width,
              color: Colors.white,
              opacity: const AlwaysStoppedAnimation(.4),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Valuation".toUpperCase(),
                          style: styleGeorgiaBold(fontSize: 18)),
                      const SpacerVertical(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            Images.transferMoney,
                            height: 50,
                            opacity: const AlwaysStoppedAnimation(.5),
                            color: Colors.white,
                          ),
                          const SpacerHorizontal(
                            width: 40.0,
                          ),
                          Expanded(
                            child: Container(
                              width: constraints.maxWidth * (value / 100),
                              height: 40,
                              decoration: BoxDecoration(
                                // color: ThemeColors.accent,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: morningStar?.quantValuation ==
                                          "Undervalued"
                                      ? [
                                          const Color.fromARGB(
                                              255, 242, 150, 37),
                                          const Color.fromARGB(
                                              255, 144, 87, 17),
                                        ]
                                      : morningStar?.quantValuation ==
                                              "Fairly Valued"
                                          ? [
                                              const Color.fromARGB(
                                                  255, 14, 173, 5),
                                              const Color.fromARGB(
                                                  255, 11, 95, 13),
                                            ]
                                          // Overvalued
                                          : [
                                              const Color.fromARGB(
                                                  255, 231, 41, 41),
                                              const Color.fromARGB(
                                                  255, 243, 88, 88),
                                            ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${morningStar?.quantValuation}"
                                      .toUpperCase(),
                                  style: stylePTSansBold(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
