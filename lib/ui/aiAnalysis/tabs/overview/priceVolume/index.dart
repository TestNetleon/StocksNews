import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../managers/aiAnalysis/ai.dart';
import '../../../../../models/market/market_res.dart';
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
  // List<String> menus = [
  //   'Past Returns',
  //   'Past Volume',
  // ];

  List<MarketResData> menus = [
    MarketResData(
      title: 'Past Returns',
      slug: '0',
    ),
    MarketResData(
      title: 'Past Volume',
      slug: '1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    AIManager manager = context.watch<AIManager>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: 'Price & Volume',
          margin: EdgeInsets.only(
              left: Pad.pad16,
              right: Pad.pad16,
              top: Pad.pad20,
              bottom: Pad.pad10),
        ),
        BaseTabs(
          isScrollable: false,
          data: menus,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            manager.getAiPvData(selectedIndex: selectedIndex);
          },
        ),

        // CustomSlidingSegmentedControl(
        //   menus: menus,
        //   onValueChanged: (index) {
        //     setState(() {
        //       selectedIndex = index;
        //     });
        //     manager.getAiPvData(selectedIndex: selectedIndex);
        //   },
        //   selectedIndex: selectedIndex,
        // ),
        // SpacerVertical(height: 10),
        if (selectedIndex == 0)
          _getWidget(
            manager: manager,
            child: AIPricePastReturns(),
            // child: Container(),
          ),
        if (selectedIndex == 1)
          _getWidget(
            manager: manager,
            child: AIPricePostVolume(),
            // child: Container(),
          ),
      ],
    );
  }

  Widget _getWidget({
    required AIManager manager,
    required Widget child,
  }) {
    if (manager.isLoadingPV) {
      return Container(
        padding: EdgeInsets.only(bottom: 40),
        child: Loading(),
      );
    }
    if (!manager.isLoadingPV && manager.dataPV == null) {
      return Container(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          "${manager.errorPV}",
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
