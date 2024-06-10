import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/filter_ui_values.dart';
import 'package:stocks_news_new/widgets/html_title.dart';

class MarketDataHeader extends StatelessWidget {
  const MarketDataHeader({
    required this.onFilterClick,
    required this.onDeleteExchange,
    required this.provider,
    super.key,
  });

  final Function() onFilterClick;
  final Function(String) onDeleteExchange;
  final dynamic provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!(provider.data == null &&
                provider.filterParams == null &&
                provider.isLoading) &&
            provider.extra != null)
          HtmlTitle(
            subTitle: provider.extra?.subTitle,
            onFilterClick: onFilterClick,
            hasFilter: provider.filterParams != null,
          ),
        if (provider.filterParams != null)
          FilterUiValues(
            params: provider.filterParams,
            onDeleteExchange: onDeleteExchange,
          ),
      ],
    );
  }
}
