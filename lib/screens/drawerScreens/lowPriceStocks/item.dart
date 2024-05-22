import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/cache_network_image.dart';
import '../../../widgets/spacer_horizontal.dart';
import '../../../widgets/spacer_vertical.dart';

class LowPriceStocksItem extends StatelessWidget {
  const LowPriceStocksItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(
        //   context,
        //   StockDetails.path,
        //   arguments: {"slug": data?.symbol},
        // );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 43,
              height: 43,
              // child: ThemeImageView(
              //   url: "${data?.image}",
              // ),
              child: const CachedNetworkImagesWidget(
                "",
                placeHolder: Images.placeholder,
              ),
            ),
          ),
          const SpacerHorizontal(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "${data?.symbol}",
                  "SYMBOL",

                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Text(
                  "Company name",
                  style: stylePTSansRegular(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  // "${data?.price}",
                  "\$12.22",

                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Text(
                  // "${data?.formattedChange} (${data?.changesPercentage.toCurrency()}%)",
                  "\$1.22 (12%)",
                  style: stylePTSansRegular(
                    fontSize: 12,
                    // color: (data?.changesPercentage ?? 0) > 0
                    //     ? ThemeColors.accent
                    //     : Colors.red,
                    color: Colors.red,
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
