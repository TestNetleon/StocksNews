import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/tournament_user/widget/my_trades_sheet.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class TickerItem extends StatelessWidget {
  final RecentTradeRes? data;
  final int? fromTO;

  const TickerItem({super.key, this.data, this.fromTO});

  @override
  Widget build(BuildContext context) {
    return
      Consumer<ThemeManager>(builder: (context, value, child) {
        bool isDark = value.isDarkMode;
        return InkWell(
      onTap : data?.status==0?() {
        myTradeSheet(
          symbol:data?.symbol,
          data:data,
            fromTO:fromTO
        );
      }:null,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: isDark ? null : ThemeColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        width: 43.sp,
                        height: 43.sp,
                        padding: EdgeInsets.all(5.sp),
                        child: CachedNetworkImagesWidget(data?.image)
                    ),
                    const SpacerHorizontal(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data?.symbol ?? '',
                                        style: styleBaseBold(fontSize: 16),
                                      ),
                                      Visibility(visible: data?.status == 0,child: const SpacerHorizontal(width: 5)),
                                      Visibility(
                                        visible: data?.status == 0,
                                        child: Text(
                                          '(${data?.currentPrice?.toFormattedPrice() ?? '\$0'})',
                                          style: styleBaseBold(
                                              fontSize: 14,
                                              color: (data?.currentPrice ?? 0) > 0
                                                  ? ThemeColors.success120
                                                  : (data?.currentPrice ?? 0) == 0
                                                  ? ThemeColors.white
                                                  : ThemeColors.error120
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: data?.type != null,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:data?.type != "sell"
                                            ? ThemeColors.success120
                                            : ThemeColors.error120,

                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(
                                        data?.type != "sell" ? "BUY" : "SELL",
                                        style: styleBaseBold(
                                          fontSize: 10,
                                          color:ThemeColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SpacerVertical(height: 5),
                              Text(
                                data?.name ?? "",
                                style: styleBaseRegular(
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                BaseListDivider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: _richPrices(
                          label: "Order price: ", value: data?.orderPrice?.toFormattedPrice() ?? '\$0'),
                    ),
                    const SpacerHorizontal(width: 10),
                    Flexible(
                        child: _richPrices(
                            label: "Close price: ", value: data?.closePrice?.toFormattedPrice() ?? '\$0')),
                  ],
                ),
                SpacerVertical(height: Pad.pad10),
                BaseListDivider(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isDark? ThemeColors.white:ThemeColors.lightGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: _richPrices1(label: "Gain/Loss: ", value: data?.gainLoss?.toFormattedPrice() ?? '\$0',values: data?.gainLoss??0)),
                const SpacerHorizontal(width: 10),
                Flexible(
                  child: _richPrices1(
                      label: "Performance: ",
                      value: "${data?.performance?.toCurrency()??"0"}%",
                      values: data?.performance??0
                  ),

                ),
              ],
            ),
          ),
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: data?.status == 0
                  ? ThemeColors.success120
                  : ThemeColors.error120,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
      });
  }

  Widget _richPrices({String? label, String? value}) {
    if (value == null || value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: styleBaseRegular(
              fontSize: 14,
            ),
            children: [
          TextSpan(
            text: value,
            style: styleBaseBold(
              fontSize: 14,
            ),
          )
        ]));
  }

  Widget _richPrices1({String? label, String? value, num? values}) {
    if (value == null || value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: styleBaseRegular(
              fontSize: 14,
            ),
            children: [
          TextSpan(
            text: value,
            style: styleBaseBold(
                fontSize: 14,
                color: (values ?? 0) > 0
                    ? ThemeColors.success120
                    : (values ?? 0) == 0
                        ? ThemeColors.black
                        : ThemeColors.error120),
          )
        ]));
  }
}
