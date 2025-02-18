import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/ticker.dart';
import '../../home/trendingWatchlist/item.dart';

class TickersBoxIndex extends StatelessWidget {
  final List<BaseTickerRes>? tickers;
  const TickersBoxIndex({
    super.key,
    this.tickers,
  });

  @override
  Widget build(BuildContext context) {
    if (tickers == null || tickers?.isEmpty == true) {
      return SizedBox();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          children: List.generate(
            tickers?.length ?? 0,
            (index) {
              BaseTickerRes? data = tickers?[index];

              if (data == null) {
                return SizedBox();
              }
              return Container(
                width: 180.sp,
                margin: const EdgeInsets.only(right: 16),
                child: TickerBoxItem(data: data),
              );
            },
          ),
        ),
      ),
    );
  }
}
