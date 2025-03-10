import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morning_start_res.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MorningStarValuable extends StatelessWidget {
  final MorningStar? morningStar;
  final int? value;
  const MorningStarValuable({super.key, this.morningStar, this.value});

  @override
  Widget build(BuildContext context) {
    MorningStarRes? morningStar =
        context.watch<SDManager>().dataOverview?.morningStar;

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
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: [
            Image.asset(
              Images.newLineBG,
              height: 120,
              fit: BoxFit.fill,
              width: MediaQuery.sizeOf(context).width,
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Valuation".toUpperCase(),
                          style: styleBaseBold(
                            fontSize: 18,
                            color: ThemeColors.white,
                          )),
                      const SpacerVertical(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            Images.transferMoney,
                            height: 50,
                            color: ThemeColors.white,
                          ),
                          const SpacerHorizontal(
                            width: 40.0,
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: morningStar?.quantValuation ==
                                          "Undervalued"
                                      ? [
                                          const Color(0xFFF29625),
                                          const Color.fromARGB(
                                              255, 144, 87, 17),
                                        ]
                                      : morningStar?.quantValuation ==
                                              "Fairly Valued"
                                          ? [
                                              const Color(0xFF0EAD05),
                                              const Color(0xFF0B5F0D),
                                            ]
                                          // Overvalued
                                          : [
                                              const Color(0xFFE72929),
                                              const Color(0xFFF35858),
                                            ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${morningStar?.quantValuation}"
                                      .toUpperCase(),
                                  style: styleBaseBold(color: Colors.white),
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
