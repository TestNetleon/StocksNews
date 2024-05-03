import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_res.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class StocksItemTrending extends StatelessWidget {
  final HomeTrendingData trending;

  const StocksItemTrending({
    required this.trending,
    super.key,
  });
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          StockDetails.path,
          arguments: trending.symbol,
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0.sp),
            child: Container(
              padding: EdgeInsets.all(5.sp),
              width: 43.sp,
              height: 43.sp,
              child: ThemeImageView(url: trending.image),
            ),
          ),
          const SpacerHorizontal(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trending.symbol,
                  style: styleGeorgiaBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Text(
                  trending.name,
                  style: styleGeorgiaRegular(
                    color: ThemeColors.greyText,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 3),
                RichText(
                  text: TextSpan(
                    children: [
                      // TextSpan(
                      //   text: "Mentions: ${trending.sentiment.toInt()} (",
                      //   style: stylePTSansRegular(fontSize: 12),
                      // ),
                      TextSpan(
                        text: "Mentions: ${trending.sentiment.toInt()}",
                        style: stylePTSansRegular(fontSize: 12),
                      ),
                      // WidgetSpan(
                      //   child: Padding(
                      //     padding: EdgeInsets.zero,
                      //     child: trending.sentiment > trending.lastSentiment
                      //         ? Icon(
                      //             Icons.arrow_drop_up,
                      //             color: Colors.green,
                      //             size: 18.sp,
                      //           )
                      //         : Icon(
                      //             Icons.arrow_drop_down,
                      //             color: Colors.red,
                      //             size: 18.sp,
                      //           ),
                      //   ),
                      // ),
                      // TextSpan(
                      //   text: "${trending.rank})",
                      //   style: stylePTSansRegular(fontSize: 12),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SpacerHorizontal(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(trending.price, style: stylePTSansBold(fontSize: 14)),
              const SpacerVertical(height: 2),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "${trending.change > 0 ? '+\$' : '-\$'}${trending.change.toCurrency().replaceAll("-", "")}",
                      style: stylePTSansRegular(
                        fontSize: 12,
                        color: trending.change > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );

    // return InkWell(
    //   onTap: () {
    //     Navigator.pushNamed(context, StockDetails.path,
    //         arguments: trending.symbol);
    //   },
    //   child: Row(
    //     children: [
    //       ClipRRect(
    //         borderRadius: BorderRadius.circular(0.sp),
    //         child: Container(
    //           padding: EdgeInsets.all(5.sp),
    //           width: 43.sp,
    //           height: 43.sp,
    //           // Replace 'app_logo.png' with your app logo image path
    //           child: ThemeImageView(url: trending.image),
    //           // Image.network(
    //           //   trending.image,
    //           //   fit: BoxFit.cover,
    //           // ),
    //         ),
    //       ),
    //       const SpacerHorizontal(width: 12),
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               trending.symbol,
    //               style: styleGeorgiaBold(fontSize: 14),
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //             const SpacerVertical(height: 5),
    //             Text(
    //               trending.name,
    //               style: styleGeorgiaRegular(
    //                 color: ThemeColors.greyText,
    //                 fontSize: 12,
    //               ),
    //               maxLines: 2,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ],
    //         ),
    //       ),
    //       const SpacerHorizontal(width: 10),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           Text(trending.price, style: stylePTSansBold(fontSize: 14)),
    //           const SpacerVertical(height: 2),
    //           RichText(
    //             text: TextSpan(
    //               children: [
    //                 TextSpan(
    //                   text:
    //                       "${trending.change > 0 ? '+' : ''}${trending.change.toCurrency()}",
    //                   style: stylePTSansRegular(
    //                     fontSize: 12,
    //                     color: trending.change > 0 ? Colors.green : Colors.red,
    //                   ),
    //                 ),
    //                 TextSpan(
    //                   text: " ${trending.sentiment.toInt()} (",
    //                   style: stylePTSansRegular(fontSize: 12),
    //                 ),
    //                 WidgetSpan(
    //                   child: Padding(
    //                     padding: EdgeInsets.zero,
    //                     child: trending.sentiment > trending.lastSentiment
    //                         ? Icon(
    //                             Icons.arrow_drop_up,
    //                             color: Colors.green,
    //                             size: 18.sp,
    //                           )
    //                         : Icon(
    //                             Icons.arrow_drop_down,
    //                             color: Colors.red,
    //                             size: 18.sp,
    //                           ),
    //                   ),
    //                 ),
    //                 TextSpan(
    //                   text: "${trending.rank})",
    //                   style: stylePTSansRegular(fontSize: 12),
    //                 ),
    //               ],
    //             ),
    //           )
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }
}
