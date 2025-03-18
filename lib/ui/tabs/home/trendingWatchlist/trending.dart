import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';

import '../../../../managers/home.dart';
import '../../../../models/ticker.dart';
import 'item.dart';

class HomeTrendingContainer extends StatelessWidget {
  const HomeTrendingContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyHomeManager provider = context.watch<MyHomeManager>();
    List<BaseTickerRes>? trending = provider.data?.tickers;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicHeight(
        child: Row(
          children: List.generate(
            trending?.length ?? 0,
            (index) {
              BaseTickerRes? data = trending?[index];

              if (data == null) {
                return SizedBox();
              }
              return Container(
                width: 180.sp,
                margin: const EdgeInsets.only(right: 16),
                child: TickerBoxItem(data: data,onTap: (){
                  Navigator.pushNamed(context, SDIndex.path, arguments: {
                    'symbol': data.symbol,
                  });
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
