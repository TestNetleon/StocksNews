import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/home/blogItem/blog_item_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../base/scaffold.dart';
import 'home_premium.dart';
import 'home_trending.dart';
import 'news/news.dart';
import 'scanner/index.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({super.key});

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  @override
  Widget build(BuildContext context) {
    MyHomeManager provider = context.watch<MyHomeManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        showNotification: true,
        showSearch: true,
      ),
      body: BaseLoaderContainer(
        isLoading: provider.isLoading,
        hasData: provider.data != null && !provider.isLoading,
        showPreparingText: true,
        error: provider.error,
        onRefresh: provider.getHomeData,
        child: BaseScroll(
          onRefresh: provider.getHomeData,
          children: [
            // Text(
            //   'AAPL',
            //   style: TextStyle(
            //     fontFamily: 'Roboto',
            //     // fontFamily: Fonts.georgia,
            //     // fontFamily: Fonts.ptSans,
            //     // fontFamily: Fonts.georgia,
            //     color: ThemeColors.black,
            //     fontSize: 600,
            //     fontWeight: FontWeight.w800,
            //   ),
            // ),
            const BlogHomeIndex(),
            HomeTrendingIndex(),
            Visibility(
              visible: provider.data?.scannerPort?.showOnHome == true,
              child: Padding(
                padding: const EdgeInsets.only(top: Pad.pad24),
                child: HomeScannerIndex(),
              ),
            ),
            HomeNewsIndex(newsData: provider.data?.recentNews),
            VisibilityDetector(
              key: const Key('home_premium_visibility'),
              onVisibilityChanged: (VisibilityInfo info) {
                if (info.visibleFraction > 0.1 && !provider.homePremiumLoaded) {
                  provider.setPremiumLoaded(true);
                  provider.getHomePremiumData();
                }
              },
              child: BaseLoaderContainer(
                isLoading: provider.isLoadingHomePremium,
                hasData: provider.homePremiumData != null,
                showPreparingText: true,
                removeErrorWidget: true,
                placeholder: Center(
                    child: CircularProgressIndicator(
                  color: ThemeColors.black,
                )),
                onRefresh: () {},
                child: HomePremiumIndex(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
