import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/congressional_res.dart';
import 'package:stocks_news_new/providers/high_low_pe.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/marketData/congressionDetail/index.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../stockDetail/index.dart';

class CongressionalItem extends StatelessWidget {
  final CongressionalRes? data;
  final int index;
  const CongressionalItem({super.key, this.data, required this.index});

  void _onTap(context) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => StockDetail(symbol: data?.symbol)),
    );
  }

  void _onPersonTap(context) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => CongressionalDetail(slug: data?.slug),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HighLowPeProvider provider = context.watch<HighLowPeProvider>();
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => _onPersonTap(context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0.sp),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ThemeColors.greyBorder,
                          width: 1,
                        ),
                      ),
                      width: 60,
                      height: 70,
                      child: ThemeImageView(
                        url: data?.userImage ?? "",
                        // fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 8),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _onPersonTap(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data?.name}",
                              style: stylePTSansBold(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (data?.memberType == 'house')
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                child: Text(
                                  "House - ${data?.office}",
                                  style: stylePTSansBold(
                                    fontSize: 14,
                                    color: ThemeColors.greyText,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SpacerVertical(height: 3),
                      InkWell(
                        onTap: () => _onTap(context),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0.sp),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: 43,
                                height: 43,
                                child: ThemeImageView(url: data?.image ?? ""),
                              ),
                            ),
                            const SpacerHorizontal(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data?.symbol}",
                                    style: stylePTSansBold(
                                      fontSize: 13,
                                      color: ThemeColors.accent,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SpacerVertical(height: 3),
                                  Text(
                                    "${data?.company}",
                                    style: stylePTSansBold(
                                        fontSize: 14,
                                        color: ThemeColors.greyText),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SpacerVertical(height: 3),
                      // Text(
                      //   "${data?.company}",
                      //   style: stylePTSansBold(
                      //       fontSize: 14, color: ThemeColors.greyText),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      const SpacerVertical(height: 3),
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data?.type ?? "",
                      style: stylePTSansBold(
                          fontSize: 14,
                          color: data?.type == "Purchase"
                              ? ThemeColors.accent
                              : ThemeColors.sos),
                    ),
                    const SpacerVertical(height: 5),
                    GestureDetector(
                      onTap: () {
                        provider.setOpenIndex(
                          provider.openIndex == index ? -1 : index,
                        );
                      },
                      child: Container(
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                          // color: data?.transactionType == "Buy"
                          //     ? ThemeColors.accent
                          //     : data?.transactionType == "Sell"
                          //         ? ThemeColors.sos
                          //         : ThemeColors.white,

                          color: ThemeColors.white,
                        ),
                        margin: EdgeInsets.only(left: 8.sp),
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          provider.openIndex == index
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: ThemeColors.background,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Text(
            //     "${data?.amount} Shares @ ${data?.currentPrice}",
            //     style: stylePTSansRegular(
            //       color: ThemeColors.greyText,
            //       fontSize: 12,
            //     ),
            //     maxLines: 2,
            //     textAlign: TextAlign.end,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: provider.openIndex == index ? null : 0,
            margin: EdgeInsets.only(
              top: provider.openIndex == index ? 10.sp : 0,
              bottom: provider.openIndex == index ? 10.sp : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  label: "Current Price ",
                  value: "${data!.currentPrice}",
                ),
                InnerRowItem(
                  label: "Trade Data",
                  value: "${data?.amount}",
                ),
                InnerRowItem(
                  label: "Date Filed",
                  value: "${data!.dateFiled}",
                ),
                InnerRowItem(
                  label: "Date Traded",
                  value: "${data?.dateTraded}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
