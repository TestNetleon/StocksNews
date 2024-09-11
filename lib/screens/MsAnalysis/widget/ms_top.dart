import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../widgets/spacer_horizontal.dart';
import '../../../modals/msAnalysis/ms_top_res.dart';
import '../../../providers/stockAnalysis/provider.dart';

class MsTopWidgetDetail extends StatelessWidget {
  const MsTopWidgetDetail({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsStockTopRes? topData = provider.topData;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.greyBorder,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  margin: EdgeInsets.only(right: 5),
                  child: Text(
                    "Stock Price",
                    style: stylePTSansRegular(fontSize: 12),
                  ),
                ),
                Text(
                  "\$ USD",
                  style: stylePTSansRegular(fontSize: 12),
                ),
              ],
            ),
            SpacerVertical(height: 10),
            Text(topData?.price ?? "", style: stylePTSansBold(fontSize: 26)),
            Visibility(
              visible: topData?.changesPercentage != null,
              child: Row(
                children: [
                  Icon(
                    (topData?.changesPercentage ?? 0) > 0
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: (topData?.changesPercentage ?? 0) > 0
                        ? ThemeColors.accent
                        : Colors.red,
                    size: 20.sp,
                  ),
                  Text(
                    "${topData?.changeWithCur} (${topData?.changesPercentage}%)",
                    style: stylePTSansBold(
                      fontSize: 12,
                      color: (topData?.changesPercentage ?? 0) > 0
                          ? ThemeColors.accent
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SpacerHorizontal(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ThemeColors.greyBorder,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                margin: EdgeInsets.only(right: 0),
                child: Text(
                  "Mkt Cap",
                  style: stylePTSansRegular(fontSize: 12),
                ),
              ),
              SpacerVertical(height: 10),
              AutoSizeText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                topData?.marketCap ?? "",
                style: stylePTSansBold(fontSize: 26),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
