import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/insider_trading_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/insider/filter/filter.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/text_input_field_search.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../../providers/home_provider.dart';
import '../../../providers/user_provider.dart';
import '../../marketData/lock/common_lock.dart';

//
class Insider extends StatelessWidget {
  const Insider({super.key});

  void _filterClick() {
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Insider Trading",
      child: const FilterInsiders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    InsiderTradingProvider provider = context.watch<InsiderTradingProvider>();

    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Insider Trending"},
    );

    HomeProvider homeProvider = context.watch<HomeProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
            (element) =>
                (element.key == "insider-trading" && element.status == 0)) ??
        false;

    // bool isLocked = true;

    if (purchased && isLocked) {
      bool havePermissions = userProvider.user?.membership?.permissions?.any(
              (element) =>
                  (element.key == "insider-trading" && element.status == 1)) ??
          false;
      isLocked = !havePermissions;
    }

    return BaseContainer(
      drawer: const BaseDrawer(),
      appBar: AppBarHome(
        showTrailing: false,
        canSearch: false,
        title: "Insider Trading",
        onFilterClick: _filterClick,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimen.padding,
              isPhone ? 0 : 8.sp,
              Dimen.padding,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                provider.isLoading
                    ? const SizedBox()
                    : ScreenTitle(
                        // title: "Insider Trading",
                        subTitle: provider.textRes?.subTitle,
                        dividerPadding: EdgeInsets.only(bottom: 5),
                        // optionalWidget: GestureDetector(
                        //   onTap: _filterClick,
                        //   child: const Icon(
                        //     Icons.filter_alt,
                        //     color: ThemeColors.accent,
                        //   ),
                        // ),
                      ),
                if (provider.isLoading == false)
                  TextInputFieldSearch(
                    hintText: "Find by insider or company name",
                    onSubmitted: (text) {
                      closeKeyboard();
                      provider.getData(search: text, clear: false);
                    },
                    searching: provider.isSearching,
                    editable: true,
                  ),
                const Expanded(child: InsiderContent())
              ],
            ),
          ),
          if (isLocked) CommonLock(showLogin: true, isLocked: isLocked),
        ],
      ),
    );
  }
}
