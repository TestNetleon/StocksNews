import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/congressional_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';

import 'package:stocks_news_new/screens/marketData/congressionalData/container.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../utils/colors.dart';

class CongressionalIndex extends StatefulWidget {
  static const path = "CongressionalIndex";
  const CongressionalIndex({super.key});

  @override
  State<CongressionalIndex> createState() => _CongressionalIndexState();
}

class _CongressionalIndexState extends State<CongressionalIndex> {
  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    CongressionalProvider congressionalProvider =
        context.read<CongressionalProvider>();

    if (provider.data == null) {
      await provider.getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Congressional Trades",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: congressionalProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<CongressionalProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    CongressionalProvider provider = context.watch<CongressionalProvider>();
    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: AppBarHome(
        isPopback: true,
        showTrailing: false,
        canSearch: false,
        title: provider.extra?.title,
        onFilterClick: _onFilterClick,
      ),
      body: CongressionalContainer(),
    );
  }
}
