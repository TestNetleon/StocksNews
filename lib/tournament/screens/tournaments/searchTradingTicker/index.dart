import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';

import '../../../provider/search.dart';
import 'search_field.dart';
import 'search_list.dart';

class TournamentSearch extends StatefulWidget {
  final bool buy;
  const TournamentSearch({super.key, this.buy = true});

  @override
  State<TournamentSearch> createState() => _TournamentSearchState();
}

class _TournamentSearchState extends State<TournamentSearch> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TournamentSearchProvider>().clearSearch();
    });
  }

  @override
  void dispose() {
    // context.read<TradingSearchProvider>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TournamentSearchProvider provider =
        context.watch<TournamentSearchProvider>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        context.read<TournamentSearchProvider>().clearSearch();
      },
      child: BaseContainer(
        appBar: const AppBarHome(
          isPopBack: true,
          canSearch: false,
          showTrailing: false,
          title: "Search Symbol",
        ),
        body: BaseUiContainer(
          hasData: provider.topSearch?.isNotEmpty == true &&
              provider.topSearch != null,
          isLoading: provider.isLoading,
          error: provider.error,
          errorDispCommon: true,
          onRefresh: () =>
              context.read<TournamentSearchProvider>().getSearchDefaults(),
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
                provider.getSearchDefaults();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TournamentInputFieldSearch(
                      hintText: "Search symbol or company name",
                      editable: true,
                    ),
                    TournamentDefaultSearch(),
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
