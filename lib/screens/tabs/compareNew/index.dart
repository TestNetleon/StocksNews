import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/screens/tabs/compareNew/container.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';

class CompareNew extends StatelessWidget {
  const CompareNew({super.key});

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();
    return BaseContainer(
      body: BaseUiContainer(
          isLoading: provider.isLoading && provider.company.isEmpty,
          hasData: provider.company.isNotEmpty,
          error: provider.error,
          showPreparingText: true,
          child: const CompareStockNewContainer()),
    );
  }
}
