import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_screener_res.dart';
import 'package:stocks_news_new/providers/stock_screener_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/stockScreener/stock_screener_item.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class StockScreenerList extends StatefulWidget {
  const StockScreenerList({super.key});

  @override
  State<StockScreenerList> createState() => _StockScreenerListState();
}

class _StockScreenerListState extends State<StockScreenerList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<StockScreenerProvider>().getStockScreenerStocks();
    });
  }

  void _onFilterClick(BuildContext context, dynamic provider) {
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Insider Trades",
      child: MarketDataFilterBottomSheet(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    StockScreenerProvider provider = context.watch<StockScreenerProvider>();
    List<Result>? data = provider.data;

    return BaseUiContainer(
      error: provider.error,
      hasData: data != null && data.isNotEmpty,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getStockScreenerStocks(),
      child: RefreshControl(
        onRefresh: () async => provider.getStockScreenerStocks(),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getStockScreenerStocks(loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(
            bottom: Dimen.padding.sp,
          ),
          itemBuilder: (context, index) {
            if (data == null || data.isEmpty) {
              return const SizedBox();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: HtmlTitle(
                            subTitle: provider.extraUp?.subTitle ?? ""),
                      ),
                      InkWell(
                        onTap: () => _onFilterClick(context, provider),
                        child: const Icon(
                          Icons.filter_alt,
                          color: ThemeColors.accent,
                        ),
                      )
                    ],
                  ),
                StockScreenerItem(
                  data: data,
                  index: index,
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: ThemeColors.greyBorder,
              height: 20.sp,
            );
          },
          // itemCount: up?.length ?? 0,
          itemCount: data?.length ?? 0,
        ),
      ),
    );
  }
}
