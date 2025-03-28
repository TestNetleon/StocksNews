import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MorningStarEconomicMoat extends StatelessWidget {
  // final MorningStar? morningStar;
  final int? value;
  const MorningStarEconomicMoat({super.key, this.value});

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
              Color(0xFF99cc00),
              Color.fromARGB(255, 8, 8, 8),
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
                      Text(
                        "Economic Moat".toUpperCase(),
                        style: styleBaseBold(
                            fontSize: 18, color: ThemeColors.white),
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        "As on - ${morningStar?.updated ?? "N/A"}",
                        style: styleBaseRegular(
                          fontSize: 12,
                          color: ThemeColors.white,
                        ),
                      ),
                      const SpacerVertical(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            Images.economic,
                            height: 50,
                            color: ThemeColors.white,
                          ),
                          const SpacerHorizontal(
                            width: 40.0,
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 245, 250, 245),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 9.0, right: 8.0),
                                child: Text(
                                  "${morningStar?.quantEconomicMoatLabel}"
                                      .toUpperCase(),
                                  style: styleBaseBold(color: Colors.black),
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
