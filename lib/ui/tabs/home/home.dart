import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/ui/AdManager/service.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/home/blogItem/blog_item_home.dart';
import 'package:stocks_news_new/ui/tabs/home/slider/index.dart';
import 'package:stocks_news_new/ui/tabs/more/index.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../base/scaffold.dart';
import 'extra/affiliate_box.dart';
import 'home_premium.dart';
import 'popularStocks/index.dart';
import 'scanner/index.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({super.key});

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomeManager>(
      builder: (context, manager, child) {
        // affiliateClosed = false;
        return BaseScaffold(
          drawer: MoreIndex(),
          appBar: BaseAppBar(
            showNotification: true,
            showSearch: true,
            onNotificationEventCall:
                EventsService.instance.notificationsHomePage,
            onSearchEventCall: EventsService.instance.searchHomePage,
          ),
          body: BaseLoaderContainer(
            isLoading: manager.isLoading,
            hasData: manager.data != null && !manager.isLoading,
            showPreparingText: true,
            error: manager.error,
            onRefresh: manager.getHomeData,
            child: BaseScroll(
              onRefresh: manager.getHomeData,
              margin: EdgeInsets.zero,
              children: [
                // Visibility(
                //   visible: kDebugMode,
                //   child: BaseButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => SplashFirstTime(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                Visibility(
                  visible: !affiliateClosed,
                  child: HomeAffiliateBox(),
                ),
                const BlogHomeIndex(),
                HomeTopNewsSlider(),
                Visibility(
                  visible: manager.data?.scannerPort?.showOnHome == true,
                  child: Container(
                    padding: const EdgeInsets.only(top: Pad.pad14),
                    margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseHeading(
                          title: 'Market Scanner',
                          titleStyle: styleBaseBold(fontSize: 22),
                          viewMore: () {
                            Navigator.pushNamed(context, Tabs.path, arguments: {
                              'index': 1,
                            });
                          },
                          viewMoreText: 'View All',
                        ),
                        HomeScannerIndex(),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: manager.data?.adManagers?.data?.place1 != null,
                  child: AdManagerIndex(
                    places: AdPlaces.place1,
                    data: manager.data?.adManagers?.data?.place1,
                  ),
                ),
                HomePopularStocks(),
                VisibilityDetector(
                  key: const Key('home_premium_visibility'),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction > 0.1 &&
                        !manager.homePremiumLoaded) {
                      manager.setPremiumLoaded(true);
                      manager.getHomePremiumData();
                    }
                  },
                  child: BaseLoaderContainer(
                    isLoading: manager.isLoadingHomePremium,
                    hasData: manager.homePremiumData != null,
                    showPreparingText: true,
                    removeErrorWidget: true,
                    placeholder: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                    child: HomePremiumIndex(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
