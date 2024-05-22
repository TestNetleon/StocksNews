import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/providers/high_low_pe.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import '../../moreStocks/topGainerLoser/item.dart';

class HighPeStocks extends StatefulWidget {
  const HighPeStocks({super.key});

  @override
  State<HighPeStocks> createState() => _HighPeStocksState();
}

class _HighPeStocksState extends State<HighPeStocks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<HighLowPeProvider>()
          .getData(showProgress: true, type: "high");
    });
  }

  @override
  Widget build(BuildContext context) {
    HighLowPeProvider provider = context.watch<HighLowPeProvider>();
    List<HighLowPeDataRes>? high = provider.data?.data;

    return BaseUiContainer(
      error: provider.error,
      // hasData: up != null && up.isNotEmpty,
      hasData: true,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getData(showProgress: true, type: "high"),
      child: RefreshControl(
        onRefresh: () => provider.getData(showProgress: true, type: "high"),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () =>
            provider.getData(showProgress: false, type: "high", loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(
            bottom: Dimen.padding.sp,
            top: Dimen.padding.sp,
          ),
          itemBuilder: (context, index) {
            HighLowPeDataRes? high = provider.data?.data?[index];

            // if (up == null || up.isEmpty) {
            //   return const SizedBox();
            // }
            // return GainerLoserItem(
            //   data: up[index],
            //   index: index,
            // );
            return GainerLoserItem(
              data: GainersLosersDataRes(
                symbol: high?.symbol ?? "",
                name: high?.name ?? "",
                avgVolume: "${high?.avgVolume ?? "N/A"}",
                changesPercentage: high?.changesPercentage,
                previousClose: "${high?.previousClose ?? "N/A"}",
                price: high?.price ?? "N/A",
                range: "${high?.range ?? "N/A"}",
                volume: "${high?.volume ?? "N/A"}",
                image: high?.image,
              ),
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
          itemCount: high?.length ?? 0,
        ),
      ),
    );
  }
}
