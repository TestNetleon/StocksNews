import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/screens/tabs/compareNew/earnings/earnings.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import '../../../providers/search_provider.dart';
import '../../../route/my_app.dart';
import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/custom/refresh_indicator.dart';
import '../../../widgets/spacer_horizontal.dart';
import '../../../widgets/spacer_vertical.dart';
import '../compareStocks/widgets/pop_up.dart';
import 'analysis/analysis.dart';
import 'dividends/dividends.dart';
import 'searchTicker/index.dart';
import 'widgets/header.dart';
import 'overview/overview.dart';

class CompareStockNewContainer extends StatelessWidget {
  const CompareStockNewContainer({super.key});
  // _showPopUp(BuildContext context) {
  //   context.read<SearchProvider>().clearSearch();
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return const CompareStocksPopup();
  //       });
  // }

  _showBottomSheet() {
    showModalBottomSheet(
      useSafeArea: true,
      backgroundColor: ThemeColors.transparent,
      // constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 100),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.sp),
          topRight: Radius.circular(5.sp),
        ),
      ),
      context: navigatorKey.currentContext!,
      builder: (context) {
        return const CompareNewSearch();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimen.padding, Dimen.padding, Dimen.padding, 0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: CompareNewHeader(),
          ),
          const SpacerVertical(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Visibility(
              visible: provider.compareData.length > 1 &&
                  provider.compareData.length < 3,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: ThemeColors.accent),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    backgroundColor: ThemeColors.transparent),
                onPressed: () {
                  // _showPopUp(context);
                  _showBottomSheet();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      size: 20,
                      color: ThemeColors.accent,
                    ),
                    const SpacerHorizontal(width: 5),
                    Text(
                      "Add Stock",
                      style: stylePTSansBold(
                          fontSize: 13, color: ThemeColors.accent),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomTabContainerNEW(
              physics: const NeverScrollableScrollPhysics(),
              scrollable: true,
              tabsPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              tabs: List.generate(
                  provider.tabs.length, (index) => provider.tabs[index]),
              widgets: List.generate(
                provider.tabs.length,
                (index) {
                  if (index == 0) {
                    return _onRefresh(const CompareNewOverview(), provider);
                  }
                  if (index == 1) {
                    return _onRefresh(const CompareNewAnalysis(), provider);
                  }

                  if (index == 2) {
                    return _onRefresh(const CompareNewEarnings(), provider);
                  }
                  if (index == 3) {
                    return _onRefresh(const CompareNewDividends(), provider);
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _onRefresh(child, CompareStocksProvider provider) {
    return CommonRefreshIndicator(
        child: child,
        onRefresh: () async {
          provider.getCompareStock();
        });
  }
}
