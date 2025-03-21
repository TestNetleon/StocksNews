import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/tabs/home/scanner/extra/action_in_nbs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import '../../../../models/ticker.dart';
import '../../home/trendingWatchlist/item.dart';

class TickersBoxIndex extends StatelessWidget {
  final List<BaseTickerRes>? tickers;
  final BaseLockInfoRes? simulatorLockInfoRes;
  const TickersBoxIndex({
    super.key,
    this.tickers,
    this.simulatorLockInfoRes,
  });

  @override
  Widget build(BuildContext context) {
    if (tickers == null || tickers?.isEmpty == true) {
      return SizedBox();
    }

    return Container(
      margin: EdgeInsets.only(top: 15),
      child: SingleChildScrollView(
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
                  child: TickerBoxItem(
                      data: data,
                      onTap: () {
                        BaseBottomSheet().bottomSheet(
                            barrierColor:
                                ThemeColors.neutral5.withValues(alpha: 0.7),
                            child: ActionInNbs(
                                symbol: data.symbol ?? '',
                                item: BaseTickerRes(
                                  id: data.id.toString(),
                                  symbol: data.symbol ?? '',
                                  name: data.name ?? '',
                                  image: data.image ?? '',
                                )));
                      }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
