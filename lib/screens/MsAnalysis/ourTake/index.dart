import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../providers/stockAnalysis/provider.dart';
import '../../../utils/constants.dart';
import '../widget/title_tag.dart';
import 'item.dart';

class MsOurTake extends StatefulWidget {
  const MsOurTake({super.key});

  @override
  State<MsOurTake> createState() => _MsOurTakeState();
}

class _MsOurTakeState extends State<MsOurTake> {
  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return BaseUiContainer(
      hasData: !provider.isLoadingPrice && provider.priceVolatility != null,
      isLoading: provider.isLoadingPrice,
      showPreparingText: true,
      hideWidget: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Dimen.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MsTitle(title: "Our Take"),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return MsOurTakeItem(
                  title: provider.priceVolatility?.keyHighlights?[index],
                );
              },
              separatorBuilder: (context, index) {
                return SpacerVertical(height: 10);
              },
              itemCount: provider.priceVolatility?.keyHighlights?.length ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}
