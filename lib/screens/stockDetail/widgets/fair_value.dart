import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morning_start_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FairValue extends StatelessWidget {
  final int? value;
  const FairValue({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    MorningStar? morningStar =
        context.watch<StockDetailProviderNew>().overviewRes?.morningStart;
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
                  style: styleGeorgiaBold(fontSize: 18),
                ),
                const SpacerVertical(height: 5),
                Text(
                  "As on - ${morningStar?.quantFairValueDate ?? "N/A"}",
                  style: stylePTSansRegular(fontSize: 12),
                ),
                const SpacerVertical(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      Images.objective,
                      height: 65,
                      opacity: const AlwaysStoppedAnimation(.5),
                      color: Colors.white,
                    ),
                    Text(
                      "${morningStar?.quantFairValue ?? "N/A"}",
                      style: styleGeorgiaBold(
                          color: ThemeColors.white, fontSize: 30),
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
