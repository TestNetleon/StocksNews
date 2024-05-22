import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/providers/watchlist_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer_copy.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist_container.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/login_error.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class WatchList extends StatefulWidget {
  static const path = "WatchList";
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchListState();
}

//
class _WatchListState extends State<WatchList> {
  bool userPresent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      UserProvider provider = context.read<UserProvider>();
      if (provider.user != null) {
        context.read<WatchlistProvider>().getData(showProgress: false);
      }
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Stock WatchList"},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    WatchlistProvider provider = context.watch<WatchlistProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    return BaseContainer(
      drawer: const BaseDrawer(),
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
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
            const ScreenTitle(title: "Stock Watchlist"),
            // TextInputFieldSearch(
            //   hintText: "Add ticker in watchlist",
            //   onChanged: (text) {},
            // ),
            userProvider.user == null
                ? const Expanded(child: LoginError(state: "watchList"))
                : Expanded(
                    child: BaseUiContainer(
                      isLoading: provider.isLoading && provider.data == null,
                      hasData:
                          provider.data != null && provider.data!.isNotEmpty,
                      error: provider.error,
                      errorDispCommon: true,
                      showPreparingText: true,
                      onRefresh: () => provider.getData(showProgress: false),
                      child: const WatchlistContainer(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
