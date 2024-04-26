import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/moreStocks/more_stoks_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

class MoreStocksContainer extends StatefulWidget {
  final StocksType type;
  const MoreStocksContainer({required this.type, super.key});

  @override
  State<MoreStocksContainer> createState() => _MoreStocksContainerState();
}

class _MoreStocksContainerState extends State<MoreStocksContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<MoreStocksProvider>()
          .getData(showProgress: true, type: widget.type.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    MoreStocksProvider provider = context.watch<MoreStocksProvider>();
    return BaseContainer(
      drawer: const BaseDrawer(),
      appbar: const AppBarHome(isPopback: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          Dimen.padding.sp,
          Dimen.padding.sp,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenTitle(
                title: widget.type == StocksType.trending
                    ? "Trending"
                    : widget.type == StocksType.gainers
                        ? "Top Gainers"
                        : "Top Losers"),
            Expanded(
              child: BaseUiContainer(
                isLoading: provider.isLoading,
                hasData: provider.data != null && provider.data!.isNotEmpty,
                error: provider.error,
                errorDispCommon: true,
                onRefresh: () => provider.getData(
                    showProgress: true, type: widget.type.name),
                child: RefreshIndicator(
                    onRefresh: () async {
                      provider.getData(
                          showProgress: true, type: widget.type.name);
                    },
                    child: const MoreStocksList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
