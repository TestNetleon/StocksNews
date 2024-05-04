import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/compare_stock_res.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/footerList/footer_list.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/headerList/header.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/widgets/pop_up.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/widgets/add_company_container.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/login_error.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

//
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

  @override
  Widget build(BuildContext context) {
    List<CompareStockRes> company =
        context.watch<CompareStocksProvider>().company;

    CompareStocksProvider provider = context.watch<CompareStocksProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimen.padding.sp,
        Dimen.padding.sp,
        Dimen.padding.sp,
        0,
      ),
      child: BaseUiContainer(
        isLoading: provider.isLoading && provider.company.isEmpty,
        hasData: true,
        error: provider.error,
        errorDispCommon: true,
        child: RefreshIndicator(
          onRefresh: () => provider.getCompareStock(),
          child: userProvider.user == null
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenTitle(title: "Compare Stocks"),
                    Expanded(
                        child: LoginError(
                      state: "compare",
                    )),
                  ],
                )
              : SingleChildScrollView(
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
                                : null),
                      ),
                      HeaderList(
                          onTap: () =>
                              company.length < 5 ? _showPopUp(context) : null),
                      const FooterList(),
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
