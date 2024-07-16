import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/most_purchased.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/stockDetail/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../widgets/spacer_horizontal.dart';
import 'view_all.dart';

class TopPlaidIndex extends StatelessWidget {
  const TopPlaidIndex({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    if (provider.mostPurchased?.isEmpty == true ||
        provider.mostPurchased == null) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  provider.extraMostPopular?.title ??
                      "Most purchased by Stocks.News users ",
                  style: stylePTSansBold(),
                ),
              ),
              const SpacerHorizontal(width: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TopPlaidIndexView(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      "View All",
                      style: stylePTSansBold(fontSize: 12),
                    ),
                    const SpacerHorizontal(width: 5),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomGridView(
            paddingHorizontal: 0,
            itemSpace: 5,
            paddingVerticle: 5,
            length: 4,
            getChild: (index) {
              MostPurchasedRes? data = provider.mostPurchased?[index];
              if (data == null) {
                return const SizedBox();
              }
              return TopPlaidItem(data: data);
            },
          ),

          // SingleChildScrollView(
          //   physics: const BouncingScrollPhysics(),
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: List.generate(
          //       provider.mostPurchased?.length ?? 0,
          //       (index) {
          //         MostPurchasedRes? data = provider.mostPurchased?[index];
          //         if (data == null) {
          //           return const SizedBox();
          //         }
          //         return TopPlaidItem(data: data);
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class TopPlaidItem extends StatelessWidget {
  final MostPurchasedRes? data;
  const TopPlaidItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      // padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockDetail(symbol: data?.symbol ?? ""),
            ),
          );
        },
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            // color: Colors.transparent,
            border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 0.55],
              colors: [
                Color.fromARGB(255, 14, 41, 0),
                // ThemeColors.greyBorder,
                Color.fromARGB(255, 0, 0, 0),
              ],
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    child: SizedBox(
                      width: 43,
                      height: 43,
                      child: CachedNetworkImagesWidget(data?.image),
                    ),
                  ),
                  const SpacerHorizontal(width: 12),
                  Expanded(
                    child: Text(
                      data?.symbol ?? '',
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 8),
              Text(
                data?.name ?? '',
                style: stylePTSansRegular(
                  color: ThemeColors.greyText,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SpacerVertical(height: 8),
              Text(
                data?.price ?? '',
                style: stylePTSansBold(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SpacerVertical(height: 5),
              Text(
                "${data?.change ?? ""} (${data?.changesPercentage ?? ""}%)",
                style: stylePTSansRegular(
                  fontSize: 12,
                  color: (data?.changesPercentage ?? 0) > 0
                      ? ThemeColors.accent
                      : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
