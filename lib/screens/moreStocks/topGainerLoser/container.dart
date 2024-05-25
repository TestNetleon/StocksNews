import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer_copy.dart';

import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../utils/colors.dart';
import '../../drawer/base_drawer.dart';
import 'item.dart';

//
class GainerLoserContainer extends StatefulWidget {
  final StocksType type;

  const GainerLoserContainer({super.key, required this.type});

  @override
  State<GainerLoserContainer> createState() => _GainerLoserContainerState();
}

class _GainerLoserContainerState extends State<GainerLoserContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<MoreStocksProvider>()
          .getGainersLosers(showProgress: true, type: widget.type.name);

      String title = widget.type == StocksType.gainers
          ? "Today’s Top Gainers"
          : widget.type == StocksType.losers
              ? "Today’s Top Losers"
              : "Popular Stocks";

      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': title},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    MoreStocksProvider provider = context.watch<MoreStocksProvider>();
    List<GainersLosersDataRes>? data = provider.gainersLosers?.data;

    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: Column(
          children: [
            ScreenTitle(
              title: widget.type == StocksType.gainers
                  ? "Today’s Top Gainers"
                  : widget.type == StocksType.losers
                      ? "Today’s Top Losers"
                      : data?.length == 1
                          ? "Popular Stock"
                          : "Popular Stocks",
            ),
            Expanded(
              child: BaseUiContainer(
                error: provider.error,
                hasData: data != null && data.isNotEmpty,
                isLoading: provider.isLoading,
                errorDispCommon: true,
                onRefresh: () => provider.getGainersLosers(
                    showProgress: true, type: widget.type.name),
                child: RefreshControl(
                  onRefresh: () async => provider.getGainersLosers(
                      showProgress: true, type: widget.type.name),
                  canLoadMore: provider.canLoadMore,
                  onLoadMore: () async => provider.getGainersLosers(
                      loadMore: true, type: widget.type.name),
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: Dimen.padding.sp),
                    itemBuilder: (context, index) {
                      if (data == null || data.isEmpty) {
                        return const SizedBox();
                      }
                      return GainerLoserItem(
                        data: data[index],
                        index: index,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: ThemeColors.greyBorder,
                        height: 12.sp,
                      );
                    },
                    itemCount: data?.length ?? 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
