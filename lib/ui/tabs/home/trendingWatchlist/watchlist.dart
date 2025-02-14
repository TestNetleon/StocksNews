import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../managers/home.dart';
import '../../../../models/ticker.dart';
import 'item.dart';

class HomeWatchlistContainer extends StatefulWidget {
  const HomeWatchlistContainer({
    super.key,
  });

  @override
  State<HomeWatchlistContainer> createState() => _HomeWatchlistContainerState();
}

class _HomeWatchlistContainerState extends State<HomeWatchlistContainer> {
  @override
  Widget build(BuildContext context) {
    MyHomeManager provider = context.watch<MyHomeManager>();
    List<BaseTickerRes>? watchlist = provider.watchlist?.data;

    return SingleChildScrollView(
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
                child: HomeTrendingWatchlistItem(data: data),
              );
            },
          ),
        ),
      ),
    );
  }
}
