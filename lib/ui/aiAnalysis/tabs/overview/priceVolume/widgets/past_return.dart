import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../../models/stockDetail/overview.dart';
import '../../../../../../models/stockDetail/price_volume.dart';

class AIPricePastReturns extends StatelessWidget {
  const AIPricePastReturns({super.key});

  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();
    AIPriceVolumeRes? dataPV = manager.dataPV;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return AIPricePastReturnsItem(
          index: index,
          pastReturns: dataPV?.data?[index],
        );
      },
      separatorBuilder: (context, index) {
        return BaseListDivider();
      },
      itemCount: dataPV?.data?.length ?? 0,
    );
  }
}

class AIPricePastReturnsItem extends StatelessWidget {
  final BaseKeyValueRes? pastReturns;
  final int index;
  const AIPricePastReturnsItem({
    super.key,
    required this.pastReturns,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Pad.pad10, vertical: Pad.pad10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "${pastReturns?.title}",
              textAlign: TextAlign.center,
              style: styleBaseRegular(
                color: ThemeColors.neutral80,
                fontSize: 14,
              ),
            ),
          ),
          const SpacerVertical(height: 10),
          Text(
            textAlign: TextAlign.end,
            "${pastReturns?.value}%",
            style: styleBaseBold(
              color: pastReturns?.value >= 0
                  ? ThemeColors.accent
                  : ThemeColors.sos,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
