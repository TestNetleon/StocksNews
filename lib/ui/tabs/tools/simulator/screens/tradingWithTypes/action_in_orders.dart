import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/button_outline.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_pending.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_pending_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class ActionInOrders extends StatefulWidget {
  final String? symbol;
  final TsPendingListRes? item;
  final int index;

  const ActionInOrders({
    super.key,
    this.symbol,
    this.item,
    required this.index
  });

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
        Navigator.pop(context);
        SPendingManager manager = context.read<SPendingManager>();
        if(widget.item?.orderTypeOriginal == "MARKET_ORDER"){
          if (widget.item?.tradeType == "Short") {
            manager.shortRedirection(index: widget.index);
          } else {
            manager.editStock(index:  widget.index);
          }
        }
        else{
          manager.stockHoldingOfCondition(index:  widget.index);
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
        Navigator.pop(context);
        SPendingManager manager = context.read<SPendingManager>();
        manager.cancleOrder(widget.item?.id);
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
    TradeManager manager = context.watch<TradeManager>();
    StockDataManagerRes? stock = manager.tappedStock;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Pad.pad5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(38),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ThemeColors.greyBorder,
                    shape: BoxShape.circle,
                  ),
                  width: 38,
                  height: 38,
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
                          color: ThemeColors.splashBG, fontSize: 16),
                    ),
                    Text(
                      '${widget.item?.company}',
                      style: styleGeorgiaRegular(
                          color: ThemeColors.neutral40, fontSize: 14),
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
                          color: ThemeColors.splashBG, fontSize: 16),
                    ),
                  ),
                  Visibility(
                    visible: stock?.change != null &&
                        stock?.changePercentage != null,
                    child: Text(
                      '${stock?.change?.toFormattedPrice()} (${stock?.changePercentage?.toCurrency()}%)',
                      style: styleGeorgiaRegular(
                        color: (stock?.change ?? 0) >= 0
                            ?  ThemeColors.success120
                            : ThemeColors.error120,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SpacerVertical(height: 10),
          Divider(
            color: ThemeColors.neutral5,
            thickness: 1,
            height: 20,
          ),
          BaseButtonOutline(
            onPressed:_onEditClick,
            text: "Edit Order",
            textColor: ThemeColors.neutral40,
            borderColor: ThemeColors.neutral20,
            borderWidth: 1,
            fontBold: true,
          ),
          SpacerVertical(height: 10),
          BaseButton(
            text: "Cancel Order",
            color: ThemeColors.error120,
            onPressed:_onCancelClick,
            textColor: ThemeColors.white,
          ),

        ],
      ),
    );
  }
}
