import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/insider_trading_company_provider.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/filter_list.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/text_input_field.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class FilterInsiderCompany extends StatelessWidget {
  final String? companySlug, reportingSlug;
  const FilterInsiderCompany({super.key, this.companySlug, this.reportingSlug});
//

  void showTransactionPicker(BuildContext context) {
    InsiderTradingDetailsProvider provider =
        context.read<InsiderTradingDetailsProvider>();
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
    //       if (reportingSlug == "") {
    //         provider.onChangeTransactionTypeCP(
    //           selectedItem: provider.transactionType?[index],
    //         );
    //       } else {
    //         provider.onChangeTransactionTypeIP(
    //           selectedItem: provider.transactionType?[index],
    //         );
    //       }
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
          if (reportingSlug == "") {
            provider.onChangeTransactionTypeCP(
              selectedItem: provider.transactionType?[index],
            );
          } else {
            provider.onChangeTransactionTypeIP(
              selectedItem: provider.transactionType?[index],
            );
          }
        },
      ),
    );
  }

  void showTransactionSizePicker(BuildContext context) {
    InsiderTradingDetailsProvider provider =
        context.read<InsiderTradingDetailsProvider>();
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
    //       if (reportingSlug == "") {
    //         provider.onChangeTransactionSizeCP(
    //           selectedItem: provider.txnSize?[index],
    //         );
    //       } else {
    //         provider.onChangeTransactionSizeIP(
    //           selectedItem: provider.txnSize?[index],
    //         );
    //       }
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
          if (reportingSlug == "") {
            provider.onChangeTransactionSizeCP(
              selectedItem: provider.txnSize?[index],
            );
          } else {
            provider.onChangeTransactionSizeIP(
              selectedItem: provider.txnSize?[index],
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InsiderTradingDetailsProvider provider =
        context.watch<InsiderTradingDetailsProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // const SpacerVertical(height: 3),
        // const ScreenTitle(title: "Filter"),
        // const SpacerVertical(height: 10),
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
                  // vertical: 13.sp,
                ),
                controller: reportingSlug == ""
                    ? provider.tnxTypeControllerCP
                    : provider.tnxTypeControllerIP,
              ),
            ],
          ),
        ),

        // FilterDropDownTextField(
        //   heading: "Transaction Type",
        //   value: reportingSlug == ""
        //       ? provider.valueTxnTypeCP.isEmpty
        //           ? provider.transactionType![0]
        //           : provider.transactionType?.firstWhere(
        //               (element) => element.value == provider.valueTxnTypeCP)
        //       : provider.valueTxnTypeIP.isEmpty
        //           ? provider.transactionType![0]
        //           : provider.transactionType?.firstWhere(
        //               (element) => element.value == provider.valueTxnTypeIP),
        //   items: provider.transactionType?.map((item) {
        //     return DropdownMenuItem<KeyValueElement>(
        //       value: item,
        //       child: Text("${item.value}"),
        //     );
        //   }).toList(),
        //   onChanged: (selectedItem) => reportingSlug == ""
        //       ? provider.onChangeTransactionTypeCP(selectedItem: selectedItem)
        //       : provider.onChangeTransactionTypeIP(
        //           selectedItem: selectedItem),
        // ),
        const SpacerVertical(height: 20),
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
                  // vertical: 13.sp,
                ),
                controller: reportingSlug == ""
                    ? provider.tnxSizeControllerCP
                    : provider.tnxSizeControllerIP,
              ),
            ],
          ),
        ),

        // FilterDropDownTextField(
        //   heading: "Transaction Size",
        //   value: provider.valueTxnSizeCP.isEmpty
        //       ? provider.txnSize![0]
        //       : provider.txnSize?.firstWhere(
        //           (element) => element.value == provider.valueTxnSizeCP),
        //   items: provider.txnSize?.map((item) {
        //     return DropdownMenuItem<KeyValueElement>(
        //       value: item,
        //       child: Text("${item.value}"),
        //     );
        //   }).toList(),
        //   onChanged: (selectedItem) => reportingSlug == ""
        //       ? provider.onChangeTransactionSizeCP(selectedItem: selectedItem)
        //       : provider.onChangeTransactionSizeIP(
        //           selectedItem: selectedItem),
        // ),
        const SpacerVertical(height: 20),
        GestureDetector(
          onTap: () => provider.pickDate(isCP: reportingSlug == ""),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transaction Date",
                style: stylePTSansRegular(),
              ),
              const SpacerVertical(height: 5),
              TextInputField(
                  style: stylePTSansRegular(
                      fontSize: 15, color: ThemeColors.background),
                  hintText: "mm dd, yyyy",
                  editable: false,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.sp,
                    // vertical: 13.sp,
                  ),
                  controller:
                      reportingSlug == "" ? provider.dateCP : provider.dateIP),
            ],
          ),
        ),
        const SpacerVertical(height: 20),
        ThemeButton(
          color: ThemeColors.accent,
          onPressed: () {
            Navigator.pop(context);
            if (reportingSlug == "" || reportingSlug == null) {
              provider.insiderGraphData(
                companySlug: companySlug ?? "",
              );
            } else {
              provider.insiderGraphDataInsider(
                companySlug: companySlug ?? "",
                reportingSlug: reportingSlug ?? "",
              );
            }
            provider.getData(
              showProgress: false,
              clear: false,
              companySlug: companySlug ?? "",
              reportingSlug: reportingSlug ?? "",
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
