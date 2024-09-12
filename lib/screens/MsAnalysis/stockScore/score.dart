import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import '../../../utils/constants.dart';
import 'item.dart';

class MsStockScore extends StatelessWidget {
  const MsStockScore({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return BaseUiContainer(
      isLoading: provider.isLoadingPrice,
      hasData: !provider.isLoadingPrice &&
          !provider.isLoadingPrice &&
          provider.priceVolatility != null,
      showPreparingText: true,
      hideWidget: true,
      // placeholder: ClipRRect(
      //   borderRadius: BorderRadius.circular(12),
      //   child: Container(
      //     height: 110,
      //     decoration: BoxDecoration(
      //       border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.5)),
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //   ),
      // ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: Dimen.padding),
        child: MsStockScoreItem(),
      ),
    );
  }
}
