import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    MoreStocksProvider provider = context.watch<MoreStocksProvider>();
    List<GainersLosersDataRes>? data = provider.gainersLosers?.data;
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appbar: const AppBarHome(
          isPopback: true, showTrailing: false, canSearch: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: Column(
          children: [
            ScreenTitle(
                title: widget.type == StocksType.gainers
                    ? "Today’s Top Gainers"
                    : "Today’s Top Losers"),
            Expanded(
              child: BaseUiContainer(
                error: provider.error,
                hasData: data != null && data.isNotEmpty,
                isLoading: provider.isLoading,
                errorDispCommon: true,
                onRefresh: () => provider.getGainersLosers(
                    showProgress: true, type: widget.type.name),
                child: RefreshControll(
                  onRefresh: () => provider.getGainersLosers(
                      showProgress: true, type: widget.type.name),
                  canLoadmore: provider.canLoadMore,
                  onLoadMore: () => provider.getGainersLosers(
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
                      return const SpacerVerticel(height: 14);
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
