import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/more_stocks_res.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/more_stoks_list_item.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MoreStocksList extends StatelessWidget {
  const MoreStocksList({super.key});
//
  @override
  Widget build(BuildContext context) {
    MoreStocksProvider provider = context.watch<MoreStocksProvider>();

    return ListView.separated(
      itemCount: provider.data?.length ?? 0,
      // physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 16.sp),
      itemBuilder: (context, index) {
        MoreStocksRes data = provider.data![index];
        return MoreStocksListItem(data: data, index: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SpacerVertical(height: 12);
      },
    );
  }
}
