import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/overview.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdStockScore extends StatelessWidget {
  const SdStockScore({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    StockScore? score = provider.overviewRes?.stockScore;
    return Column(
      children: [
        ScreenTitle(
          title: 'Stock Score/grades',
          subTitle: provider.overviewRes?.stockScore?.text,
        ),
        // StateItem(
        //     label: "Altman Z Score ", value: score?.altmanZScore ?? "N/A"),
        // StateItem(
        //     label: "Piotroski Score", value: score?.piotroskiScore ?? "N/A"),
        // StateItem(label: "Grade", value: score?.mostRepeatedGrade ?? "N/A"),
        Row(
          children: [
            Expanded(
                child: stockDOverviewItem(
                    title: "Altman Z Score", value: score?.altmanZScore)),
            const SpacerHorizontal(width: 8),
            Expanded(
                child: stockDOverviewItem(
                    title: "Piotroski Score", value: score?.piotroskiScore)),
          ],
        ),

        Container(
          margin: const EdgeInsets.only(top: 8),
          width: double.infinity,
          child: stockDOverviewItem(
              title: "Grade", value: score?.mostRepeatedGrade),
        ),
        const SpacerVertical(height: 10),
      ],
    );
  }
}

Container stockDOverviewItem({
  String? title,
  String? value,
  Function()? onTap,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: ThemeColors.background,
      borderRadius: BorderRadius.circular(5),
    ),
    // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    // decoration: BoxDecoration(
    //   border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
    //   gradient: const LinearGradient(
    //     begin: Alignment.centerLeft,
    //     end: Alignment.centerRight,
    //     colors: [
    //       Color.fromARGB(255, 23, 23, 23),
    //       Color.fromARGB(255, 36, 36, 36),
    //       Color.fromARGB(255, 23, 23, 23),
    //     ],
    //   ),
    //   // color: Color.fromARGB(255, 23, 23, 23),
    //   borderRadius: BorderRadius.circular(5),
    // ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "N/A",
          style: stylePTSansRegular(color: ThemeColors.greyText, fontSize: 15),
        ),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              value == null || value == '' ? "N/A" : value,
              style: stylePTSansBold(
                  fontSize: 20,
                  color:
                      onTap != null ? ThemeColors.accent : ThemeColors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
