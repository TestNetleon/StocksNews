import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


Future showCOrderSuccessSheet(SummaryOrderNew? order, ConditionType? conditionalType) async {
  /*await showModalBottomSheet(
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
      return SuccessConditionalSheet(
        order: order,
        conditionalType: conditionalType,
        close: true,
      );
    },
  );*/
  await BaseBottomSheet().bottomSheet(
      barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
      child:SuccessConditionalSheet(
      order: order,
      conditionalType: conditionalType,
      close: true,
    )
  );
}

class SuccessConditionalSheet extends StatelessWidget {
  final SummaryOrderNew? order;
  final ConditionType? conditionalType;
  final bool close;
  const SuccessConditionalSheet(
      {super.key,
      this.order,
      required this.conditionalType,
      this.close = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
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
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: CachedNetworkImagesWidget(order?.image),
                  ),
                  SpacerHorizontal(width: Pad.pad10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order?.symbol ?? 'N/A',
                          style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),
                        ),
                        Text(
                          order?.name ?? 'N/A',
                          style: stylePTSansRegular(
                            fontSize: 14,
                            color: ThemeColors.neutral40,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SpacerVertical(height: Pad.pad24),
              Text(
                'Order Detail',
                style: styleGeorgiaBold(fontSize: 20,color: ThemeColors.splashBG),
              ),
              const SpacerVertical(height: Pad.pad10),
              Visibility(
                visible: order?.shares!=null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "QTY",
                      style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                    ),
                    Flexible(
                      child: Text(
                        "${order?.shares?.toCurrency()}",
                        style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.shares != null,
                child: Divider(
                  color: ThemeColors.neutral5,
                  thickness: 1,
                  height: 15,
                ),
              ),
              Visibility(
                visible: order?.currentPrice != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Executed at",
                      style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                    ),
                    Flexible(
                      child: Text(
                        "${order?.currentPrice?.toFormattedPrice()}",
                        style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.currentPrice != null,
                child: Divider(
                  color: ThemeColors.neutral5,
                  thickness: 1,
                  height: 15,
                ),
              ),
              Visibility(
                visible: order?.currentPrice != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order Value",
                      style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                    ),
                    Flexible(
                      child: Text(
                        ((order?.currentPrice ?? 0) * (order?.shares ?? 0))
                            .toFormattedPrice(),
                        style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.currentPrice != null,
                child: Divider(
                  color: ThemeColors.neutral5,
                  thickness: 1,
                  height: 15,
                ),
              ),
              Visibility(
                visible: order?.targetPrice != null && order?.targetPrice != 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Target Price",
                      style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                    ),
                    Flexible(
                      child: Text(
                        ((order?.targetPrice ?? 0)).toFormattedPrice(),
                        style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.targetPrice != null && order?.targetPrice != 0,
                child:Divider(
                  color: ThemeColors.neutral5,
                  thickness: 1,
                  height: 15,
                ),
              ),
              Visibility(
                visible: order?.stopPrice != null && order?.stopPrice != 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      conditionalType == ConditionType.trailingOrder?
                      "Trail Price":
                      "Stop Price",
                      style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                    ),
                    Flexible(
                      child: Text(
                        (order?.stopPrice ?? 0).toFormattedPrice(),
                        style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.stopPrice != null && order?.stopPrice != 0,
                child: Divider(
                  color: ThemeColors.neutral5,
                  thickness: 1,
                  height: 15,
                ),
              ),
              Visibility(
                visible: order?.limitPrice != null && order?.limitPrice != 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Limit Price",
                      style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                    ),
                    Flexible(
                      child: Text(
                        (order?.limitPrice ?? 0).toFormattedPrice(),
                        style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.limitPrice != null && order?.limitPrice != 0,
                child: Divider(
                  color: ThemeColors.neutral5,
                  thickness: 1,
                  height: 15,
                ),
              ),
              Visibility(
                visible: order?.investedPrice != null && order?.investedPrice != 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recurring Amt.",
                      style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                    ),
                    Flexible(
                      child: Text(
                        (order?.investedPrice ?? 0).toFormattedPrice(),
                        style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.investedPrice != null && order?.investedPrice != 0,
                child: Divider(
                  color: ThemeColors.neutral5,
                  thickness: 1,
                  height: 15,
                ),
              ),
              Visibility(
                visible: order?.selectedOption != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Frequency",
                      style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                    ),
                    Flexible(
                      child: Text(
                        order?.selectedOption==1?"Every Market Day":order?.selectedOption==2?"Every week":order?.selectedOption==3?"Every two weeks":"Every month",
                        style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: order?.selectedOption != null && order?.selectedOption != 0,
                child: Divider(
                  color: ThemeColors.neutral5,
                  thickness: 1,
                  height: 15,
                ),
              ),
              Visibility(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order Type",
                          style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                        ),
                        Text(
                          conditionalType == ConditionType.bracketOrder
                              ? "Bracket Order"
                              :
                          conditionalType == ConditionType.limitOrder?
                          "Limit Order":
                          conditionalType == ConditionType.stopOrder?
                          "Stop Order":
                          conditionalType == ConditionType.stopLimitOrder?
                          "Stop Limit Order":
                          conditionalType == ConditionType.trailingOrder?
                          "Trailing Order":"Recurring Order",
                          style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                        ),
                      ],
                    ),
                    Divider(
                      color: ThemeColors.neutral5,
                      thickness: 1,
                      height: 15,
                    ),
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
                          style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),

                        ),
                        Text(
                          order?.date ?? '',
                          style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),

                        ),
                      ],
                    ),
                    Divider(
                      color: ThemeColors.neutral5,
                      thickness: 1,
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SpacerVertical(height: 20),
          BaseButton(
            text: close ? "Go to Orders" : "My Orders",
            textColor: ThemeColors.splashBG,
            onPressed: () {
              Navigator.pop(context);
              if (!close) {
                Navigator.pushNamed(context, SimulatorIndex.path);
              }
            },
          ),
          const SpacerVertical(height: 20),
        ],
      ),
    );
  }
}
