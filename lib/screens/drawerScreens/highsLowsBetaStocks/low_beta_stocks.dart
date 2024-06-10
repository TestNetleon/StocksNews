// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/high_low_beta_stocks_res.dart';
// import 'package:stocks_news_new/providers/high_low_beta_stocks_provider.dart';
// import 'package:stocks_news_new/screens/drawerScreens/highsLowsBetaStocks/item.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/widgets/html_title.dart';

// import '../../../utils/constants.dart';
// import '../../../widgets/base_ui_container.dart';
// import '../../../widgets/refresh_controll.dart';

// class LowBetaStocks extends StatefulWidget {
//   const LowBetaStocks({super.key});

//   @override
//   State<LowBetaStocks> createState() => _LowBetaStocksState();
// }

// class _LowBetaStocksState extends State<LowBetaStocks> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       if (context.read<HighLowBetaStocksProvider>().dataLowBetaStocks != null) {
//         return;
//       }
//       context
//           .read<HighLowBetaStocksProvider>()
//           .getHighLowNegativeBetaStocks(type: 2);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     HighLowBetaStocksProvider provider =
//         context.watch<HighLowBetaStocksProvider>();
//     List<HighLowBetaStocksRes>? data = provider.dataLowBetaStocks;

//     return BaseUiContainer(
//       error: provider.error,
//       hasData: data != null && data.isNotEmpty,
//       isLoading: provider.isLoading,
//       errorDispCommon: true,
//       showPreparingText: true,
//       onRefresh: () => provider.getHighLowNegativeBetaStocks(type: 2),
//       child: RefreshControl(
//         onRefresh: () async => provider.getHighLowNegativeBetaStocks(type: 2),
//         canLoadMore: provider.canLoadMore,
//         onLoadMore: () async =>
//             provider.getHighLowNegativeBetaStocks(loadMore: true, type: 2),
//         child: ListView.separated(
//           padding: EdgeInsets.only(
//             bottom: Dimen.padding.sp,
//             top: Dimen.padding.sp,
//           ),
//           itemBuilder: (context, index) {
//             if (data == null || data.isEmpty) {
//               return const SizedBox();
//             }
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (index == 0) HtmlTitle(subTitle: provider.extraUp?.subTitle),
//                 HighLowBetaStocksItem(
//                   data: data[index],
//                   index: index,
//                 ),
//               ],
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider(
//               color: ThemeColors.greyBorder,
//               height: 20.sp,
//             );
//           },
//           // itemCount: up?.length ?? 0,
//           itemCount: data?.length ?? 0,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/high_low_beta_stocks_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/low_beta_stocks_providers.dart';

import 'package:stocks_news_new/screens/drawerScreens/highsLowsBetaStocks/item.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/filter_ui_values.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';

class LowsBetaStocks extends StatefulWidget {
  const LowsBetaStocks({super.key});

  @override
  State<LowsBetaStocks> createState() => _LowsBetaStocksState();
}

class _LowsBetaStocksState extends State<LowsBetaStocks> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     if (context.read<LowsBetaStocksProvider>().data != null) {
  //       return;
  //     }
  //     context.read<LowsBetaStocksProvider>().getLowsBetaStocks(type: 1);
  //   });
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LowsBetaStocksProvider provider = context.read<LowsBetaStocksProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getLowsBetaStocks();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    LowsBetaStocksProvider gapProvider = context.read<LowsBetaStocksProvider>();
    if (provider.data == null) {
      await context.read<FilterProvider>().getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Stock Screener",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: gapProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<LowsBetaStocksProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    LowsBetaStocksProvider provider = context.watch<LowsBetaStocksProvider>();
    List<HighLowBetaStocksRes>? data = provider.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HtmlTitle(
          subTitle: provider.extraUp?.subTitle ?? "",
          onFilterClick: _onFilterClick,
        ),
        if (provider.filterParams != null)
          FilterUiValues(
            params: provider.filterParams,
            onDeleteExchange: (exchange) {
              provider.exchangeFilter(exchange);
            },
          ),
        Expanded(
          child: BaseUiContainer(
            error: provider.error,
            hasData: data != null && data.isNotEmpty,
            isLoading: provider.isLoading,
            errorDispCommon: true,
            showPreparingText: true,
            onRefresh: () => provider.getLowsBetaStocks(type: 1),
            child: RefreshControl(
              onRefresh: () async => provider.getLowsBetaStocks(type: 1),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async =>
                  provider.getLowsBetaStocks(loadMore: true, type: 1),
              child: ListView.separated(
                padding: EdgeInsets.only(
                  bottom: Dimen.padding.sp,
                  top: Dimen.padding.sp,
                ),
                itemBuilder: (context, index) {
                  if (data == null || data.isEmpty) {
                    return const SizedBox();
                  }
                  return HighLowBetaStocksItem(
                    data: data[index],
                    isOpen: provider.openIndex == index,
                    onTap: () {
                      provider.setOpenIndex(
                        provider.openIndex == index ? -1 : index,
                      );
                    },
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
          ),
        ),
      ],
    );
  }
}
