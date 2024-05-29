import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/screens/tabs/compareNew/container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';

import '../../../providers/search_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/login_error.dart';
import '../../auth/bottomSheets/login_sheet.dart';
import '../../auth/bottomSheets/login_sheet_tablet.dart';
import '../compareStocks/widgets/pop_up.dart';

class CompareNew extends StatelessWidget {
  const CompareNew({super.key});

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
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    return BaseContainer(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: ScreenTitle(
              dividerPadding:
                  const EdgeInsets.fromLTRB(0, Dimen.itemSpacing, 0, 0),
              title: "Compare Stocks",
              optionalWidget: Visibility(
                visible: userProvider.user != null,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _showPopUp(context);
                      },
                      child: const Icon(
                        Icons.add,
                        color: ThemeColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
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
                hasData: provider.company.isNotEmpty,
                error: provider.error,
                showPreparingText: true,
                child: const CompareStockNewContainer(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
