import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/compare_stock_res.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/footerList/footer_list.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/headerList/header.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/widgets/add_company_container.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/login_error.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../providers/search_provider.dart';
import 'widgets/pop_up.dart';

class CompareStocksContainer extends StatelessWidget {
  const CompareStocksContainer({super.key});

  _showPopUp(BuildContext context) {
    context.read<SearchProvider>().clearSearch();
    showDialog(
        context: context,
        builder: (context) {
          return const CompareStocksPopup();
        });
  }
  // _showBottomSheet() {
  //   showModalBottomSheet(
  //     useSafeArea: true,
  //     backgroundColor: ThemeColors.transparent,
  //     // constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 100),
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(5.sp),
  //         topRight: Radius.circular(5.sp),
  //       ),
  //     ),
  //     context: navigatorKey.currentContext!,
  //     builder: (context) {
  //       return const CompareNewSearch(
  //         fromAdd: true,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    List<CompareStockRes> company =
        context.watch<CompareStocksProvider>().company;

    CompareStocksProvider provider = context.watch<CompareStocksProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Compare Stocks"},
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimen.padding.sp,
        isPhone ? 0 : Dimen.paddingTablet.sp,
        Dimen.padding.sp,
        0,
      ),
      child: userProvider.user == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenTitle(title: "Compare Stocks"),
                Expanded(
                  child: LoginError(
                    state: "compare",
                    onClick: () async {
                      isPhone ? await loginSheet() : await loginSheetTablet();

                      await provider.getCompareStock(showProgress: false);
                    },
                  ),
                ),
              ],
            )
          : BaseUiContainer(
              isLoading: provider.isLoading && provider.company.isEmpty,
              hasData: true,
              error: provider.error,
              errorDispCommon: true,
              showPreparingText: true,
              child: CommonRefreshIndicator(
                onRefresh: () => provider.getCompareStock(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenTitle(
                        title: "Compare Stocks",
                        subTitle: provider.textRes?.subTitle,
                      ),
                      Visibility(
                        visible: company.isEmpty,
                        child: AddCompanyContainer(
                            onTap: () => company.length < 4
                                ? _showPopUp(context)
                                // ? _showBottomSheet()
                                : null),
                      ),
                      HeaderList(
                        onTap: () => company.length < 5
                            ? _showPopUp(context)
                            // _showBottomSheet()
                            : null,
                      ),
                      const FooterList(),
                      if (context
                                  .read<CompareStocksProvider>()
                                  .extra
                                  ?.disclaimer !=
                              null &&
                          !context
                              .watch<CompareStocksProvider>()
                              .wholeListEmpty)
                        DisclaimerWidget(
                            data: context
                                .read<CompareStocksProvider>()
                                .extra!
                                .disclaimer!)
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CompareCompany {
  String symbol;
  CompareCompany({required this.symbol});
}
