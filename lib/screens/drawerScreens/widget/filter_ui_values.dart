import 'package:flutter/material.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class FilterUiValues extends StatelessWidget {
  const FilterUiValues({
    required this.params,
    required this.onDeleteExchange,
    super.key,
  });

  final FilteredParams? params;
  final Function(String) onDeleteExchange;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: params != null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Wrap(
          children: params?.exchange_name?.map((exchange) {
                return FilterUiItem(
                  label: exchange,
                  onTap: onDeleteExchange,
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }
}

class FilterUiItem extends StatelessWidget {
  const FilterUiItem({
    required this.label,
    required this.onTap,
    super.key,
  });

  final String label;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: ThemeColors.greyBorder,
      ),
      padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3, right: 3),
      margin: const EdgeInsets.only(right: 8, top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: stylePTSansRegular(),
          ),
          GestureDetector(
            onTap: () => onTap(label),
            child: const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(Icons.cancel, size: 18),
            ),
          )
        ],
      ),
    );
  }
}
