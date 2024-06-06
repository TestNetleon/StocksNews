import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/large_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/medium_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/mega_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/micro_cap.dart';
import 'package:stocks_news_new/screens/moreStocks/topTrending/widgets/marketCap/small_cap.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TrendingByMarketCap extends StatefulWidget {
  const TrendingByMarketCap({super.key});

  @override
  State<TrendingByMarketCap> createState() => _TrendingByMarketCapState();
}

class _TrendingByMarketCapState extends State<TrendingByMarketCap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopTrendingProvider>().getCapData();
    });
  }

  @override
  Widget build(BuildContext context) {
    TopTrendingProvider provider = context.watch<TopTrendingProvider>();
    // List<TopTrendingDataRes>? dataList =
    //     context.watch<TopTrendingProvider>().data;

    return RefreshControl(
      onRefresh: () async => provider.getCapData(),
      canLoadMore: false,
      onLoadMore: () async => {},
      child: provider.isLoading
          ? const Loading()
          : provider.data == null
              ? ErrorDisplayWidget(
                  error: provider.error,
                  onRefresh: () => provider.getCapData(),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    Dimen.padding,
                    Dimen.padding,
                    Dimen.padding,
                    0,
                  ),
                  child: Column(
                    children: [
                      const SpacerVertical(height: 10),
                      Visibility(
                        visible: !isEmpty(provider.textTop?.now),
                        child: Text(
                          provider.textTop?.now ?? "",
                          style: stylePTSansRegular(
                            fontSize: 13,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ),
                      const MegaCapListView(),
                      const LargeCapListView(),
                      const MediumCapListView(),
                      const SmallCapListView(),
                      const MicroCapListView(),
                      if (provider.extra?.disclaimer != null)
                        DisclaimerWidget(
                          data: provider.extra!.disclaimer!,
                        ),
                    ],
                  ),
                ),
    );
  }
}
