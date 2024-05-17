import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/container.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class CompareStocks extends StatelessWidget {
  static const String path = "CompareStocks";
  const CompareStocks({super.key});
//
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        context.read<SearchProvider>().clearSearch();
      },
      child: const BaseContainer(
        // appBar: AppBarHome(canSearch: true),
        // drawer: BaseDrawer(),
        body: CompareStocksContainer(),
      ),
    );
  }
}
