import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_open_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/tradeSheet.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

import '../../providers/trade_provider.dart';

class TsDashboardHeader extends StatefulWidget {
  const TsDashboardHeader({super.key});

  @override
  State<TsDashboardHeader> createState() => _TsDashboardHeaderState();
}

class _TsDashboardHeaderState extends State<TsDashboardHeader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  void _getData() async {
    TsOpenListProvider orderProvider = context.read<TsOpenListProvider>();
    TsPortfolioProvider provider = context.read<TsPortfolioProvider>();
    orderProvider.setStatus(Status.ideal);
    await provider.getDashboardData();
    orderProvider.getData();
  }

  @override
  Widget build(BuildContext context) {
    // TsPortfolioProvider provider = context.watch<TsPortfolioProvider>();
    TradeProviderNew tradeProvider = context.watch<TradeProviderNew>();
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            ThemeColors.accent,
            Color.fromARGB(255, 222, 215, 7),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\$${formatBalance(num.parse(tradeProvider.data.availableBalance.toCurrency()))}",
                          // "\$${formatBalance(provider.userData?.tradeBalance ?? 0)}",
                          style: styleGeorgiaBold(fontSize: 25),
                        ),
                        const SpacerVertical(height: 5),
                        Text(
                          "Total Portfolio",
                          style: stylePTSansRegular(
                            fontSize: 15,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpacerHorizontal(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          // "\$${provider.data.invested.toCurrency()}",
                          // "\$${formatBalance(userProvider.userData?.tradeBalance ?? 0)}",
                          "\$${formatBalance(tradeProvider.data.invested)}",
                          style: styleGeorgiaBold(fontSize: 25),
                        ),
                        const SpacerVertical(height: 5),
                        Text(
                          "Positions P&L",
                          style: stylePTSansRegular(
                              fontSize: 15, color: ThemeColors.greyText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 30),
              ThemeButtonSmall(
                textSize: 17,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                onPressed: tradeSheet,
                text: "Place New Virtual Trade",
                color: const Color.fromARGB(255, 194, 216, 51),
                icon: Icons.arrow_outward_outlined,
                textColor: ThemeColors.background,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
