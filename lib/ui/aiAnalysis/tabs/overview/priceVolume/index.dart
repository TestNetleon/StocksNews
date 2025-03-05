import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/container.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/header.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../screens/MsAnalysis/overviewTabs/view/widgets/sliding_button.dart';
import '../../../../../widgets/loading.dart';
import 'widgets/past_return.dart';
import 'widgets/post_volume.dart';

class AIPriceVolume extends StatefulWidget {
  const AIPriceVolume({super.key});

  @override
  State<AIPriceVolume> createState() => _AIPriceVolumeState();
}

class _AIPriceVolumeState extends State<AIPriceVolume>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  List<String> menus = [
    'Past Returns',
    'Past Volume',
  ];

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return MsOverviewContainer(
      open: provider.openPriceVolume,
      baseChild: Padding(
        padding: EdgeInsets.all(12),
        child: MsOverviewHeader(
          leadingIcon: Icons.pie_chart,
          label: provider.completeData?.overviewText?.priceVolume?.title ??
              "Price & Volume",
          stateKey: MsProviderKeys.priceVolume,
          showInfo: provider.completeData?.overviewText?.priceVolume?.info,
        ),
      ),
      animatedChild: Column(
        children: [
          CustomSlidingSegmentedControl(
            menus: menus,
            onValueChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
              provider.getPriceVolumeData(
                symbol: provider.topData?.symbol ?? "",
                selectedIndex: selectedIndex,
              );
            },
            selectedIndex: selectedIndex,
          ),
          SpacerVertical(height: 10),
          if (selectedIndex == 0)
            _getWidget(
              provider: provider,
              child: AIPricePastReturns(),
            ),
          if (selectedIndex == 1)
            _getWidget(
              provider: provider,
              child: AIPricePostVolume(),
            ),
        ],
      ),
    );
  }

  Widget _getWidget({
    required MSAnalysisProvider provider,
    required Widget child,
  }) {
    if (provider.isLoadingPV) {
      return Container(
        padding: EdgeInsets.only(bottom: 40),
        child: Loading(),
      );
    }
    if (!provider.isLoadingPV &&
        (provider.pvData == null || provider.pvData?.isEmpty == true)) {
      return Container(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          "${provider.errorPV}",
          style: stylePTSansRegular(),
        ),
      );
    }

    return Visibility(
      // visible: provider.pvData != null && provider.pvData?.isNotEmpty == true,
      child: child,
    );
  }
}
