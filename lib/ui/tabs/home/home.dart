import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/models/tools.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/home/blogItem/blog_item_home.dart';
import 'package:stocks_news_new/ui/tabs/home/insiderTrades/insider_trades.dart';
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
    MyHomeManager manager = context.watch<MyHomeManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        showNotification: true,
        showSearch: true,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoading,
        hasData: manager.data != null && !manager.isLoading,
        showPreparingText: true,
        error: manager.error,
        onRefresh: manager.getHomeData,
        child: BaseScroll(
          onRefresh: manager.getHomeData,
          children: [
            const BlogHomeIndex(),
            HomeTrendingIndex(),
            Visibility(
              visible: manager.data?.scannerPort?.showOnHome == true,
              child: Padding(
                padding: const EdgeInsets.only(top: Pad.pad24),
                child: Column(
                  children: [
                    BaseHeading(
                      title: 'Market Scanner',
                      viewMoreText: 'Go to Scanner',
                      viewMore: () {
                        ToolsManager manager = context.read<ToolsManager>();
                        manager.startNavigation(ToolsEnum.scanner);
                      },
                    ),
                    HomeScannerIndex(),
                  ],
                ),
              ),
            ),
            HomeInsiderTradesIndex(
              insiderData: manager.data?.insiderTrading,
            ),
            VisibilityDetector(
              key: const Key('home_premium_visibility'),
              onVisibilityChanged: (VisibilityInfo info) {
                if (info.visibleFraction > 0.1 && !manager.homePremiumLoaded) {
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
                  child: CircularProgressIndicator(
                    color: ThemeColors.black,
                  ),
                ),
                onRefresh: () {},
                child: HomePremiumIndex(),
              ),
            ),
            HomeNewsIndex(newsData: manager.data?.recentNews),
          ],
        ),
      ),
    );
  }
}
