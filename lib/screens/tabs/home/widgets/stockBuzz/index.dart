import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/index.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StockInBuzz extends StatelessWidget {
  const StockInBuzz({super.key});

  @override
  Widget build(BuildContext context) {
    List<Top>? popular = context.watch<HomeProvider>().homeTrendingRes?.popular;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const ScreenTitle(
            //   title: "Stock In Buzz",
            //   // subTitle: "Dynamic description for Stocks in Buss.",
            // ),

            // const SpacerVertical(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Popular Stocks",
                    style: stylePTSansBold(),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MoreStocks(
                          type: StocksType.actives,
                        ),
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
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SpacerVertical(height: 10),

            SizedBox(
              height: 100,
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return StockBuzzItem(
                      symbol: popular?[index].symbol ?? "",
                      up: (popular?[index].changesPercentage ?? -1) > 0,
                      image: popular?[index].image ?? "",
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SpacerHorizontal(width: 15);
                  },
                  itemCount: 10),
            ),
          ],
        );
      },
    );
  }
}

class StockBuzzItem extends StatelessWidget {
  final String image;
  final bool up;
  final String symbol;
  const StockBuzzItem(
      {super.key, required this.image, required this.up, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.topCenter,
      fit: BoxFit.scaleDown,
      child: Stack(
        children: [
          // CircleAvatar(
          //   backgroundColor: ThemeColors.white,
          //   radius: 30.sp,

          // ),

          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  StockDetails.path,
                  // arguments: symbol,
                  arguments: {"slug": symbol},
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: ThemeColors.white),
                  // color: ThemeColors.greyBorder,
                ),
                child: CachedNetworkImagesWidget(
                  image,
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: ClipOval(
              // radius: 8.sp,
              child: Container(
                color: up ? ThemeColors.accent : ThemeColors.sos,
                child: Icon(
                  up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
