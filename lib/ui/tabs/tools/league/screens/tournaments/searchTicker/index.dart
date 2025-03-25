import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/searchTicker/league_search_ticker.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/searchTicker/search_field.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class TickerSearch extends StatefulWidget {
  const TickerSearch({super.key});

  @override
  State<TickerSearch> createState() => _TickerSearchState();
}

class _TickerSearchState extends State<TickerSearch> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDefaultSearchData();
    });
  }
  void getDefaultSearchData() {
    context.read<LeagueSearchManager>().getSearchDefaults();
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LeagueSearchManager manager = navigatorKey.currentContext!.read<LeagueSearchManager>();
      manager.clearSearch();
    });
  }

  String _searchQuery = '';

  void _onSearchChanged(String query) async {
    setState(() {
      _searchQuery = query;
    });
    LeagueManager manager =context.read<LeagueManager>();
    TradesManger tradesManger =context.read<TradesManger>();
    Map request = {
      "term": _searchQuery,
      "tournament_battle_id": '${tradesManger.myTrades?.tournamentBattleId ?? manager.detailRes?.tournamentBattleId ?? ''}',
    };
    await context.read<LeagueSearchManager>().searchSymbols(request);
  }

  @override
  Widget build(BuildContext context) {
    LeagueSearchManager searchManager = context.watch<LeagueSearchManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        toolbarHeight: 70,
        searchFieldWidget: BaseSearchTicker(onSearchChanged: _onSearchChanged),
        showBack: true,
      ),
      body:(searchManager.searchData == null && searchManager.errorSearch == null) && !searchManager.isLoadingS ?
      BaseLoaderContainer(
        hasData: searchManager.recentSearchData != null,
        isLoading: searchManager.isLoadingRecent,
        error: searchManager.errorRecent,
        showPreparingText: true,
        child: LeagueSearchTicker(
          symbolRes: searchManager.recentSearchData?.symbols,
          onRefresh: searchManager.getSearchDefaults,
        ),
      )
          : LeagueSearchTicker(
        symbolRes: searchManager.searchData?.symbols,
        fromSearch: true,
      ),

    );
  }
}
