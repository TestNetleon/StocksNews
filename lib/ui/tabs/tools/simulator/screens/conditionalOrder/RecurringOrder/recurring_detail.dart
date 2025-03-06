import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_recurring.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_recurring_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_recurring_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/RecurringOrder/widget/transaction_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class RecurringDetail extends StatefulWidget {
  final TsRecurringListRes? item;
  const RecurringDetail(this.item,{super.key});

  @override
  State<RecurringDetail> createState() => _RecurringDetailState();
}

class _RecurringDetailState extends State<RecurringDetail> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    SRecurringManager manager = context.read<SRecurringManager>();
    manager.getRecurringDetail("${widget.item?.id}");
  }

  @override
  Widget build(BuildContext context) {
    SRecurringManager manager = context.watch<SRecurringManager>();
    return BaseLoaderContainer(
      hasData: manager.detailData != null,
      isLoading: manager.isDetailLoading,
      error: manager.error,
      showPreparingText: true,
      onRefresh: _callAPI,
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(38),
                child: Container(
                  padding: const EdgeInsets.all(5),
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
                      '${manager.detailData?.tradeInfo?.symbol}',
                      style: styleGeorgiaBold(
                          color: ThemeColors.splashBG, fontSize: 16),
                    ),
                    Text(
                      '${manager.detailData?.tradeInfo?.company}',
                      style: styleGeorgiaRegular(
                          color: ThemeColors.neutral40, fontSize: 14),
                    ),
                    Text(
                      '${manager.detailData?.tradeInfo?.frequencyString}',
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
                    visible: manager.detailData?.tradeInfo?.recurringAmount != null,
                    child: Text(
                      '${manager.detailData?.tradeInfo?.recurringAmount?.toFormattedPrice()}',
                      style: styleGeorgiaBold(
                          color: ThemeColors.splashBG, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SpacerVertical(height: Pad.pad10),
          Visibility(
            visible: manager.detailData?.settlement != null,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: manager.detailData?.settlement?.totalQuantity != null,
                      child: Expanded(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Quantity",
                              style: stylePTSansRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: Pad.pad3),
                            Text(
                              "${manager.detailData?.settlement?.totalQuantity ?? ""}",
                              style: stylePTSansBold(
                                  color: ThemeColors.neutral40, fontSize: 12)
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible:manager.detailData?.settlement?.avgPurchasePrice != null,
                      child: Expanded(
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Avg Purchase Price",
                                style: stylePTSansRegular(
                                  color: ThemeColors.splashBG,
                                  fontSize: 12,
                                ),
                              ),
                              const SpacerVertical(height: Pad.pad3),
                              Text(
                                manager.detailData?.settlement?.avgPurchasePrice?.toFormattedPrice() ?? "0",
                                style: stylePTSansRegular(
                                  color: ThemeColors.neutral40,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    Visibility(
                      visible: manager.detailData?.settlement?.totalInvestedValue != null,
                      child: Expanded(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Total Invested Value",
                              style: stylePTSansRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: Pad.pad3),
                            Text(
                              "${manager.detailData?.settlement?.totalInvestedValue ?? ""}",
                              style: stylePTSansRegular(
                                color: ThemeColors.neutral40,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                SpacerVertical(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible:  manager.detailData?.settlement?.salePrice != null,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sale Price",
                              style: stylePTSansRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: Pad.pad3),
                            Text(
                              manager.detailData?.settlement?.salePrice?.toFormattedPrice() ?? "0",
                              style: stylePTSansRegular(
                                color: ThemeColors.neutral40,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible:  manager.detailData?.settlement?.totalSettlementValue != null,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Settlement Amount",
                              style: stylePTSansRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: Pad.pad3),
                            Text(
                              manager.detailData?.settlement?.totalSettlementValue?.toFormattedPrice() ?? "0",
                              style: stylePTSansRegular(
                                color: ThemeColors.neutral40,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible:  manager.detailData?.settlement?.settlementDate != null,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Settlement Date",
                              style: stylePTSansRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: Pad.pad3),
                            Text(
                              manager.detailData?.settlement?.settlementDate?? "0",
                              style: stylePTSansRegular(
                                color: ThemeColors.neutral40,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: ThemeColors.neutral5,
            thickness: 1,
            height: 20,
          ),
          SpacerVertical(height:Pad.pad10),
          ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 0),
            itemBuilder: (context, index) {
              Transaction? data = manager.detailData?.transactions?[index];
              if (data == null) {
                return SizedBox();
              }
              return TransactionItem(
                data: data,
              );
            },
            itemCount:manager.detailData?.transactions?.length ?? 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(
            ),
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
          ),
        ],
      ),
    );
  }
}
