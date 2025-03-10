import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MorningStarFairValue extends StatelessWidget {
  final int? value;
  const MorningStarFairValue({super.key, this.value});

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
              Color(0xFFcc3333),
              ThemeColors.background,
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
              opacity: const AlwaysStoppedAnimation(.4),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Fair Value".toUpperCase(),
                  style: styleBaseBold(
                    color: ThemeColors.white,
                    fontSize: 18,
                  ),
                ),
                const SpacerVertical(height: 5),
                Text(
                  "As on - ${morningStar?.quantFairValueDate ?? "N/A"}",
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
                      Images.objective,
                      height: 65,
                      color: ThemeColors.white,
                    ),
                    Text(
                      morningStar?.quantFairValue ?? "N/A",
                      style:
                          styleBaseBold(color: ThemeColors.white, fontSize: 30),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
