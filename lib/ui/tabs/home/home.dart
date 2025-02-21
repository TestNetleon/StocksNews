import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../base/scaffold.dart';
import 'home_premium.dart';
import 'home_trending.dart';
import 'news/news.dart';

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
            // BaseButton(
            //   onPressed: () async {
            //     try {
            //       // RevenueCatManager.instance.initialize();
            //       Offerings offerings = await Purchases.getOfferings();
            //       Offering? offering1 =
            //           offerings.getOffering('Stocks.News Offerings');
            //       Offering? offering2 =
            //           offerings.getOffering('Stocks.News Offerings Annual');
            //       Utils().showLog('1----${offering1?.availablePackages.first}');
            //       Utils().showLog('2----${offering2?.availablePackages.first}');
            //       await Purchases.purchasePackage(
            //           offering1!.availablePackages.first);
            //       // List<StoreProduct> prod =
            //       //     await Purchases.getProducts(['monthly_basic']);
            //       // print('Data=>length--${prod.length}');
            //       // for (var i in prod) {
            //       //   Utils().showLog('Data=> ${i.identifier}');
            //       // }
            //       // showGlobalProgressDialog();
            //       // await Purchases.purchaseStoreProduct(prod.first);
            //     } catch (e) {
            //       if (e is PlatformException) {
            //         PurchasesErrorCode errorCode =
            //             PurchasesErrorHelper.getErrorCode(e);
            //         if (errorCode ==
            //             PurchasesErrorCode.purchaseCancelledError) {
            //           print("User canceled the purchase.");
            //         } else {
            //           print("Purchase failed: ${e.message}");
            //         }
            //       } else {
            //         print("Unknown error: $e");
            //       }
            //     }
            //   },
            // ),

            HomeTrendingIndex(),
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
