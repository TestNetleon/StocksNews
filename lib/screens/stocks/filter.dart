import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/screens/stocks/widgets/text_field.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/custom/filter_list.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../../utils/theme.dart';
import '../../widgets/text_input_field.dart';

class FilterStocks extends StatefulWidget {
  const FilterStocks({super.key});

  @override
  State<FilterStocks> createState() => _FilterStocksState();
}

void showExchangePicker(BuildContext context) {
  AllStocksProvider provider = context.read<AllStocksProvider>();
  // showPlatformBottomSheet(
  //   showClose: false,
  //   backgroundColor: const Color.fromARGB(255, 23, 23, 23),
  //   context: context,
  //   content: FilterListing(
  //     items: List.generate(provider.exchangeShortName?.length ?? 0, (index) {
  //       return KeyValueElement(
  //           key: provider.exchangeShortName?[index].key,
  //           value: provider.exchangeShortName?[index].value);
  //     }),
  //     onSelected: (index) {
  //       provider.onChangeExchange(
  //         selectedItem: provider.exchangeShortName?[index],
  //       );
  //     },
  //   ),
  // );

  BaseBottomSheets().gradientBottomSheet(
    child: FilterListing(
      items: List.generate(provider.exchangeShortName?.length ?? 0, (index) {
        return KeyValueElement(
            key: provider.exchangeShortName?[index].key,
            value: provider.exchangeShortName?[index].value);
      }),
      onSelected: (index) {
        provider.onChangeExchange(
          selectedItem: provider.exchangeShortName?[index],
        );
      },
    ),
  );
}

void showPricePicker(BuildContext context) {
  AllStocksProvider provider = context.read<AllStocksProvider>();
  // showPlatformBottomSheet(
  //   showClose: false,
  //   backgroundColor: const Color.fromARGB(255, 23, 23, 23),
  //   context: context,
  //   content: FilterListing(
  //     items: List.generate(provider.priceRange?.length ?? 0, (index) {
  //       return KeyValueElement(
  //           key: provider.priceRange?[index].key,
  //           value: provider.priceRange?[index].value);
  //     }),
  //     onSelected: (index) {
  //       provider.onChangePrice(
  //         selectedItem: provider.priceRange?[index],
  //       );
  //     },
  //   ),
  // );

  BaseBottomSheets().gradientBottomSheet(
    child: FilterListing(
      items: List.generate(provider.priceRange?.length ?? 0, (index) {
        return KeyValueElement(
            key: provider.priceRange?[index].key,
            value: provider.priceRange?[index].value);
      }),
      onSelected: (index) {
        provider.onChangePrice(
          selectedItem: provider.priceRange?[index],
        );
      },
    ),
  );
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
        // const SpacerVertical(height: 3),
        // const ScreenTitle(title: "Filter"),
        // const SpacerVertical(height: 10),
        // FilterDropDownTextField(
        //   heading: "Exchange",
        //   value: provider.valueExchange.isEmpty
        //       ? provider.exchangeShortName![0]
        //       : provider.exchangeShortName?.firstWhere(
        //           (element) => element.value == provider.valueExchange),
        //   items: provider.exchangeShortName?.map((item) {
        //     return DropdownMenuItem<KeyValueElement>(
        //       value: item,
        //       child: Text("${item.value}"),
        //     );
        //   }).toList(),
        //   onChanged: (selectedItem) =>
        //       provider.onChangeExchange(selectedItem: selectedItem),
        // ),
        GestureDetector(
          onTap: () => showExchangePicker(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Exchange", style: stylePTSansRegular()),
              const SpacerVertical(height: 5),
              TextInputField(
                hintText: provider.exchangeShortName?[0].value,
                suffix: const Icon(
                  Icons.arrow_drop_down,
                  size: 23,
                  color: ThemeColors.background,
                ),
                style: stylePTSansRegular(
                  fontSize: 15,
                  color: ThemeColors.background,
                ),
                editable: false,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 13.sp,
                ),
                controller: provider.exchangeController,
              ),
            ],
          ),
        ),

        const SpacerVertical(height: 20),
        // FilterDropDownTextField(
        //   heading: "Price",
        //   value: provider.valuePrice.isEmpty
        //       ? provider.priceRange![0]
        //       : provider.priceRange?.firstWhere(
        //           (element) => element.value == provider.valuePrice),
        //   items: provider.priceRange?.map((item) {
        //     return DropdownMenuItem<KeyValueElement>(
        //       value: item,
        //       child: Text("${item.value}"),
        //     );
        //   }).toList(),
        //   onChanged: (selectedItem) =>
        //       provider.onChangePrice(selectedItem: selectedItem),
        // ),

        GestureDetector(
          onTap: () => showPricePicker(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Price", style: stylePTSansRegular()),
              const SpacerVertical(height: 5),
              TextInputField(
                hintText: provider.priceRange?[0].value,
                suffix: const Icon(
                  Icons.arrow_drop_down,
                  size: 23,
                  color: ThemeColors.background,
                ),
                style: stylePTSansRegular(
                  fontSize: 15,
                  color: ThemeColors.background,
                ),
                editable: false,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 13.sp,
                ),
                controller: provider.priceController,
              ),
            ],
          ),
        ),
        const SpacerVertical(height: 20),
        Text("Percentage", style: stylePTSansRegular()),
        const SpacerVertical(height: 5),
        const TextFieldChangePercentage(),
        const SpacerVertical(height: 20),
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
        const SpacerVertical(height: 10),
      ],
    );
  }
}
