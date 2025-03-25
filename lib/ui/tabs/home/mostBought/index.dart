import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/models/watchlist_res.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/tabs/home/trendingWatchlist/item.dart';
import 'package:stocks_news_new/ui/tabs/home/viewMore/PopularMostBought/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';

class HomeMostBoughtIndex extends StatelessWidget {
  const HomeMostBoughtIndex({super.key});

  @override
  Widget build(BuildContext context) {
    MyHomeManager manager = context.watch<MyHomeManager>();
    WatchRes? mostBought = manager.homePremiumData?.mostBought;
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BaseHeading(
            title: manager.homePremiumData?.mostBought?.title,
            margin: EdgeInsets.only(top: Pad.pad24, bottom: Pad.pad14),
            titleStyle: styleBaseBold(),
            viewMore: () {
              Navigator.pushNamed(
                context,
                HomeViewMoreTickersIndex.path,
                arguments: {'apiUrl': Apis.myHomeMostBought},
              );
            },
            viewMoreText: 'View All',
          ),
          CustomGridView(
            length: mostBought?.watches?.length ?? 0,
            paddingVertical: 0,
            paddingHorizontal: 0,
            itemSpace: 10,
            getChild: (index) {
              BaseTickerRes? data = mostBought?.watches?[index];
              if (data == null) {
                return SizedBox();
              }
              return TickerBoxItem(
                data: data,
                onTap: () {
                  Navigator.pushNamed(context, SDIndex.path, arguments: {
                    'symbol': data.symbol,
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
