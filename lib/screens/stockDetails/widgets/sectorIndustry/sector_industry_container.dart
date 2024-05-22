import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/sector_industry_res.dart';
import 'package:stocks_news_new/providers/sector_industry_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/sectorIndustry/sector_industry_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

import 'graph/graph.dart';

class SectorIndustryList extends StatelessWidget {
  final StockStates stockStates;
  final String name;
  const SectorIndustryList(
      {required this.stockStates, super.key, required this.name});
//
  @override
  Widget build(BuildContext context) {
    SectorIndustryProvider provider = context.watch<SectorIndustryProvider>();

    return RefreshControl(
      onRefresh: () => provider.getStateIndustry(
          name: name, stockStates: stockStates, showProgress: true),
      canLoadMore: provider.canLoadMore,
      onLoadMore: () => provider.getStateIndustry(
          name: name, stockStates: stockStates, loadMore: true),
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: Dimen.padding.sp),
        itemCount: provider.data?.data.length ?? 0,
        itemBuilder: (context, index) {
          SectorIndustryData? data = provider.data?.data[index];

          if (index == 0 && stockStates == StockStates.sector) {
            return Column(
              children: [
                const SectorGraph(),
                SectorIndustryItem(
                  index: index,
                  data: data,
                ),
              ],
            );
          }

          return SectorIndustryItem(index: index, data: data);
        },
        separatorBuilder: (context, index) {
          // return const SpacerVertical(height: 20);
          return Divider(
            color: ThemeColors.greyBorder,
            height: 12.sp,
          );
        },
      ),
    );
  }
}
