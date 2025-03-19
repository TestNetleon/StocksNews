import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../managers/home/home.dart';
import '../../../../models/ticker.dart';
import 'watchlist_item.dart';

class HomeWatchlistContainer extends StatefulWidget {
  const HomeWatchlistContainer({super.key});

  @override
  State<HomeWatchlistContainer> createState() => _HomeWatchlistContainerState();
}

class _HomeWatchlistContainerState extends State<HomeWatchlistContainer> {
  @override
  Widget build(BuildContext context) {
    MyHomeManager manager = context.watch<MyHomeManager>();
    List<BaseTickerRes>? watchlist =
        manager.homePremiumData?.watchList?.watches;
    if (manager.homePremiumData?.watchList == null) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: manager.homePremiumData?.watchList?.title,
          margin: EdgeInsets.only(top: Pad.pad24, bottom: Pad.pad14),
          titleStyle: styleBaseBold(fontSize: 20),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              children: List.generate(
                watchlist?.length ?? 0,
                (index) {
                  BaseTickerRes? data = watchlist?[index];

                  if (data == null) {
                    return SizedBox();
                  }
                  return Container(
                    width: 180.sp,
                    margin: const EdgeInsets.only(right: 16),
                    child: TickerBoxWatchListItem(
                        data: data,
                        onTap: () {
                          Navigator.pushNamed(context, SDIndex.path,
                              arguments: {
                                'symbol': data.symbol,
                              });
                        }),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
