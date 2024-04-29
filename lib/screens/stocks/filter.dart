import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/screens/stocks/widgets/text_field.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/filter_drop_down.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class FilterStocks extends StatefulWidget {
  const FilterStocks({super.key});

  @override
  State<FilterStocks> createState() => _FilterStocksState();
}

class _FilterStocksState extends State<FilterStocks> {
  @override
  Widget build(BuildContext context) {
    AllStocksProvider provider = context.watch<AllStocksProvider>();
//
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpacerVerticel(height: 3),
        const ScreenTitle(title: "Filter"),
        const SpacerVerticel(height: 10),
        FilterDropDownTextField(
          heading: "Exchange",
          value: provider.valueExchange.isEmpty
              ? provider.exchangeShortName![0]
              : provider.exchangeShortName?.firstWhere(
                  (element) => element.value == provider.valueExchange),
          items: provider.exchangeShortName?.map((item) {
            return DropdownMenuItem<KeyValueElement>(
              value: item,
              child: Text("${item.value}"),
            );
          }).toList(),
          onChanged: (selectedItem) =>
              provider.onChangeExchange(selectedItem: selectedItem),
        ),
        const SpacerVerticel(height: 20),
        FilterDropDownTextField(
          heading: "Price",
          value: provider.valuePrice.isEmpty
              ? provider.priceRange![0]
              : provider.priceRange?.firstWhere(
                  (element) => element.value == provider.valuePrice),
          items: provider.priceRange?.map((item) {
            return DropdownMenuItem<KeyValueElement>(
              value: item,
              child: Text("${item.value}"),
            );
          }).toList(),
          onChanged: (selectedItem) =>
              provider.onChangePrice(selectedItem: selectedItem),
        ),
        const SpacerVerticel(height: 20),
        const TextFieldChangePercentage(),
        const SpacerVerticel(height: 20),
        ThemeButton(
          color: ThemeColors.accent,
          onPressed: () {
            Navigator.pop(context);
            context.read<AllStocksProvider>().getData(
                  showProgress: true,
                  clear: false,
                );
          },
          text: "FILTER",
          textColor: Colors.white,
        ),
        const SpacerVerticel(height: 10),
      ],
    );
  }
}
