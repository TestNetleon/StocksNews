import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trading_search_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/searchTradingTicker/search_list.dart';
import 'package:stocks_news_new/tradingSimulator/widgets/text_input_field_search_common.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';

class SearchTradingTicker extends StatefulWidget {
  final bool buy;
  const SearchTradingTicker({super.key, this.buy = true});

  @override
  State<SearchTradingTicker> createState() => _SearchTradingTickerState();
}

class _SearchTradingTickerState extends State<SearchTradingTicker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDefaultSearchData();
    });
  }

  void getDefaultSearchData() {
    context.read<TradingSearchProvider>().getSearchDefaults();
  }

  @override
  void dispose() {
    // context.read<TradingSearchProvider>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TradingSearchProvider provider = context.watch<TradingSearchProvider>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        context.read<TradingSearchProvider>().clearSearch();
      },
      child: BaseContainer(
        appBar: const AppBarHome(
          isPopBack: true,
          canSearch: false,
          showTrailing: false,
          title: "Search Symbol",
        ),
        body: BaseUiContainer(
          hasData: provider.data?.isNotEmpty == true && provider.data != null,
          isLoading: provider.isLoading &&
              (provider.data?.isEmpty == true || provider.data == null),
          error: provider.error,
          errorDispCommon: true,
          onRefresh: () =>
              context.read<TradingSearchProvider>().getSearchDefaults(),
          showPreparingText: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimen.padding,
              0,
              Dimen.padding,
              0,
            ),
            child: CommonRefreshIndicator(
              onRefresh: () async {
                getDefaultSearchData();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TsTextInputFieldSearch(
                      hintText: "Search symbol or company name",
                      editable: true,
                      buy: widget.buy,
                    ),
                    SdTradeDefaultSearch(buy: widget.buy),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
