import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_open.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SHeader extends StatefulWidget {
  const SHeader({super.key});

  @override
  State<SHeader> createState() => _SHeaderState();
}

class _SHeaderState extends State<SHeader> {
  @override
  void initState() {
    super.initState();
  }

  void _getData() async {
    SOpenManager openManager = context.read<SOpenManager>();
    openManager.setStatus(Status.ideal);
  }

  @override
  Widget build(BuildContext context) {
    PortfolioManager manager = context.watch<PortfolioManager>();
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invested Amount",
                      style: styleBaseBold(
                        fontSize: 14,
                        color: ThemeColors.splashBG,
                      ),
                    ),
                    const SpacerVertical(height: Pad.pad8),
                    Text(
                      "\$${formatBalance(manager.userData?.userDataRes?.investedAmount ?? 0)}",
                      style: styleBaseBold(
                          fontSize: 18, color: ThemeColors.splashBG),
                    ),
                  ],
                ),
              ),
            ),
            const SpacerHorizontal(width: Pad.pad10),
            Expanded(
              child: CommonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Market Value",
                      style: styleBaseBold(
                        fontSize: 14,
                        color: ThemeColors.splashBG,
                      ),
                    ),
                    const SpacerVertical(height: Pad.pad8),
                    Text(
                      "\$${formatBalance(manager.userData?.userDataRes?.marketValue ?? 0)}",
                      style: styleBaseBold(
                          fontSize: 18, color: ThemeColors.splashBG),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SpacerVertical(height: Pad.pad10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Return",
                      style: styleBaseBold(
                        fontSize: 14,
                        color: ThemeColors.splashBG,
                      ),
                    ),
                    const SpacerVertical(height: Pad.pad8),
                    Text(
                      '${manager.userData?.userDataRes?.totalReturn?.toFormattedPrice() ?? 0}',
                      style: styleBaseBold(
                          fontSize: 18,
                          color: (manager.userData?.userDataRes?.totalReturn ?? 0) >= 0
                              ? ThemeColors.accent
                              : ThemeColors.sos
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SpacerHorizontal(width: Pad.pad10),
            Expanded(
              child: CommonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "1D Return",
                      style: styleBaseBold(
                        fontSize: 14,
                        color: ThemeColors.splashBG,
                      ),
                    ),
                    const SpacerVertical(height: Pad.pad8),
                    Text(
                      '${manager.userData?.userDataRes?.todayReturn?.toFormattedPrice() ?? 0}',
                      style: styleBaseBold(
                          fontSize: 18,
                          color: (manager.userData?.userDataRes?.todayReturn ??
                                      0) >=
                                  0
                              ? ThemeColors.accent
                              : ThemeColors.sos),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
