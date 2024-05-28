import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/insider_trading_provider.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/filter_list.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/text_input_field.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class FilterInsiders extends StatelessWidget {
  const FilterInsiders({super.key});
//

  // void showTransactionPicker(BuildContext context) {
  //   InsiderTradingProvider provider = context.read<InsiderTradingProvider>();
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return FilterDropDownCupertino(
  //         children: (provider.transactionType ?? []).map((item) {
  //           return Center(
  //             child: Text(
  //               item.value ?? "", // Replace with the text you want to display
  //               style: const TextStyle(
  //                 fontSize: 20,
  //               ), // Adjust font size as needed
  //             ),
  //           );
  //         }).toList(),
  //         onSelected: (index) {
  //           provider.onChangeTransactionType(
  //             selectedItem: provider.transactionType?[index],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  void showTransactionPicker(BuildContext context) {
    InsiderTradingProvider provider = context.read<InsiderTradingProvider>();
    // showPlatformBottomSheet(
    //   showClose: false,
    //   backgroundColor: const Color.fromARGB(255, 23, 23, 23),
    //   context: context,
    //   content: FilterListing(
    //     items: List.generate(provider.transactionType?.length ?? 0, (index) {
    //       return KeyValueElement(
    //           key: provider.transactionType?[index].key,
    //           value: provider.transactionType?[index].value);
    //     }),
    //     onSelected: (index) {
    //       provider.onChangeTransactionType(
    //         selectedItem: provider.transactionType?[index],
    //       );
    //     },
    //   ),
    // );

    BaseBottomSheets().gradientBottomSheet(
      child: FilterListing(
        items: List.generate(provider.transactionType?.length ?? 0, (index) {
          return KeyValueElement(
              key: provider.transactionType?[index].key,
              value: provider.transactionType?[index].value);
        }),
        onSelected: (index) {
          provider.onChangeTransactionType(
            selectedItem: provider.transactionType?[index],
          );
        },
      ),
    );
  }

  // void showMarketCapPicker(BuildContext context) {
  //   InsiderTradingProvider provider = context.read<InsiderTradingProvider>();
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return FilterDropDownCupertino(
  //         children: (provider.cap ?? []).map((item) {
  //           return Center(
  //             child: Text(
  //               // Replace with the text you want to display
  //               item.value ?? "",
  //               style: const TextStyle(fontSize: 20),
  //               // Adjust font size as needed
  //             ),
  //           );
  //         }).toList(),
  //         onSelected: (index) {
  //           provider.onChangeCap(
  //             selectedItem: provider.cap?[index],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void showMarketCapPicker(BuildContext context) {
    InsiderTradingProvider provider = context.read<InsiderTradingProvider>();
    // showPlatformBottomSheet(
    //   showClose: false,
    //   backgroundColor: const Color.fromARGB(255, 23, 23, 23),
    //   context: context,
    //   content: FilterListing(
    //     items: List.generate(provider.cap?.length ?? 0, (index) {
    //       return KeyValueElement(
    //           key: provider.cap?[index].key, value: provider.cap?[index].value);
    //     }),
    //     onSelected: (index) {
    //       provider.onChangeCap(
    //         selectedItem: provider.cap?[index],
    //       );
    //     },
    //   ),
    // );

    BaseBottomSheets().gradientBottomSheet(
      child: FilterListing(
        items: List.generate(provider.cap?.length ?? 0, (index) {
          return KeyValueElement(
              key: provider.cap?[index].key, value: provider.cap?[index].value);
        }),
        onSelected: (index) {
          provider.onChangeCap(
            selectedItem: provider.cap?[index],
          );
        },
      ),
    );
  }

  // void showSectorPicker(BuildContext context) {
  //   InsiderTradingProvider provider = context.read<InsiderTradingProvider>();
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return FilterDropDownCupertino(
  //         children: (provider.sector ?? []).map((item) {
  //           return Center(
  //             child: Text(
  //               // Replace with the text you want to display
  //               item.value ?? "",
  //               style: const TextStyle(fontSize: 20),
  //               // Adjust font size as needed
  //             ),
  //           );
  //         }).toList(),
  //         onSelected: (index) {
  //           provider.onChangeSector(
  //             selectedItem: provider.sector?[index],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // void showSectorPicker(BuildContext context) {
  //   InsiderTradingProvider provider = context.read<InsiderTradingProvider>();
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return FilterDropDownCupertino(
  //         children: (provider.sector ?? []).map((item) {
  //           return Center(
  //             child: Text(
  //               // Replace with the text you want to display
  //               item.value ?? "",
  //               style: const TextStyle(fontSize: 20),
  //               // Adjust font size as needed
  //             ),
  //           );
  //         }).toList(),
  //         onSelected: (index) {
  //           provider.onChangeSector(
  //             selectedItem: provider.sector?[index],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void showSectorPicker(BuildContext context) {
    InsiderTradingProvider provider = context.read<InsiderTradingProvider>();
    // showPlatformBottomSheet(
    //   showClose: false,
    //   backgroundColor: const Color.fromARGB(255, 23, 23, 23),
    //   context: context,
    //   content: FilterListing(
    //     items: List.generate(provider.sector?.length ?? 0, (index) {
    //       return KeyValueElement(
    //           key: provider.sector?[index].key,
    //           value: provider.sector?[index].value);
    //     }),
    //     onSelected: (index) {
    //       provider.onChangeSector(
    //         selectedItem: provider.sector?[index],
    //       );
    //     },
    //   ),
    // );
    BaseBottomSheets().gradientBottomSheet(
      child: FilterListing(
        items: List.generate(provider.sector?.length ?? 0, (index) {
          return KeyValueElement(
              key: provider.sector?[index].key,
              value: provider.sector?[index].value);
        }),
        onSelected: (index) {
          provider.onChangeSector(
            selectedItem: provider.sector?[index],
          );
        },
      ),
    );
  }

  // void showTransactionSizePicker(BuildContext context) {
  //   InsiderTradingProvider provider = context.read<InsiderTradingProvider>();
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return FilterDropDownCupertino(
  //         children: (provider.txnSize ?? []).map((item) {
  //           return Center(
  //             child: Text(
  //               // Replace with the text you want to display
  //               item.value ?? "",
  //               style: const TextStyle(fontSize: 20),
  //               // Adjust font size as needed
  //             ),
  //           );
  //         }).toList(),
  //         onSelected: (index) {
  //           provider.onChangeTransactionSize(
  //             selectedItem: provider.txnSize?[index],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  void showTransactionSizePicker(BuildContext context) {
    InsiderTradingProvider provider = context.read<InsiderTradingProvider>();
    // showPlatformBottomSheet(
    //   showClose: false,
    //   backgroundColor: const Color.fromARGB(255, 23, 23, 23),
    //   context: context,
    //   content: FilterListing(
    //     items: List.generate(provider.txnSize?.length ?? 0, (index) {
    //       return KeyValueElement(
    //           key: provider.txnSize?[index].key,
    //           value: provider.txnSize?[index].value);
    //     }),
    //     onSelected: (index) {
    //       provider.onChangeTransactionSize(
    //         selectedItem: provider.txnSize?[index],
    //       );
    //     },
    //   ),
    // );
    BaseBottomSheets().gradientBottomSheet(
      child: FilterListing(
        items: List.generate(provider.txnSize?.length ?? 0, (index) {
          return KeyValueElement(
              key: provider.txnSize?[index].key,
              value: provider.txnSize?[index].value);
        }),
        onSelected: (index) {
          provider.onChangeTransactionSize(
            selectedItem: provider.txnSize?[index],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InsiderTradingProvider provider = context.watch<InsiderTradingProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // const SpacerVertical(height: 3),
        // const ScreenTitle(title: "Filter Insider Trades"),
        // const SpacerVertical(height: 10),
        // FilterDropDownTextField(
        //   heading: "Transaction Type",
        //   value: provider.valueTxnType.isEmpty
        //       ? provider.transactionType![0]
        //       : provider.transactionType?.firstWhere(
        //           (element) => element.value == provider.valueTxnType,
        //         ),
        //   items: provider.transactionType?.map((item) {
        //     return DropdownMenuItem<KeyValueElement>(
        //       value: item,
        //       child: Text("${item.value}"),
        //     );
        //   }).toList(),
        //   onChanged: (selectedItem) =>
        //       provider.onChangeTransactionType(selectedItem: selectedItem),
        // ),
        GestureDetector(
          onTap: () => showTransactionPicker(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Transaction Type", style: stylePTSansRegular()),
              const SpacerVertical(height: 5),
              TextInputField(
                hintText: provider.transactionType?[0].value,
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
                controller: provider.type,
              ),
            ],
          ),
        ),
        const SpacerVertical(height: 20),
        // FilterDropDownTextField(
        //   heading: "Market Cap",
        //   value: provider.valueCap.isEmpty
        //       ? provider.cap![0]
        //       : provider.cap
        //           ?.firstWhere((element) => element.value == provider.valueCap),
        //   items: provider.cap?.map((item) {
        //     return DropdownMenuItem<KeyValueElement>(
        //       value: item,
        //       child: Text("${item.value}"),
        //     );
        //   }).toList(),
        //   onChanged: (selectedItem) =>
        //       provider.onChangeCap(selectedItem: selectedItem),
        // ),
        GestureDetector(
          onTap: () => showMarketCapPicker(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Market Cap", style: stylePTSansRegular()),
              const SpacerVertical(height: 5),
              TextInputField(
                hintText: provider.cap?[0].value,
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
                controller: provider.capController,
              ),
            ],
          ),
        ),
        const SpacerVertical(height: 20),
        // FilterDropDownTextField(
        //   heading: "Sector",
        //   value: provider.valueSector.isEmpty
        //       ? provider.sector![0]
        //       : provider.sector?.firstWhere(
        //           (element) => element.value == provider.valueSector,
        //         ),
        //   items: provider.sector?.map((item) {
        //     return DropdownMenuItem<KeyValueElement>(
        //       value: item,
        //       child: Text("${item.value}"),
        //     );
        //   }).toList(),
        //   onChanged: (selectedItem) =>
        //       provider.onChangeSector(selectedItem: selectedItem),
        // ),
        GestureDetector(
          onTap: () => showSectorPicker(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sector", style: stylePTSansRegular()),
              const SpacerVertical(height: 5),
              TextInputField(
                hintText: provider.sector?[0].value,
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
                controller: provider.sectorController,
              ),
            ],
          ),
        ),
        const SpacerVertical(height: 20),
        // FilterDropDownTextField(
        //   heading: "Transaction Size",
        //   value: provider.valueTxnSize.isEmpty
        //       ? provider.txnSize![0]
        //       : provider.txnSize?.firstWhere(
        //           (element) => element.value == provider.valueTxnSize),
        //   items: provider.txnSize?.map((item) {
        //     return DropdownMenuItem<KeyValueElement>(
        //       value: item,
        //       child: Text("${item.value}"),
        //     );
        //   }).toList(),
        //   onChanged: (selectedItem) =>
        //       provider.onChangeTransactionSize(selectedItem: selectedItem),
        // ),
        GestureDetector(
          onTap: () => showTransactionSizePicker(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Transaction Size", style: stylePTSansRegular()),
              const SpacerVertical(height: 5),
              TextInputField(
                hintText: provider.txnSize?[0].value,
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
                controller: provider.txnSizeController,
              ),
            ],
          ),
        ),
        const SpacerVertical(height: 20),
        GestureDetector(
          onTap: provider.pickDate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transaction Date",
                style: stylePTSansRegular(),
              ),
              const SpacerVertical(height: 5),
              TextInputField(
                suffix: const Icon(Icons.calendar_month, size: 23),
                style: stylePTSansRegular(
                  fontSize: 15,
                  color: ThemeColors.background,
                ),
                hintText: "dd-mm-yyyy",
                editable: false,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 13.sp,
                ),
                controller: provider.date,
              ),
            ],
          ),
        ),
        const SpacerVertical(height: 20),
        ThemeButton(
          color: ThemeColors.accent,
          onPressed: () {
            Navigator.pop(context);
            provider.getData(
              showProgress: false,
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
