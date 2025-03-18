import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../../../../widgets/spacer_vertical.dart';

class ScannerBaseItem extends StatelessWidget {
  final OfflineScannerRes? data;
  const ScannerBaseItem({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    String dollarVolume =
        num.parse("${(data?.volume ?? 0) * (data?.price ?? 0)}").toUSDFormat();

    String volume =
        num.parse("${(data?.volume ?? 0)}").toUSDFormat(showDollar: false);

    bool preMarket = data?.ext?.extendedHoursType == "PreMarket";
    bool postMarket = data?.ext?.extendedHoursType == "PostMarket";

    String? prePost = postMarket
        ? 'Post Mkt. Price'
        : preMarket
            ? 'Pre Mkt. Price'
            : null;

    num lastTrade = data?.price ?? 0;
    num netChange = data?.change ?? 0;
    num perChange = data?.changesPercentage ?? 0;

    num? postMarketPrice = data?.ext?.extendedHoursPrice ?? 0;
    num? postMarketChange = data?.ext?.extendedHoursChange ?? 0;
    num? postMarketChangePer = data?.ext?.extendedHoursPercentChange ?? 0;

    if ((preMarket || postMarket)) {
      dollarVolume = num.parse(
              "${(data?.volume ?? 0) * (data?.ext?.extendedHoursPrice ?? 0)}")
          .toUSDFormat();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: InkWell(
        // onTap: () {
        //   if (data?.identifier == null || data?.identifier == '') {
        //     return;
        //   }
        //   showModalBottomSheet(
        //     enableDrag: true,
        //     isDismissible: true,
        //     context: context,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(10),
        //         topRight: Radius.circular(10),
        //       ),
        //     ),
        //     isScrollControlled: true,
        //     builder: (context) {
        //       return ActionInNewsBlog(
        //           symbol: data?.identifier ?? '',
        //           item: NewsTicker(
        //             id: data?.bid.toString(),
        //             symbol: data?.identifier ?? '',
        //             name: data?.name ?? '',
        //             image: data?.image ?? '',
        //           ));
        //     },
        //   );
        // },
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: data?.image != null && data?.image != '',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Pad.pad5),
                        child: Container(
                          padding: EdgeInsets.all(3.sp),
                          color: ThemeColors.neutral5,
                          child: CachedNetworkImagesWidget(
                            data?.image,
                            height: 41,
                            width: 41,
                          ),
                        ),
                      ),
                    ),
                    const SpacerHorizontal(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: data?.identifier != null &&
                                data?.identifier != '',
                            child: Text(
                              data?.identifier ?? '',
                              // style: styleBaseBold(fontSize: 16),
                              style: Theme.of(context).textTheme.displayLarge,

                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SpacerVertical(height: 3),
                          Visibility(
                            visible: data?.name != null && data?.name != '',
                            child: Text(
                              data?.name ?? '',
                              style: styleBaseRegular(
                                color: ThemeColors.neutral40,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Visibility(
                            visible: data?.sector != null && data?.sector != '',
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Sector: ',
                                  style: styleBaseSemiBold(
                                    fontSize: 13,
                                    color: ThemeColors.neutral40,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: data?.sector ?? '-',
                                      style: styleBaseRegular(
                                        fontSize: 13,
                                        color: ThemeColors.neutral40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SpacerHorizontal(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          lastTrade.toFormattedPrice(),
                          // style: styleBaseBold(fontSize: 16),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Visibility(
                          // visible: (preMarket || postMarket),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: netChange == 0
                                      ? "\$$netChange"
                                      : "\$$netChange ($perChange%)",
                                  style: styleBaseSemiBold(
                                    fontSize: 13,
                                    height: 0.0,
                                    color: perChange > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: preMarket || postMarket,
                          child: Consumer<ThemeManager>(
                              builder: (context, value, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: ThemeColors.neutral5,
                              ),
                              margin: const EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              child: Text(
                                'Last Trade',
                                style: styleBaseSemiBold(
                                  fontSize: 13,
                                  color: value.isDarkMode
                                      ? ThemeColors.white
                                      : ThemeColors.neutral40,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    )
                  ],
                ),
                Visibility(
                  // visible: showPreMarket,
                  visible: prePost != null && prePost != '',
                  child: Column(
                    children: [
                      BaseListDivider(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Visibility(
                              visible: postMarketPrice != null,
                              child: _widget(
                                fontSize: 14,
                                label: prePost != null
                                    ? '$prePost: '
                                    : 'Post Mkt. Price: ',
                                value: '\$$postMarketPrice',
                              ),
                            ),
                          ),
                          const SpacerHorizontal(width: 5),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: postMarketChange == 0
                                        ? "\$$postMarketChange"
                                        : "\$$postMarketChange ($postMarketChangePer%)",
                                    style: styleBaseSemiBold(
                                      fontSize: 13,
                                      color: (postMarketChangePer ?? 0) > 0
                                          ? Colors.green
                                          : Colors.red,
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
                BaseListDivider(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Visibility(
                        visible: volume != '',
                        child: _widget(
                          label: 'Vol.: ',
                          value: volume,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Visibility(
                        visible: dollarVolume != '',
                        child: _widget(
                          textAlign: TextAlign.end,
                          label: '\$Vol.: ',
                          fontSize: 14,
                          value: dollarVolume,
                        ),
                      ),
                    ),
                  ],
                ),
                SpacerVertical(height: 8),
              ],
            ),
            Consumer<ThemeManager>(builder: (context, value, child) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color:
                      // value.isDarkMode
                      //     ? ThemeColors.neutral80
                      //     :
                      ThemeColors.neutral5,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Visibility(
                        visible: data?.bid != null,
                        child: _widget(
                          color: value.isDarkMode ? ThemeColors.neutral8 : null,
                          valueColor: value.isDarkMode
                              ? ThemeColors.white
                              : ThemeColors.black,
                          isBOLD: true,
                          label: 'Bid: ',
                          value: '\$${data?.bid}',
                        ),
                      ),
                    ),
                    Flexible(
                      child: Visibility(
                        visible: data?.ask != null,
                        child: _widget(
                          color: value.isDarkMode ? ThemeColors.neutral8 : null,
                          valueColor: value.isDarkMode
                              ? ThemeColors.white
                              : ThemeColors.black,
                          isBOLD: true,
                          label: 'Ask: ',
                          value: '\$${data?.ask}',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _widget({
    required String label,
    bool isBOLD = false,
    String? value,
    double fontSize = 13,
    TextAlign textAlign = TextAlign.start,
    Color? color,
    Color? valueColor,
  }) {
    if (value == null || value == '') {
      return SizedBox();
    }
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        text: label,
        style: isBOLD
            ? styleBaseSemiBold(
                fontSize: fontSize,
                color: color ?? ThemeColors.neutral80,
              )
            : styleBaseRegular(
                fontSize: fontSize,
                color: color ?? ThemeColors.neutral80,
              ),
        children: [
          TextSpan(
              text: value,
              style: isBOLD
                  ? styleBaseBold(
                      fontSize: fontSize,
                      color: valueColor ?? ThemeColors.neutral80,
                    )
                  // Theme.of(navigatorKey.currentContext!)
                  //     .textTheme
                  //     .displayLarge
                  //     ?.copyWith(fontSize: fontSize)
                  : styleBaseSemiBold(
                      fontSize: fontSize,
                      color: valueColor ?? ThemeColors.neutral80,
                    )
              // Theme.of(navigatorKey.currentContext!)
              //     .textTheme
              //     .displayMedium
              //     ?.copyWith(fontSize: fontSize),
              )
        ],
      ),
    );
  }
}
