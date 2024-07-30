import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/trading_simulator.dart';
import '../../../providers/stock_detail_new.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../../widgets/theme_button.dart';
import '../../stockDetail/summary/index.dart';

class BuyAndSellProceedButton extends StatelessWidget {
  final Function()? onTap;
  final TypeTrade selectedType;
  final String currentText;
  const BuyAndSellProceedButton(
      {super.key,
      this.onTap,
      required this.selectedType,
      required this.currentText});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    TradingSimulatorProvider tradeProvider =
        context.watch<TradingSimulatorProvider>();
    String cleanedString =
        provider.tabRes?.keyStats?.price?.replaceAll(RegExp(r'[^\d.]'), '') ??
            "";
    num price = num.parse(cleanedString);
    num invested = selectedType == TypeTrade.shares
        ? price * num.parse(currentText)
        : num.parse(currentText);

    num balance = tradeProvider.userPortfolio.currentBalance;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    text: "Balance: ",
                    style: stylePTSansBold(fontSize: 14),
                    children: [
                      TextSpan(
                        text: "\$${formatBalance(balance)}",
                        style: stylePTSansRegular(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: RichText(
                  text: TextSpan(
                      text: "Order Value: ",
                      style: stylePTSansBold(fontSize: 14),
                      children: [
                        TextSpan(
                          text: "\$${invested.toCurrency()}",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                      ]),
                ),
              ),
            ],
          ),
          const SpacerVertical(),
          ThemeButton(
            // text: widget.buy ? "Proceed Buy Order" : "Proceed Sell Order",
            text: "Proceed Buy Order",
            // color: widget.buy ? ThemeColors.accent : ThemeColors.sos,
            color: ThemeColors.accent,

            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
