import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/managers/market/alerts_watchlist_action.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/slidable_menu.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/optiona_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BaseStockItem extends StatelessWidget {
  final BaseTickerRes data;
  final int index;
  final bool slidable;
  final Function(BaseTickerRes)? onTap;
  const BaseStockItem({
    super.key,
    this.slidable = true,
    required this.data,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // MostBullishProvider provider = context.read<MostBullishProvider>();
    return OptionalParent(
      addParent: slidable,
      parentBuilder: (child) {
        return SlidableMenuWidget(
          alertForBearish: data.isAlertAdded ?? 0,
          watchlistForBullish: data.isWatchlistAdded ?? 0,
          onClickAlert: () {
            // provider.createAlertSend(
            //   alertName: data.symbol ?? "",
            //   symbol: data.symbol ?? "",
            //   companyName: data.name ?? "",
            //   index: index,
            // );
            AlertsWatchlistAction().createAlertSend(
              alertName: "",
              symbol: data.symbol ?? "",
              companyName: data.name ?? "",
              index: index,
              onSuccess: () {},
            );
          },
          onClickWatchlist: () {
            AlertsWatchlistAction().addToWishList(
              symbol: data.symbol ?? "",
              companyName: data.name ?? "",
              index: index,
              onSuccess: () {},
            );
          },
          index: index,
          child: child,
        );
      },
      child: InkWell(
        onTap: onTap != null
            ? () {
                onTap!(data);
              }
            : null,
        child: Container(
          padding: EdgeInsets.all(Pad.pad16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Pad.pad5),
                    child: Container(
                      padding: EdgeInsets.all(3.sp),
                      color: ThemeColors.neutral5,
                      child: CachedNetworkImagesWidget(
                        data.image,
                        height: 41,
                        width: 41,
                      ),
                    ),
                  ),
                  const SpacerHorizontal(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OptionalParent(
                          addParent: data.type != null && data.type != '',
                          parentBuilder: (child) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(child: child),
                                Container(
                                  margin: EdgeInsets.only(left: Pad.pad8),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ThemeColors.secondary10,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    data.type ?? '',
                                    style: styleBaseSemiBold(
                                      fontSize: 12,
                                      color: data.type == 'EQUITY'
                                          ? ThemeColors.success120
                                          : ThemeColors.secondary120,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          child: Text(
                            data.symbol ?? '',
                            style: styleBaseBold(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SpacerVertical(height: 2),
                        Text(
                          data.name ?? '',
                          style: styleBaseRegular(
                            fontSize: 14,
                            color: ThemeColors.neutral40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpacerHorizontal(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: data.price != null && data.price != '',
                        child: Text(
                          data.price ?? '',
                          style: styleBaseBold(fontSize: 16),
                        ),
                      ),
                      Visibility(
                        visible: data.mentionCount != null,
                        child: Text(
                          '${data.mentionCount}',
                          style: styleBaseBold(fontSize: 16),
                        ),
                      ),
                      Visibility(
                        visible: data.mentionDate != null,
                        child: Text(
                          data.mentionDate ?? '',
                          style: styleBaseRegular(
                            fontSize: 13,
                            color: ThemeColors.neutral40,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: data.change != null && data.change != '',
                        child: Container(
                          margin: EdgeInsets.only(top: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                data.change ?? '',
                                style: styleBaseSemiBold(
                                  fontSize: 13,
                                  color: (data.changesPercentage ?? 0) < 0
                                      ? ThemeColors.darkRed
                                      : ThemeColors.darkGreen,
                                ),
                              ),
                              const SpacerHorizontal(width: 5),
                              Visibility(
                                visible: data.changesPercentage != null,
                                child: Text(
                                  "(${data.changesPercentage ?? ''}%)",
                                  style: styleBaseSemiBold(
                                    fontSize: 13,
                                    color: num.parse(
                                                "${data.changesPercentage ?? 0}") <
                                            0
                                        ? ThemeColors.darkRed
                                        : ThemeColors.darkGreen,
                                  ),
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
              _bottomWidget(
                label: 'QTY',
                slug: data.quantity,
              ),
              _bottomWidget(
                label: 'Current Value(QTY X Close price)',
                slug: data.investmentValue,
              ),
              if (data.additionalInfo != null &&
                  data.additionalInfo?.isNotEmpty == true)
                Container(
                  margin: EdgeInsets.only(top: Pad.pad8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      data.additionalInfo?.length ?? 0,
                      (index) {
                        AdditionalInfoRes? info = data.additionalInfo?[index];
                        if (info == null) {
                          return SizedBox();
                        }
                        return Flexible(
                          child: Column(
                            children: [
                              Text(
                                info.title ?? '',
                                style: styleBaseRegular(),
                              ),
                              Text(
                                info.value ?? '',
                                style: styleBaseSemiBold(
                                  color: info.title == 'Bullish'
                                      ? ThemeColors.success120
                                      : info.title == 'Bearish'
                                          ? ThemeColors.error120
                                          : ThemeColors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomWidget({String? label, slug}) {
    if (label == null || label == '' || slug == null || slug == '') {
      return SizedBox();
    }
    return Container(
      padding: EdgeInsets.only(top: Pad.pad8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: styleBaseRegular(
                color: ThemeColors.neutral40,
                fontSize: 13,
              ),
            ),
          ),
          Flexible(
            child: Text(
              '$slug',
              style: styleBaseSemiBold(
                color: ThemeColors.black,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
