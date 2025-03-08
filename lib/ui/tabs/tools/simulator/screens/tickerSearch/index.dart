import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tickerSearch/search_ticker.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/input_field_search.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class SearchTickerIndex extends StatefulWidget {
  static const String path = "SearchTickerIndex";

  final StockType? selectedStock;
  const SearchTickerIndex({super.key, this.selectedStock});

  @override
  State<SearchTickerIndex> createState() => _SearchTickerIndexState();
}

class _SearchTickerIndexState extends State<SearchTickerIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDefaultSearchData();
    });
  }

  void getDefaultSearchData() {
    context.read<TickerSearchManager>().getRecentSearchData();
  }

  String _searchQuery = '';

  void _onSearchChanged(String query) async {
    setState(() {
      _searchQuery = query;
    });
    TickerSearchManager manager = context.read<TickerSearchManager>();
    await manager.getBaseSearchData(
      term: _searchQuery,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (kDebugMode) {
      print('Search deactivated');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TickerSearchManager manager =
          navigatorKey.currentContext!.read<TickerSearchManager>();
      manager.clearAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    TickerSearchManager manager = context.watch<TickerSearchManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        toolbarHeight: 70,
        searchFieldWidget:
            BaseSearchSimulator(onSearchChanged: _onSearchChanged),
        showBack: true,
      ),
      body: (manager.searchData == null && manager.errorSearch == null) &&
              !manager.isLoadingSearch
          ? BaseLoaderContainer(
              hasData: manager.recentSearchData != null,
              isLoading: manager.isLoadingRecentSearch,
              error: manager.errorRecentSearch,
              showPreparingText: true,
              child: SearchTicker(
                //stockClick: widget.stockClick,
                symbolRes: manager.recentSearchData?.symbols,
                onRefresh: manager.getRecentSearchData,
              ),
            )
          : SearchTicker(
              symbolRes: manager.searchData?.symbols,
              fromSearch: true,
              //stockClick: widget.stockClick,
            ),
    );
  }
}
