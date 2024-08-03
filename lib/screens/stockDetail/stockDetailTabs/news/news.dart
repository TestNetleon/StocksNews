import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_news.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/news/gauge.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/news/news_item.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

// class SdNews extends StatefulWidget {
//   final String? symbol;
//   const SdNews({super.key, this.symbol});

//   @override
//   State<SdNews> createState() => _SdNewsState();
// }

// class _SdNewsState extends State<SdNews> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
//       if (provider.newsRes == null) {
//         _callApi();
//       }
//     });
//   }

//   _callApi() {
//     context.read<StockDetailProviderNew>().getNewsData(symbol: widget.symbol);
//   }

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
//     return BaseUiContainer(
//       isFull: true,
//       hasData: !provider.isLoadingNews && provider.newsRes != null,
//       isLoading: provider.isLoadingNews,
//       showPreparingText: true,
//       error: provider.errorNews,
//       onRefresh: _callApi,
//       child: CommonRefreshIndicator(
//         onRefresh: () async {
//           _callApi();
//         },
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(
//                 Dimen.padding, Dimen.padding, Dimen.padding, 0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SdCommonHeading(),
//                 ScreenTitle(
//                   subTitle: "${provider.newsRes?.newsText}",
//                 ),
//                 const SDNewsGauge(),
//                 ListView.separated(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     TopPost? data = provider.newsRes?.topPosts[index];
//                     if (data == null) {
//                       return const SizedBox();
//                     }
//                     if (index == 0) {
//                       return SdNewsItemSeparated(
//                         news: data,
//                       );
//                     }
//                     return SdNewsItem(
//                       news: data,
//                     );
//                   },
//                   separatorBuilder: (BuildContext context, int index) {
//                     return Divider(
//                       color: ThemeColors.greyBorder,
//                       height: 20.sp,
//                     );
//                   },
//                   itemCount: provider.newsRes?.topPosts.length ?? 0,
//                 ),
//                 if (provider.extra?.disclaimer != null)
//                   DisclaimerWidget(
//                     data: provider.extra!.disclaimer!,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class SdNewsN extends StatefulWidget {
  final String? symbol;
  const SdNewsN({super.key, this.symbol});

  @override
  State<SdNewsN> createState() => _SdNewsNState();
}

class _SdNewsNState extends State<SdNewsN> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
      if (provider.newsResN == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context.read<StockDetailProviderNew>().getNewsDataN(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingNewsN && provider.newsResN != null,
      isLoading: provider.isLoadingNewsN,
      showPreparingText: true,
      error: provider.errorNewsN,
      onRefresh: _callApi,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          _callApi();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SdCommonHeading(),
                ScreenTitle(
                  subTitle: "${provider.newsResN?.newsText}",
                ),
                SDNewsGauge(
                  symbol: widget.symbol,
                ),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    TopPost? data = provider.newsResN?.topPosts?[index];
                    if (data == null) {
                      return const SizedBox();
                    }
                    if (index == 0) {
                      return SdNewsItemSeparated(
                        news: data,
                      );
                    }
                    return SdNewsItem(
                      news: data,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 20.sp,
                    );
                  },
                  itemCount: provider.newsResN?.topPosts?.length ?? 0,
                ),
                if (provider.extra?.disclaimer != null)
                  DisclaimerWidget(
                    data: provider.extra!.disclaimer!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
