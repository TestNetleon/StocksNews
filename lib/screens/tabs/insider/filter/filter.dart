import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/insider_trading_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/filter_drop_down.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/text_input_field.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class FilterInsiders extends StatelessWidget {
  const FilterInsiders({super.key});
//
  @override
  Widget build(BuildContext context) {
    InsiderTradingProvider provider = context.watch<InsiderTradingProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpacerVertical(height: 3),
        const ScreenTitle(title: "Filter"),
        const SpacerVertical(height: 10),
        FilterDropDownTextField(
          heading: "Transaction Type",
          value: provider.valueTxnType.isEmpty
              ? provider.transactionType![0]
              : provider.transactionType?.firstWhere(
                  (element) => element.value == provider.valueTxnType),
          items: provider.transactionType?.map((item) {
            return DropdownMenuItem<KeyValueElement>(
              value: item,
              child: Text("${item.value}"),
            );
          }).toList(),
          onChanged: (selectedItem) =>
              provider.onChangeTransactionType(selectedItem: selectedItem),
        ),
        const SpacerVertical(height: 20),
        FilterDropDownTextField(
          heading: "Market Cap",
          value: provider.valueCap.isEmpty
              ? provider.cap![0]
              : provider.cap
                  ?.firstWhere((element) => element.value == provider.valueCap),
          items: provider.cap?.map((item) {
            return DropdownMenuItem<KeyValueElement>(
              value: item,
              child: Text("${item.value}"),
            );
          }).toList(),
          onChanged: (selectedItem) =>
              provider.onChangeCap(selectedItem: selectedItem),
        ),
        const SpacerVertical(height: 20),
        FilterDropDownTextField(
          heading: "Sector",
          value: provider.valueSector.isEmpty
              ? provider.sector![0]
              : provider.sector?.firstWhere(
                  (element) => element.value == provider.valueSector),
          items: provider.sector?.map((item) {
            return DropdownMenuItem<KeyValueElement>(
              value: item,
              child: Text("${item.value}"),
            );
          }).toList(),
          onChanged: (selectedItem) =>
              provider.onChangeSector(selectedItem: selectedItem),
        ),
        const SpacerVertical(height: 20),
        FilterDropDownTextField(
          heading: "Transaction Size",
          value: provider.valueTxnSize.isEmpty
              ? provider.txnSize![0]
              : provider.txnSize?.firstWhere(
                  (element) => element.value == provider.valueTxnSize),
          items: provider.txnSize?.map((item) {
            return DropdownMenuItem<KeyValueElement>(
              value: item,
              child: Text("${item.value}"),
            );
          }).toList(),
          onChanged: (selectedItem) =>
              provider.onChangeTransactionSize(selectedItem: selectedItem),
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
                  suffix: Icon(Icons.calendar_month, size: 23.sp),
                  style: stylePTSansRegular(
                      fontSize: 15, color: ThemeColors.background),
                  hintText: "dd-mm-yyyy",
                  editable: false,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 13.sp),
                  controller: provider.date),
            ],
          ),
        ),
        const SpacerVertical(height: 20),
        ThemeButton(
          color: ThemeColors.accent,
          onPressed: () {
            Navigator.pop(context);
            provider.getData(
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
