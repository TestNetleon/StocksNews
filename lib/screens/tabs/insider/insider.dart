import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/insider_trading_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/tabs/insider/filter/filter.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/text_input_field_search.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

//
class Insider extends StatelessWidget {
  const Insider({super.key});

  void _filterClick() {
    showPlatformBottomSheet(
      context: navigatorKey.currentContext!,
      content: const FilterInsiders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    InsiderTradingProvider provider = context.watch<InsiderTradingProvider>();

    FirebaseAnalytics.instance.logEvent(
      name: 'ScreensVisit',
      parameters: {'screen_name': "Insider Trending"},
    );

    return BaseContainer(
      // drawer: const BaseDrawer(),
      // appBar: AppBarHome(
      //   filterClick: _filterClick,
      //   canSearch: true,
      // ),
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
            ScreenTitle(
              title: "Insider Trading",
              subTitle: provider.textRes?.subTitle,
              optionalWidget: GestureDetector(
                onTap: _filterClick,
                child: const Icon(
                  Icons.filter_alt,
                  color: ThemeColors.accent,
                ),
              ),
            ),
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
    );
  }
}
