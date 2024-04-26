import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stocks_other_detail_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/states.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class StocksScoreGrades extends StatelessWidget {
  const StocksScoreGrades({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    Score? score = provider.otherData?.score;
    if (provider.otherLoading &&
        provider.otherData?.earning?.data?.isEmpty == true) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: ThemeColors.accent,
            ),
            const SpacerHorizontal(width: 5),
            Flexible(
              child: Text(
                "Fetching stock score/grades data...",
                style: stylePTSansRegular(color: ThemeColors.accent),
              ),
            ),
          ],
        ),
      );
    }

    if (!provider.otherLoading &&
        provider.otherData?.earning?.data?.isEmpty == true) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Column(
        children: [
          ScreenTitle(
            title: score?.title ?? "",
            subTitle: score?.text,
            // style: stylePTSansRegular(fontSize: 20),
          ),
          StateItem(label: "Altman Z Score ", value: score?.data?.altmanZScore),
          StateItem(
              label: "Piotroski Score", value: score?.data?.piotroskiScore),
          StateItem(label: "Grade", value: score?.data?.grade),
        ],
      ),
    );
  }
}
