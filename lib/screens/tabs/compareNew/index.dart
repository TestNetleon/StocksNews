import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/tabs/compareNew/container.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/login_error.dart';
import 'addScreen/add_stock.dart';

class CompareNew extends StatelessWidget {
  static const path = "CompareNew";
  const CompareNew({super.key});

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    return BaseContainer(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black,
            padding:
                const EdgeInsets.fromLTRB(Dimen.padding, 16, Dimen.padding, 0),
            child: const ScreenTitle(
              dividerPadding: EdgeInsets.fromLTRB(0, Dimen.itemSpacing, 0, 0),
              title: "Compare Stocks",
            ),
          ),
          Visibility(
            visible: userProvider.user == null,
            child: Expanded(
              child: LoginError(
                state: "compare",
                onClick: () async {
                  isPhone ? await loginSheet() : await loginSheetTablet();

                  await provider.getCompareStock(showProgress: false);
                },
              ),
            ),
          ),
          Visibility(
            visible: userProvider.user != null,
            child: Expanded(
              child: BaseUiContainer(
                isLoading: provider.isLoading && provider.company.isEmpty,
                hasData: true,
                error: provider.error,
                showPreparingText: true,
                child: provider.company.isEmpty ||
                        (!provider.isLoading && provider.company.length == 1)
                    ? const Align(
                        alignment: Alignment.topCenter,
                        child: CompareNewAddScreen())
                    : const CompareStockNewContainer(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
