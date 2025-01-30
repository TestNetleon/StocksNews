import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../../utils/colors.dart';

Future showCOrderSuccessSheet(
    SummaryOrderNew? order, ConditionType? conditionalType) async {
  await showModalBottomSheet(
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.sp),
          topRight: Radius.circular(10.sp),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            conditionalType == ConditionType.bracketOrder
                ? ThemeColors.bottomsheetGradient
                : const Color.fromARGB(255, 35, 0, 0),
            Colors.black,
          ],
        ),
        color: ThemeColors.background,
        border: const Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          0,
          Dimen.padding,
          0,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            SpacerVertical(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CachedNetworkImagesWidget(order?.image),
                    ),
                    SpacerHorizontal(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order?.symbol ?? 'N/A',
                            style: styleGeorgiaBold(fontSize: 20),
                          ),
                          Text(
                            order?.name ?? 'N/A',
                            style: styleGeorgiaRegular(
                                color: ThemeColors.greyText),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SpacerVertical(height: 25),
                Text(
                  'Order Detail',
                  style: styleGeorgiaBold(fontSize: 20),
                ),
                const SpacerVertical(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "QTY",
                      style: styleGeorgiaRegular(
                        color: ThemeColors.white,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "${order?.shares?.toCurrency()}",
                        style: styleGeorgiaRegular(
                          color: ThemeColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: ThemeColors.greyText,
                  height: 15,
                ),
                Visibility(
                  visible: order?.currentPrice != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Executed at",
                        style: styleGeorgiaRegular(
                          color: ThemeColors.white,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "${order?.currentPrice?.toFormattedPrice()}",
                          style: styleGeorgiaRegular(
                            color: ThemeColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: order?.currentPrice != null,
                  child: Divider(
                    color: ThemeColors.greyText,
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
                        style: styleGeorgiaRegular(
                          color: ThemeColors.white,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          ((order?.currentPrice ?? 0) * (order?.shares ?? 0))
                              .toFormattedPrice(),
                          style: styleGeorgiaRegular(
                            color: ThemeColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: order?.currentPrice != null,
                  child: Divider(
                    color: ThemeColors.greyText,
                    height: 15,
                  ),
                ),

                Visibility(
                  visible: order?.targetPrice != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Target Price",
                        style: styleGeorgiaRegular(
                          color: ThemeColors.white,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          ((order?.targetPrice ?? 0)).toFormattedPrice(),
                          style: styleGeorgiaRegular(
                            color: ThemeColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: order?.targetPrice != null,
                  child: Divider(
                    color: ThemeColors.greyText,
                    height: 15,
                  ),
                ),

                Visibility(
                  visible: order?.stopPrice != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stop Price",
                        style: styleGeorgiaRegular(
                          color: ThemeColors.white,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          (order?.stopPrice ?? 0).toFormattedPrice(),
                          style: styleGeorgiaRegular(
                            color: ThemeColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: order?.stopPrice != null,
                  child: Divider(
                    color: ThemeColors.greyText,
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
                            style: styleGeorgiaRegular(
                              color: ThemeColors.white,
                            ),
                          ),
                          Text(
                            conditionalType == ConditionType.bracketOrder
                                ? "Bracket Order"
                                : "Buy to Cover",
                            style: styleGeorgiaRegular(
                              color: ThemeColors.white,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: ThemeColors.greyText,
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
                            style: styleGeorgiaRegular(
                              color: ThemeColors.white,
                            ),
                          ),
                          Text(
                            order?.date ?? '',
                            style: styleGeorgiaRegular(
                              color: ThemeColors.white,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: ThemeColors.greyText,
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SpacerVertical(height: 40),
            ThemeButton(
              text: close ? "Go to Orders" : "My Orders",
              onPressed: () {
                Navigator.pop(context);
                if (!close) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TsDashboard(),
                    ),
                  );
                }
              },
            ),
            const SpacerVertical(height: 100),
          ],
        ),
      ),
    );
  }
}
