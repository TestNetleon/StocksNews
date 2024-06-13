import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/overview/range.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'desclaimer.dart';
import 'top_widget.dart';

class SdOverview extends StatefulWidget {
  final String? symbol;
  const SdOverview({super.key, this.symbol});

  @override
  State<SdOverview> createState() => _SdOverviewState();
}

class _SdOverviewState extends State<SdOverview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callApi();
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getOverviewData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingOverview &&
          (!provider.isLoadingOverview && provider.overviewRes != null),
      isLoading: provider.isLoadingOverview,
      showPreparingText: true,
      error: provider.errorOverview,
      onRefresh: _callApi,
      child: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Dimen.padding,
            Dimen.padding,
            Dimen.padding,
            0,
          ),
          child: Column(
            children: [
              SdTopWidgetDetail(),
              SpacerVertical(height: 4),
              SdTopDisclaimer(),
              SpacerVertical(height: 4),
              SdTopWidgetRange(),
            ],
          ),
        ),
      ),
    );
  }
}
