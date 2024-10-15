import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';

import '../../../modals/msAnalysis/ms_top_res.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/cache_network_image.dart';
import '../../../widgets/spacer_horizontal.dart';

class PredictionAppBar extends StatelessWidget {
  const PredictionAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsStockTopRes? topData = provider.topData;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: Colors.white,
            color: Colors.transparent,
            // border: Border.all(color: ThemeColors.white),
            border: Border.all(color: ThemeColors.accent),
          ),
          padding: const EdgeInsets.all(8),
          width: 48,
          height: 48,
          child: provider.isLoadingComplete && provider.topData == null
              ? null
              : CachedNetworkImagesWidget(
                  topData?.image ?? "",
                  fit: BoxFit.contain,
                ),
        ),
        SpacerHorizontal(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: provider.topData != null,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        topData?.symbol ?? "",
                        maxLines: 1,
                        style: stylePTSansBold(fontSize: 18),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: ThemeColors.greyBorder,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        topData?.exchange ?? "",
                        style: stylePTSansRegular(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: provider.topData != null,
                child: Row(
                  children: [
                    const Icon(
                      Icons.watch_later,
                      size: 15,
                      color: ThemeColors.greyText,
                    ),
                    const SpacerHorizontal(width: 5),
                    Text(
                      topData?.marketStatus ?? "",
                      style: stylePTSansRegular(
                        color: ThemeColors.greyText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
