import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_pending_list_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class ActionInOrders extends StatefulWidget {
  final String? symbol;
  final TsPendingListRes? item;
  final int index;

  const ActionInOrders(
      {super.key, this.symbol, this.item, required this.index});

  @override
  State<ActionInOrders> createState() => _ActionInOrdersState();
}

class _ActionInOrdersState extends State<ActionInOrders> {
  bool disposeSheet = true;

  @override
  void initState() {
    super.initState();
  }

  void _onEditClick() {
    disposeSheet = false;
    setState(() {});
    popUpAlert(
      icon: Images.alertPopGIF,
      title: "Confirm",
      message: "Do you want to edit this order?",
      cancel: true,
      okText: "Edit",
      onTap: () {
        Navigator.pop(navigatorKey.currentContext!);
        TsPendingListProvider provider = context.read<TsPendingListProvider>();
        if (widget.item?.orderTypeOriginal == "MARKET_ORDER") {
          if (widget.item?.tradeType == "Short") {
            provider.shortRedirection(index: widget.index);
          } else {
            provider.editStock(index: widget.index);
          }
        } else {
          if ((widget.item?.orderTypeOriginal == "BRACKET_ORDER") ||
              (widget.item?.orderTypeOriginal == "LIMIT_ORDER")) {
            provider.conditionalRedirection(
                index: widget.index, qty: widget.item?.quantity);
          }
        }
      },
    );
  }

  void _onCancelClick() {
    disposeSheet = false;
    setState(() {});
    popUpAlert(
      icon: Images.alertPopGIF,
      title: "Confirm",
      message: "Do you want to cancel this order?",
      cancel: true,
      cancelText: "No",
      okText: "Yes, cancel",
      onTap: () async {
        Navigator.pop(navigatorKey.currentContext!);
        TsPendingListProvider provider = context.read<TsPendingListProvider>();
        provider.cancleOrder(widget.item?.id);
      },
    );
  }

  @override
  void dispose() {
    if (disposeSheet) {
      Utils().showLog('Disposing tradeSheet');
      SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();
    StockDataManagerRes? stock = provider.tappedStock;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ThemeColors.greyBorder,
                    shape: BoxShape.circle,
                  ),
                  width: 50,
                  height: 50,
                  child: CachedNetworkImagesWidget(widget.item?.image ?? ""),
                ),
              ),
              const SpacerHorizontal(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.item?.symbol}',
                      style: styleGeorgiaBold(
                          color: ThemeColors.blackShade, fontSize: 18),
                    ),
                    Text(
                      '${widget.item?.company}',
                      style: styleGeorgiaRegular(
                          color: ThemeColors.blackShade, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SpacerHorizontal(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: stock?.price != null,
                    child: Text(
                      '${stock?.price?.toFormattedPrice()}',
                      style: styleGeorgiaBold(
                          color: ThemeColors.blackShade, fontSize: 22),
                    ),
                  ),
                  Visibility(
                    visible: stock?.change != null &&
                        stock?.changePercentage != null,
                    child: Text(
                      '${stock?.change?.toFormattedPrice()} (${stock?.changePercentage?.toCurrency()}%)',
                      style: styleGeorgiaRegular(
                        color: (stock?.change ?? 0) >= 0
                            ? ThemeColors.accent
                            : ThemeColors.sos,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SpacerVertical(height: 10),
          Divider(
            color: ThemeColors.greyBorder,
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ThemeButton(
                  text: "Edit Order",
                  color: const Color.fromARGB(255, 210, 191, 15),
                  onPressed: _onEditClick,
                  textColor: ThemeColors.primary,
                ),
              ),
              const SpacerHorizontal(width: 10),
              Expanded(
                child: ThemeButton(
                  text: "Cancel Order",
                  color: ThemeColors.darkRed,
                  onPressed: _onCancelClick,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
