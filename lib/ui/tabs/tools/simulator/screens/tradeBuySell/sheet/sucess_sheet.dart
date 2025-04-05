import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

Future showTsOrderSuccessSheet(
    SummaryOrderNew? order, StockType? selectedStock) async {
  await BaseBottomSheet().bottomSheet(
      barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
      child: SuccessTradeSheet(
        order: order,
        selectedStock: selectedStock,
        close: true,
      ));
/*  await showModalBottomSheet(
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
    ),
    backgroundColor: ThemeColors.transparent,
    isScrollControlled: true,
    context: navigatorKey.currentContext!,
    builder: (context) {
      return SuccessTradeSheet(
        order: order,
        selectedStock: selectedStock,
        close: true,
      );
    },
  );*/
}

class SuccessTradeSheet extends StatelessWidget {
  final SummaryOrderNew? order;
  final StockType? selectedStock;
  final bool close;
  const SuccessTradeSheet(
      {super.key, this.order, required this.selectedStock, this.close = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.sp),
          topRight: Radius.circular(10.sp),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            selectedStock == StockType.buy
                ? ThemeColors.bottomsheetGradient
                : const Color.fromARGB(255, 35, 0, 0),
            Colors.black,
          ],
        ),
        color: ThemeColors.background,
        border: const Border(top: BorderSide(color: ThemeColors.greyBorder),),
      ),*/
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Pad.pad5),
                    child: Container(
                      padding: EdgeInsets.all(3.sp),
                      color: ThemeColors.neutral5,
                      child: CachedNetworkImagesWidget(
                        order?.image ?? "",
                        height: 41,
                        width: 41,
                      ),
                    ),
                  ),
                  SpacerHorizontal(width: Pad.pad10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order?.symbol ?? 'N/A',
                        style: styleBaseBold(
                            fontSize: 16, color: ThemeColors.splashBG),
                      ),
                      Text(
                        order?.name ?? 'N/A',
                        style: styleBaseRegular(
                          fontSize: 14,
                          color: ThemeColors.neutral40,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SpacerVertical(height: Pad.pad24),
              Text(
                'Order Detail',
                style: styleBaseBold(fontSize: 20, color: ThemeColors.splashBG),
              ),
              const SpacerVertical(height: Pad.pad10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "QTY",
                    style: styleBaseBold(
                        fontSize: 16, color: ThemeColors.splashBG),
                  ),
                  Flexible(
                    child: Text(
                      "${order?.shares?.toCurrency()}",
                      style: styleBaseRegular(
                          fontSize: 16, color: ThemeColors.splashBG),
                    ),
                  ),
                ],
              ),
              BaseListDivider(height: 15),
              Visibility(
                visible: order?.currentPrice != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Executed at",
                      style: styleBaseBold(
                          fontSize: 16, color: ThemeColors.splashBG),
                    ),
                    Flexible(
                      child: Text(
                        "${order?.currentPrice?.toFormattedPrice()}",
                        style: styleBaseRegular(
                            fontSize: 16, color: ThemeColors.splashBG),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.currentPrice != null,
                child: BaseListDivider(height: 15),
              ),
              Visibility(
                visible: order?.currentPrice != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order Value",
                      style: styleBaseBold(
                          fontSize: 16, color: ThemeColors.splashBG),
                    ),
                    Flexible(
                      child: Text(
                        ((order?.currentPrice ?? 0) * (order?.shares ?? 0))
                            .toFormattedPrice(),
                        style: styleBaseRegular(
                            fontSize: 16, color: ThemeColors.splashBG),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.currentPrice != null,
                child: BaseListDivider(height: 15),
              ),
              Visibility(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order Type",
                          style: styleBaseBold(
                              fontSize: 16, color: ThemeColors.splashBG),
                        ),
                        Text(
                          selectedStock == StockType.buy
                              ? "Buy"
                              : selectedStock == StockType.sell
                                  ? 'Sell'
                                  : selectedStock == StockType.short
                                      ? 'Short'
                                      : "Buy To Cover",
                          style: styleBaseRegular(
                              fontSize: 16, color: ThemeColors.splashBG),
                        ),
                      ],
                    ),
                    BaseListDivider(height: 15),
                  ],
                ),
              ),
              Visibility(
                visible: order?.date != null && order?.date != '',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order Date/Time",
                          style: styleBaseBold(
                              fontSize: 16, color: ThemeColors.splashBG),
                        ),
                        Text(
                          order?.date ?? '',
                          style: styleBaseRegular(
                              fontSize: 16, color: ThemeColors.splashBG),
                        ),
                      ],
                    ),
                    BaseListDivider(height: 15),
                  ],
                ),
              ),
            ],
          ),
          const SpacerVertical(),
          BaseButton(
            text: close ? "Go to Orders" : "My Orders",
            textColor: ThemeColors.splashBG,
            onPressed: () {
              Navigator.pop(context);
              if (!close) {
                // Navigator.pushNamed(context, SimulatorIndex.path);
                // Navigator.pushNamed(navigatorKey.currentContext!, Tabs.path,
                //     arguments: {
                //       'index': 2,
                //     });
                Navigator.push(
                  navigatorKey.currentContext!,
                  MaterialPageRoute(
                    builder: (context) => Tabs(
                      index: 2,
                    ),
                  ),
                );
              }
            },
          ),
          const SpacerVertical(height: 20),
        ],
      ),
    );
  }
}
