import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import '../../../../widgets/spacer_horizontal.dart';
import '../../../../widgets/theme_image_view.dart';

class TradeBuySellIndex extends StatelessWidget {
  final bool buy;
  final bool doPop;
  final dynamic qty;

  const TradeBuySellIndex({
    super.key,
    this.buy = true,
    this.doPop = true,
    this.qty,
  });

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;
    CompanyInfo? companyInfo = provider.tabRes?.companyInfo;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
      },
      child: BaseContainer(
        appBar: AppBarHome(
          isPopBack: true,
          title: keyStats?.symbol ?? "",
          subTitle: keyStats?.name ?? "",
          showTrailing: false,
          canSearch: false,
          widget: keyStats?.symbol == null
              ? null
              : Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.white,
                        border: Border.all(
                          color: ThemeColors.themeGreen,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      width: 48,
                      height: 48,
                      child: ThemeImageView(
                        url: companyInfo?.image ?? "",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SpacerHorizontal(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                keyStats?.symbol ?? "",
                                style: stylePTSansBold(fontSize: 18),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: ThemeColors.greyBorder,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  keyStats?.exchange ?? "",
                                  style: stylePTSansRegular(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            keyStats?.name ?? "",
                            style: stylePTSansRegular(
                              fontSize: 14,
                              color: ThemeColors.greyText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        body: BuySellContainer(buy: buy, doPop: doPop, qty: qty),
      ),
    );
  }
}
