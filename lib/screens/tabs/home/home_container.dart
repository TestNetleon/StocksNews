import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/home_partial_loading_widget.dart';
// ignore: unused_import
import 'package:stocks_news_new/screens/tabs/home/widgets/myAlerts/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/myAlerts/index_copy.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:upgrader/upgrader.dart';
import '../../../modals/home_insider_res.dart';
import '../../../utils/colors.dart';
import '../../../widgets/custom/refer.dart';
import '../../../widgets/custom/refresh_indicator.dart';
import '../news/news_item.dart';
import 'widgets/home_inner_tabs.dart';
import 'widgets/sliderNews/slider.dart';
import 'widgets/stockBuzz/index.dart';
import 'widgets/topPlaid/index.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    if (!provider.isLoadingSlider &&
        provider.statusSlider != Status.ideal &&
        !provider.isLoadingHomeAlert &&
        provider.statusHomeAlert != Status.ideal &&
        !provider.isLoadingTrending &&
        provider.statusTrending != Status.ideal &&
        provider.homeSliderRes == null &&
        provider.homeAlertData == null &&
        provider.homeTrendingRes == null) {
      return ErrorDisplayWidget(
        error: Const.errSomethingWrong,
        onRefresh: () => provider.refreshData(null),
      );
    }
    return CommonRefreshIndicator(
      onRefresh: () async {
        provider.refreshData(null);
      },
      child: DefaultTextStyle(
        style: styleGeorgiaBold(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Image.asset(
              //   "assets/images/progressF.gif",
              //   height: 100,
              //   width: 100,
              // ),
              // const InAppPurchaseUI(),

              // ThemeButton(
              //   text: "Subscription",
              //   onPressed: () {
              //     openUrl("https://apps.apple.com/account/subscriptions");
              //   },
              // ),

              const HomeTopNewsSlider(),
              Visibility(
                visible: provider.extra?.referral?.shwReferral ?? false,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(
                      Dimen.padding, 20, Dimen.padding, Dimen.padding),
                  child: ReferApp(),
                ),
              ),
              const SpacerVertical(height: Dimen.padding),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimen.padding.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!((provider.homeTrendingRes?.popular.isEmpty == true ||
                            provider.homeTrendingRes?.popular == null ||
                            provider.homeTrendingRes == null) &&
                        provider.statusTrending != Status.loading))
                      const StockInBuzz(),
                    const TopPlaidIndex(),
                    const HomeMyAlerts(),
                    Visibility(
                      visible: provider.extra?.showPortfolio ?? false,
                      child: HomePartialLoading(
                        loading: provider.isLoadingPortfolio,
                        loadingWidget: Container(
                          height: 110,
                          margin: const EdgeInsets.fromLTRB(
                              0, 20, 0, Dimen.padding),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 23, 23, 23),
                                Color.fromARGB(255, 48, 48, 48),
                              ],
                            ),
                            // color: Colors.black,
                          ),
                        ),
                        onRefresh: () {
                          provider.getHomePortfolio();
                        },
                        child: const PlaidHome(),
                      ),
                    ),
                    HomePartialLoading(
                      loadingWidget: const Loading(),
                      loading: provider.isLoadingTrending,
                      onRefresh: provider.refreshWithCheck,
                      child: const HomeInnerTabs(),
                    ),
                    Visibility(
                      visible: !provider.isLoadingTrending &&
                          (provider.homeTrendingRes?.trendingNews?.isNotEmpty ==
                                  true &&
                              provider.homeTrendingRes?.trendingNews != null),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: ScreenTitle(
                              title: provider.homeTrendingRes?.text?.news ?? "",
                            ),
                          ),
                          ListView.separated(
                            itemCount: provider
                                    .homeTrendingRes?.trendingNews?.length ??
                                0,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 12.sp),
                            itemBuilder: (context, index) {
                              News? data = provider
                                  .homeTrendingRes?.trendingNews?[index];
                              return NewsItem(
                                news: News(
                                  title: data?.title ?? "",
                                  image: data?.image ?? "",
                                  authors: data?.authors,
                                  postDateString: data?.postDateString,
                                  slug: data?.slug,
                                ),
                                showCategory: false,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                color: ThemeColors.greyBorder,
                                height: 15,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.extra?.disclaimer != null)
                DisclaimerWidget(
                  data: provider.extra!.disclaimer!,
                  padding: const EdgeInsets.all(16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
