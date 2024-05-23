import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import '../../../modals/gainers_losers_res.dart';
import '../../../providers/more_stocks_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/base_ui_container.dart';
import '../../../widgets/refresh_controll.dart';
import '../../moreStocks/topGainerLoser/item.dart';

class GainersLosersIndex extends StatefulWidget {
  static const path = "GainersLosersIndex";
  final StocksType type;

  const GainersLosersIndex({super.key, required this.type});

  @override
  State<GainersLosersIndex> createState() => _GainersLosersIndexState();
}

class _GainersLosersIndexState extends State<GainersLosersIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<MoreStocksProvider>()
          .getGainersLosers(showProgress: true, type: widget.type.name);
      context
          .read<MoreStocksProvider>()
          .getLosers(showProgress: false, type: "losers");
    });
  }

  @override
  Widget build(BuildContext context) {
    MoreStocksProvider provider = context.watch<MoreStocksProvider>();
    List<GainersLosersDataRes>? gainers = provider.gainersLosers?.data;
    List<GainersLosersDataRes>? losers = provider.losers?.data;

    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            Dimen.padding, Dimen.padding, Dimen.padding, 0),
        child: CustomTabContainerNEW(
          scrollable: false,
          tabsPadding: EdgeInsets.zero,
          tabs: const ["Today's Gainers", " Today's Losers"],
          widgets: [
            BaseUiContainer(
              error: provider.error,
              hasData: gainers != null && gainers.isNotEmpty,
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
                  padding: EdgeInsets.only(
                      bottom: Dimen.padding.sp, top: Dimen.padding.sp),
                  itemBuilder: (context, index) {
                    if (gainers == null || gainers.isEmpty) {
                      return const SizedBox();
                    }
                    return GainerLoserItem(
                      data: gainers[index],
                      index: index,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 12.sp,
                    );
                  },
                  itemCount: gainers?.length ?? 0,
                ),
              ),
            ),
            BaseUiContainer(
              error: provider.errorLosers,
              hasData: losers != null && losers.isNotEmpty,
              isLoading: provider.isLoadingLosers,
              errorDispCommon: true,
              onRefresh: () =>
                  provider.getLosers(showProgress: true, type: "losers"),
              child: RefreshControl(
                onRefresh: () async =>
                    provider.getLosers(showProgress: true, type: "losers"),
                canLoadMore: provider.canLoadMoreLosers,
                onLoadMore: () async =>
                    provider.getLosers(loadMore: true, type: "losers"),
                child: ListView.separated(
                  padding: EdgeInsets.only(
                      bottom: Dimen.padding.sp, top: Dimen.padding.sp),
                  itemBuilder: (context, index) {
                    if (losers == null || losers.isEmpty) {
                      return const SizedBox();
                    }
                    return GainerLoserItem(
                      losers: true,
                      data: losers[index],
                      index: index,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 12.sp,
                    );
                  },
                  itemCount: losers?.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
