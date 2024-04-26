import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/insider_trading_company_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/filter_drop_down.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/text_input_field.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class FilterInsiderCompany extends StatelessWidget {
  final String? companySlug, reportingSlug;
  const FilterInsiderCompany({super.key, this.companySlug, this.reportingSlug});

  @override
  Widget build(BuildContext context) {
    InsiderTradingDetailsProvider provider =
        context.watch<InsiderTradingDetailsProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpacerVerticel(height: 3),
        const ScreenTitle(title: "Filter"),
        const SpacerVerticel(height: 10),
        FilterDropDownTextField(
          heading: "Transaction Type",
          value: reportingSlug == ""
              ? provider.valueTxnTypeCP.isEmpty
                  ? provider.transactionType![0]
                  : provider.transactionType?.firstWhere(
                      (element) => element.value == provider.valueTxnTypeCP)
              : provider.valueTxnTypeIP.isEmpty
                  ? provider.transactionType![0]
                  : provider.transactionType?.firstWhere(
                      (element) => element.value == provider.valueTxnTypeIP),
          items: provider.transactionType?.map((item) {
            return DropdownMenuItem<KeyValueElement>(
              value: item,
              child: Text("${item.value}"),
            );
          }).toList(),
          onChanged: (selectedItem) => reportingSlug == ""
              ? provider.onChangeTransactionTypeCP(selectedItem: selectedItem)
              : provider.onChangeTransactionTypeIP(selectedItem: selectedItem),
        ),
        const SpacerVerticel(height: 20),
        FilterDropDownTextField(
          heading: "Transaction Size",
          value: provider.valueTxnSizeCP.isEmpty
              ? provider.txnSize![0]
              : provider.txnSize?.firstWhere(
                  (element) => element.value == provider.valueTxnSizeCP),
          items: provider.txnSize?.map((item) {
            return DropdownMenuItem<KeyValueElement>(
              value: item,
              child: Text("${item.value}"),
            );
          }).toList(),
          onChanged: (selectedItem) => reportingSlug == ""
              ? provider.onChangeTransactionSizeCP(selectedItem: selectedItem)
              : provider.onChangeTransactionSizeIP(selectedItem: selectedItem),
        ),
        const SpacerVerticel(height: 20),
        GestureDetector(
          onTap: () => provider.pickDate(isCP: reportingSlug == ""),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transaction Date",
                style: stylePTSansRegular(),
              ),
              const SpacerVerticel(height: 5),
              TextInputField(
                  style: stylePTSansRegular(
                      fontSize: 15, color: ThemeColors.background),
                  hintText: "dd-mm-yyyy",
                  editable: false,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 13.sp),
                  controller:
                      reportingSlug == "" ? provider.dateCP : provider.dateIP),
            ],
          ),
        ),
        const SpacerVerticel(height: 20),
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
              showProgress: true,
              clear: false,
              companySlug: companySlug ?? "",
              reportingSlug: reportingSlug ?? "",
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
