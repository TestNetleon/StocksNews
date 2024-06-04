// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/insider_trading_company_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer_copy.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/insider/filter/filter_insider_company.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_container.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/text_input_field_search.dart';

//
class InsiderDetailsType extends StatelessWidget {
  static const String path = "CompanyDetailsType";
  final String? companySlug, reportingSlug, companyName, reportingName;

  const InsiderDetailsType({
    super.key,
    this.companySlug,
    this.reportingSlug,
    this.companyName,
    this.reportingName,
  });

  @override
  Widget build(BuildContext context) {
    return CompanyDetailsBase(
      companySlug: companySlug,
      reportingSlug: reportingSlug,
      companyName: companyName,
      reportingName: reportingName,
    );

    // ChangeNotifierProvider.value(
    //     value: InsiderTradingDetailsProvider(),
    //     child:

    //      CompanyDetailsBase(
    //       companySlug: companySlug,
    //       reportingSlug: reportingSlug,
    //     ));
  }
}

class CompanyDetailsBase extends StatefulWidget {
  final String? companySlug, reportingSlug, companyName, reportingName;

  const CompanyDetailsBase(
      {super.key,
      this.companySlug,
      this.reportingSlug,
      this.companyName,
      this.reportingName});

  @override
  State<CompanyDetailsBase> createState() => _CompanyDetailsBaseState();
}

class _CompanyDetailsBaseState extends State<CompanyDetailsBase> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  void _getData() {
    if (widget.reportingSlug == "") {
      Utils().showLog("---------loading only for company-----------");
      context.read<InsiderTradingDetailsProvider>().insiderGraphData(
            companySlug: widget.companySlug ?? "",
          );
    } else {
      Utils().showLog("---------loading only for insider-----------");
      context.read<InsiderTradingDetailsProvider>().insiderGraphDataInsider(
            companySlug: widget.companySlug ?? "",
            reportingSlug: widget.reportingSlug ?? "",
          );
    }

    context.read<InsiderTradingDetailsProvider>().getData(
          showProgress: false,
          companySlug: widget.companySlug ?? "",
          reportingSlug: widget.reportingSlug ?? "",
        );
  }

  void _filterClick({String? companySlug, String? reportingSlug}) {
    // showPlatformBottomSheet(
    //   context: context,
    //   content: FilterInsiderCompany(
    //     companySlug: companySlug,
    //     reportingSlug: reportingSlug,
    //   ),
    // );

    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Insider Trades",
      child: FilterInsiderCompany(
        companySlug: companySlug,
        reportingSlug: reportingSlug,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InsiderTradingDetailsProvider provider =
        context.watch<InsiderTradingDetailsProvider>();
    return BaseContainer(
      drawer: const BaseDrawer(),
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
        filterClick: () => _filterClick(
          companySlug: widget.companySlug,
          reportingSlug: widget.reportingSlug,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          Dimen.padding.sp,
          Dimen.padding.sp,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: widget.companyName != "" && widget.reportingName == "",
              child: ScreenTitle(
                title: "Insider Trading- ${widget.companyName}",
                subTitle: provider.textRes?.subTitle,
                optionalWidget: GestureDetector(
                  onTap: () => _filterClick(
                    companySlug: widget.companySlug,
                    reportingSlug: widget.reportingSlug,
                  ),
                  child: const Icon(
                    Icons.filter_alt,
                    color: ThemeColors.accent,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.reportingName != "",
              child: ScreenTitle(
                title: "Insider Trading- ${widget.reportingName}",
                subTitle: provider.textResI?.subTitle,
                optionalWidget: GestureDetector(
                  onTap: () => _filterClick(
                    companySlug: widget.companySlug,
                    reportingSlug: widget.reportingSlug,
                  ),
                  child: const Icon(
                    Icons.filter_alt,
                    color: ThemeColors.accent,
                  ),
                ),
              ),
            ),

            // TextInputFieldSearch(
            //   hintText: "Find by insider name",
            //   onChanged: (text) {},
            // ),
            Visibility(
              visible: widget.companyName != "" && widget.reportingName == "",
              child: TextInputFieldSearch(
                hintText: "Find by insider name",
                onSubmitted: (text) {
                  closeKeyboard();
                  provider.getData(
                    clear: false,
                    search: text,
                    showProgress: true,
                    companySlug: widget.companySlug ?? "",
                  );
                },
                searching: provider.isSearching,
                editable: true,
              ),
            ),
            const SpacerVertical(height: 10),

            Expanded(
              child: widget.reportingSlug == ""
                  ? InsiderCompanyContainer(
                      companySlug: widget.companySlug,
                    )
                  : InsiderReportingContainer(
                      companySlug: widget.companySlug,
                      reportingSlug: widget.reportingSlug,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
