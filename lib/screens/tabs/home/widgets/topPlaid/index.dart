import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../widgets/cache_network_image.dart';
import '../../../../../widgets/spacer_horizontal.dart';

class TopPlaidIndex extends StatelessWidget {
  const TopPlaidIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Most purchased by Stocks.News users",
          style: stylePTSansBold(),
        ),
        // CustomGridView(
        //   paddingHorizontal: 0,
        //   itemSpace: 8,
        //   paddingVerticle: 8,
        //   length: 4,
        //   getChild: (index) {
        //     return const TopPlaidItem();
        //   },
        // ),

        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              4,
              (index) {
                return TopPlaidItem();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class TopPlaidItem extends StatelessWidget {
  const TopPlaidItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {},
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
            // gradient: const LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color.fromARGB(255, 23, 23, 23),
            //     // ThemeColors.greyBorder,
            //     Color.fromARGB(255, 39, 39, 39),
            //   ],
            // ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ClipRRect(
                    child: SizedBox(
                      width: 43,
                      height: 43,
                      child: CachedNetworkImagesWidget(
                        "",
                        placeHolder: Images.placeholder,
                      ),
                    ),
                  ),
                  const SpacerHorizontal(width: 12),
                  Expanded(
                    child: Text(
                      // "data.symbol",
                      "SYMBOL",
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 8),
              Text(
                // "${data.name}",
                "company name",
                style: stylePTSansRegular(
                  color: ThemeColors.greyText,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SpacerVertical(height: 8),
              Text(
                // "${data.price}",
                "\$1.54",
                style: stylePTSansBold(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SpacerVertical(height: 5),
              Text(
                // "${data.displayChange} (${data.changesPercentage}%)",
                "1.33 (2.11%)",
                style: stylePTSansRegular(
                  fontSize: 12,
                  // color: data.changesPercentage > 0
                  //     ? ThemeColors.accent
                  //     : Colors.red,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
