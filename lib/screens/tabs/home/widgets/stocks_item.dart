import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class StocksItem extends StatelessWidget {
  final bool gainer;
  final bool priceData;
  final Top top;
  const StocksItem(
      {required this.top,
      this.gainer = true,
      super.key,
      this.priceData = true});
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          StockDetails.path,
          // arguments: top.symbol,
          arguments: {"slug": top.symbol},
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0.sp),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 43,
              height: 43,
              // Replace 'app_logo.png' with your app logo image path
              child: ThemeImageView(url: top.image),
              //  Image.network(
              //   top.image,
              //   // Images.userPlaceholder,
              //   fit: BoxFit.cover,
              //   errorBuilder: (_, __, ___) {
              //     return Image.asset(Images.userPlaceholder, fit: BoxFit.cover);
              //   },
              // ),
            ),
          ),
          const SpacerHorizontal(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  top.symbol,
                  style: styleGeorgiaBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Text(
                  top.name,
                  style: styleGeorgiaRegular(
                    color: ThemeColors.greyText,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SpacerHorizontal(width: 10),
          Visibility(
            visible: priceData,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(top.price, style: stylePTSansBold(fontSize: 14)),
                const SpacerVertical(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "${top.displayChange} (${top.changesPercentage.toCurrency()}%)",
                        style: stylePTSansRegular(
                          fontSize: 11,
                          color: top.changesPercentage > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
