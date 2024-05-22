import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/providers/gap_up_down_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../moreStocks/topGainerLoser/item.dart';

class GapDownStocks extends StatefulWidget {
  static const path = "GapUpDownStocks";
  final StocksType? type;

  const GapDownStocks({super.key, this.type = StocksType.gapUp});

  @override
  State<GapDownStocks> createState() => _GapDownStocksState();
}

class _GapDownStocksState extends State<GapDownStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<GapUpDownProvider>().getGapDownStocks(showProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    GapUpDownProvider provider = context.watch<GapUpDownProvider>();
    // List<GainersLosersDataRes>? down = provider.losers?.data;
    return BaseUiContainer(
      error: provider.errorLosers,
      // hasData: down != null && down.isNotEmpty,
      hasData: true,
      isLoading: provider.isLoadingLosers,
      showPreparingText: true,
      errorDispCommon: true,
      onRefresh: () => provider.getGapDownStocks(showProgress: true),
      child: RefreshControl(
        onRefresh: () => provider.getGapDownStocks(showProgress: true),
        canLoadMore: provider.canLoadMoreLosers,
        onLoadMore: () => provider.getGapDownStocks(loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(
            bottom: Dimen.padding.sp,
            top: Dimen.padding.sp,
          ),
          itemBuilder: (context, index) {
            // if (down == null || down.isEmpty) {
            //   return const SizedBox();
            // }
            // return GainerLoserItem(
            //   losers: true,
            //   data: down[index],
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
          // itemCount: down?.length ?? 0,
          itemCount: 3,
        ),
      ),
    );
  }
}
