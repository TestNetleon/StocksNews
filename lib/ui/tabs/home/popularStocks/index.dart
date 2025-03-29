import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/tabs/home/viewMore/PopularMostBought/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HomePopularStocks extends StatelessWidget {
  const HomePopularStocks({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomeManager>(
      builder: (context, value, child) {
        HomePopularRes? popular = value.data?.popular;
        if (popular == null) return SizedBox();
        return Container(
          margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacerVertical(height: Pad.pad20),
              BaseHeading(
                title: popular.title ?? '',
                titleStyle: styleBaseBold(fontSize: 22),
                viewMore: () {
                  Navigator.pushNamed(
                    context,
                    HomeViewMoreTickersIndex.path,
                    arguments: {'apiUrl': Apis.myHomePopular},
                  );
                },
                viewMoreText: 'View All',
              ),
              SpacerVertical(height: Pad.pad14),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    popular.data?.length ?? 0,
                    (index) {
                      BaseTickerRes? ticker = popular.data?[index];
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, SDIndex.path,
                                  arguments: {
                                    'symbol': ticker?.symbol,
                                  });
                            },
                            child: Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: ThemeColors.neutral20),
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              margin: EdgeInsets.only(right: 20),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ThemeColors.neutral5,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child:
                                      CachedNetworkImagesWidget(ticker?.image),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 15,
                            child: Container(
                              decoration: BoxDecoration(
                                color: (ticker?.changesPercentage ?? 0) >= 0
                                    ? ThemeColors.accent
                                    : ThemeColors.sos,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                (ticker?.changesPercentage ?? 0) >= 0
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
