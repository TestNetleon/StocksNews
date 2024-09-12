import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/msAnalysis/stock_highlights.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import '../../../utils/constants.dart';
import '../widget/title_tag.dart';
import 'item.dart';

class MsOurHighlights extends StatelessWidget {
  const MsOurHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    return BaseUiContainer(
      hasData: !provider.isLoadingHighLight &&
          (provider.stockHighlight != null &&
              provider.stockHighlight?.isNotEmpty == true),
      isLoading: provider.isLoadingHighLight,
      error: provider.errorHighlight,
      showPreparingText: true,
      hideWidget: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Dimen.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MsTitle(title: "Stock Highlights"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    provider.stockHighlight?.length ?? 0,
                    (index) {
                      MsStockHighlightsRes? data =
                          provider.stockHighlight?[index];
                      return MsOurHighlightsItem(data: data);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
