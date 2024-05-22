import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/providers/gap_up_down_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import '../../moreStocks/topGainerLoser/item.dart';

class GapUpStocks extends StatefulWidget {
  const GapUpStocks({super.key});

  @override
  State<GapUpStocks> createState() => _GapUpStocksState();
}

class _GapUpStocksState extends State<GapUpStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<GapUpDownProvider>().getGapUpStocks(showProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    GapUpDownProvider provider = context.watch<GapUpDownProvider>();
    // List<GainersLosersDataRes>? up = provider.gainersLosers?.data;

    return BaseUiContainer(
      error: provider.error,
      // hasData: up != null && up.isNotEmpty,
      hasData: true,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getGapUpStocks(showProgress: true),
      child: RefreshControl(
        onRefresh: () => provider.getGapUpStocks(showProgress: true),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () => provider.getGapUpStocks(loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(
            bottom: Dimen.padding.sp,
            top: Dimen.padding.sp,
          ),
          itemBuilder: (context, index) {
            // if (up == null || up.isEmpty) {
            //   return const SizedBox();
            // }
            // return GainerLoserItem(
            //   data: up[index],
            //   index: index,
            // );
            return GainerLoserItem(
              data: GainersLosersDataRes(symbol: "Abc", name: "name"),
              index: index,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: ThemeColors.greyBorder,
              height: 20.sp,
            );
          },
          // itemCount: up?.length ?? 0,
          itemCount: 5,
        ),
      ),
    );
  }
}
