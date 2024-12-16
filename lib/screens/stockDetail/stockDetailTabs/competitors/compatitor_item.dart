import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/stockDetailRes/competitor.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../index.dart';

class SdCompetitorItem extends StatelessWidget {
  final TickerList? data;
  final bool isOpen;
  final Function() onTap;

  const SdCompetitorItem({
    this.data,
    super.key,
    this.isOpen = false,
    required this.onTap,
  });

  void _onTap(context) {
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => StockDetail(symbol: data?.symbol),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
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
                      const SpacerHorizontal(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data?.symbol}",
                              style: stylePTSansBold(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SpacerVertical(height: 5),
                            Text(
                              "${data?.company}",
                              style: stylePTSansRegular(
                                color: ThemeColors.greyText,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (data?.rating != null && data?.rating != 0)
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                child: RatingBar.builder(
                                  initialRating: data?.rating / 1,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  itemSize: 16,
                                  unratedColor: ThemeColors.greyBorder,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: ThemeColors.accent,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SpacerHorizontal(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${data?.price}",
                            style: stylePTSansBold(fontSize: 14),
                          ),
                          const SpacerVertical(height: 2),
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     data.displayPercentage > 0
                          //         ? Icon(
                          //             Icons.arrow_upward,
                          //             size: 14,
                          //             color: data.displayPercentage > 0
                          //                 ? Colors.green
                          //                 : Colors.red,
                          //           )
                          //         : Icon(
                          //             Icons.arrow_downward_rounded,
                          //             size: 14,
                          //             color: data.displayPercentage > 0
                          //                 ? Colors.green
                          //                 : Colors.red,
                          //           ),
                          //     RichText(
                          //       text: TextSpan(
                          //         children: [
                          //           TextSpan(
                          //             text:
                          //                 "${data.displayChange} (${data.displayPercentage.toCurrency()}%)",
                          //             style: stylePTSansRegular(
                          //               fontSize: 11,
                          //               color: data.displayPercentage > 0
                          //                   ? Colors.green
                          //                   : Colors.red,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SpacerHorizontal(width: 10),
              InkWell(
                onTap: onTap,
                child: Container(
                  decoration: const BoxDecoration(
                    color: ThemeColors.accent,
                  ),
                  margin: EdgeInsets.only(left: 8.sp),
                  padding: const EdgeInsets.all(3),
                  child: Icon(
                    isOpen
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            child: Container(
              height: isOpen ? null : 0,
              margin: EdgeInsets.only(
                top: isOpen ? 10.sp : 0,
                bottom: isOpen ? 10.sp : 0,
              ),
              child: Column(
                children: [
                  InnerRowItem(
                    lable: "Market Cap",
                    value: "${data?.mktCap}",
                  ),
                  InnerRowItem(
                    lable: "PE Ratio",
                    value: "${data?.pe}",
                  ),
                  InnerRowItem(
                    lable: "Employee Count",
                    value: "${data?.fullTimeEmployees}",
                  ),
                  InnerRowItem(
                    lable: "Revenue",
                    value: "${data?.revenue}",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
