import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/searchTradingTicker/search_field.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/searchTradingTicker/search_list.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';


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
      context.read<TournamentSearchProvider>().getSearchDefaults();
    });
  }

  @override
  void dispose() {
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
      child: BaseScaffold(
        appBar: const BaseAppBar(
          showBack: true,
          title: "Search Symbol",
        ),
        body: BaseLoaderContainer(
          hasData: provider.topSearch?.isNotEmpty == true &&
              provider.topSearch != null,
          isLoading: provider.isLoading,
          error: provider.error,
          removeErrorWidget: true,
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
