import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import '../../../../widgets/spacer_horizontal.dart';
import '../../../../widgets/theme_image_view.dart';
import '../../modals/ts_topbar.dart';
import '../../providers/trade_provider.dart';

class TradeBuySellIndex extends StatelessWidget {
  final num? qty;
  final num? editTradeID;
  final StockType? selectedStock;

  const TradeBuySellIndex({
    super.key,
    this.qty,
    this.editTradeID,
    this.selectedStock,
  });

  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();
    TsStockDetailRes? detailRes = provider.detailRes;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
      },
      child: BaseContainer(
        appBar: AppBarHome(
          isPopBack: true,
          title: detailRes?.symbol ?? "",
          subTitle: detailRes?.company ?? "",
          showTrailing: false,
          canSearch: false,
          widget: detailRes?.symbol == null
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
                        url: detailRes?.image ?? "",
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
                                detailRes?.symbol ?? "",
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
                                  detailRes?.exchange ?? "",
                                  style: stylePTSansRegular(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            detailRes?.company ?? "",
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
                    /*Expanded(
                      child:Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            simTradeSheet(
                              symbol:detailRes?.symbol ?? "",
                              doPop: false,
                            );
                          },
                          child: Text(
                            "Trade option",
                            style: stylePTSansBold(fontSize:14),
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
        ),
        body: BuySellContainer(
          selectedStock: selectedStock,
          qty: qty,
          editTradeID: editTradeID,
        ),
      ),
    );
  }
}
