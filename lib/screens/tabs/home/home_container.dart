import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/benefits/benefits_affiliate.dart';
import 'package:stocks_news_new/screens/tabs/home/membership/membership.dart';
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
import 'package:stocks_news_new/widgets/theme_button_small.dart';
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
        await provider.refreshData(null);
      },
      child: DefaultTextStyle(
        style: styleGeorgiaBold(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const HomeTopNewsSlider(),
              Visibility(
                visible: provider.extra?.referral?.shwReferral ?? false,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(
                    Dimen.padding,
                    Dimen.homeSpacing,
                    Dimen.padding,
                    0,
                  ),
                  child: const ReferApp(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: Dimen.homeSpacing),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NewMembership(),
                        ),
                      );
                    },
                    child: const Text('Click')),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: Dimen.padding.sp,
                  right: Dimen.padding.sp,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!((provider.homeTrendingRes?.popular.isEmpty == true ||
                            provider.homeTrendingRes?.popular == null ||
                            provider.homeTrendingRes == null) &&
                        provider.statusTrending != Status.loading))
                      Container(
                        margin: const EdgeInsets.only(top: Dimen.homeSpacing),
                        child: const StockInBuzz(),
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: Dimen.homeSpacing),
                      child: const TopPlaidIndex(),
                    ),
                    Visibility(
                      visible: provider.homeSliderRes?.affiliateAdv != null,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BenefitsMarketing(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: Dimen.homeSpacing),
                          decoration: BoxDecoration(
                            // color: Colors.transparent,
                            border: Border.all(
                              color: ThemeColors.greyBorder.withOpacity(0.4),
                            ),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.2, 0.65],
                              colors: [
                                Color.fromARGB(255, 14, 41, 0),
                                // ThemeColors.greyBorder,
                                Color.fromARGB(255, 0, 0, 0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HtmlWidget(
                                    provider.homeSliderRes?.affiliateAdv
                                            ?.title ??
                                        "",
                                    textStyle: stylePTSansBold(
                                        color: ThemeColors.white, fontSize: 40),
                                  ),
                                  const SpacerVertical(height: 5),
                                  HtmlWidget(
                                    "${provider.homeSliderRes?.affiliateAdv?.subTitle}",
                                    textStyle: stylePTSansRegular(
                                        color: ThemeColors.white, fontSize: 18),
                                  ),
                                  const SpacerVertical(
                                      height: Dimen.itemSpacing),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        // left: Dimen.homeSpacing,
                                        // right: Dimen.homeSpacing,
                                        // bottom: Dimen.padding,
                                        ),
                                    alignment: Alignment.centerLeft,
                                    child: ThemeButtonSmall(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const BenefitsMarketing(),
                                          ),
                                        );
                                      },
                                      textSize: 15,
                                      fontBold: true,
                                      iconFront: true,
                                      // icon: Icons.lock,
                                      radius: 30,
                                      mainAxisSize: MainAxisSize.min,
                                      text: "Learn how",
                                      // showArrow: false,
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Opacity(
                                  opacity: .2,
                                  child: Image.asset(
                                    Images.affWhite,
                                    height: 150.0,
                                    width: 150.0,
                                    color: ThemeColors.themeGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: Dimen.homeSpacing),
                      child: const HomeMyAlerts(),
                    ),
                    Visibility(
                      visible: provider.extra?.showPortfolio ?? false,
                      child: Container(
                        margin: const EdgeInsets.only(top: Dimen.homeSpacing),
                        // color: Colors.red,
                        child: HomePartialLoading(
                          loading: provider.isLoadingPortfolio,
                          loadingWidget: Container(
                            height: 110,
                            // margin: const EdgeInsets.fromLTRB(
                            //   0,
                            //   20,
                            //   0,
                            //   Dimen.padding,
                            // ),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: Dimen.homeSpacing),
                      child: HomePartialLoading(
                        loadingWidget: const Loading(),
                        loading: provider.isLoadingTrending,
                        onRefresh: provider.refreshWithCheck,
                        child: const HomeInnerTabs(),
                      ),
                    ),
                    Visibility(
                      visible: !provider.isLoadingTrending &&
                          (provider.homeTrendingRes?.trendingNews?.isNotEmpty ==
                                  true &&
                              provider.homeTrendingRes?.trendingNews != null),
                      child: Container(
                        margin: const EdgeInsets.only(top: Dimen.homeSpacing),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: ScreenTitle(
                                title:
                                    provider.homeTrendingRes?.text?.news ?? "",
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
