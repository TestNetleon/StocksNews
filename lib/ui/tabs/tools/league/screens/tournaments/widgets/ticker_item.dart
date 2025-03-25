import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/tournament_user/widget/my_trades_sheet.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class TickerItem extends StatelessWidget {
  final BaseTickerRes? data;
  final int? fromTO;

  const TickerItem({super.key, this.data, this.fromTO});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap:data?.status==0?(){
          myTradeSheet(
              symbol:data?.symbol,
              data:data,
              fromTO:fromTO
          );
        }:null,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: Pad.pad10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Pad.pad2),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeColors.neutral5,
                        ),
                        child:  ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: CachedNetworkImagesWidget(
                              data?.image
                          ),
                        ),
                      ),
                      SpacerHorizontal(width: Pad.pad16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            '(${data?.price?.toFormattedPrice() ?? '\$0'})',
                                            style: styleBaseBold(
                                                fontSize: 14,
                                                color: (data?.price ?? 0) > 0
                                                    ? ThemeColors.accent
                                                    : (data?.price ?? 0) == 0
                                                    ? ThemeColors.black
                                                    : ThemeColors.sos
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: data?.type != null,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Pad.pad14,
                                          vertical: Pad.pad5,
                                        ),
                                        decoration: BoxDecoration(
                                            color:data?.type != "sell"
                                                ? ThemeColors.accent
                                                : ThemeColors.sos,

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
                                Text(
                                  data?.name ?? "",
                                  style: styleBaseRegular(
                                    fontSize: 12,
                                    color: ThemeColors.neutral40
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
              margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              padding: EdgeInsets.symmetric(horizontal: Pad.pad8, vertical: Pad.pad10),
              decoration: BoxDecoration(
                  color: ThemeColors.neutral5,
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
              margin: EdgeInsets.symmetric(horizontal: Pad.pad20),
              decoration: BoxDecoration(
                color: data?.status == 0
                    ? ThemeColors.accent
                    : ThemeColors.sos,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),
          ],
        ),
      );
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
                color: ThemeColors.black
            ),
            children: [
          TextSpan(
            text: value,
            style: styleBaseBold(
                fontSize: 14,
                color: (values ?? 0) > 0
                    ? ThemeColors.accent
                    : (values ?? 0) == 0
                        ? ThemeColors.black
                        : ThemeColors.sos),
          )
        ]));
  }
}
