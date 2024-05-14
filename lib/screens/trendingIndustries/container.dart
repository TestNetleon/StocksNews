import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_industries_res.dart';
import 'package:stocks_news_new/providers/trending_industries.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/trendingIndustries/graph/graph.dart';
import 'package:stocks_news_new/screens/trendingIndustries/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TrendingIndustriesContainer extends StatefulWidget {
  const TrendingIndustriesContainer({super.key});

  @override
  State<TrendingIndustriesContainer> createState() =>
      _TrendingIndustriesContainerState();
}

//
class _TrendingIndustriesContainerState
    extends State<TrendingIndustriesContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TrendingIndustriesProvider>().getData();
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Trending Industries"},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    TrendingIndustriesProvider provider =
        context.watch<TrendingIndustriesProvider>();
    return BaseContainer(
      appBar: const AppBarHome(
          isPopback: true, showTrailing: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: Column(
          children: [
            ScreenTitle(
              title: "Trending Industries",
              subTitle: provider.textRes?.subTitle,
            ),
            Expanded(
              child: provider.isLoading
                  ? const Loading()
                  : provider.data != null && provider.data?.isNotEmpty == true
                      ? RefreshIndicator(
                          onRefresh: provider.getData,
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 16.sp),
                            itemBuilder: (context, index) {
                              TrendingIndustriesRes? data =
                                  provider.data?[index];

                              if (data == null) {
                                return const SizedBox();
                              }
                              if (index == 0) {
                                return Column(
                                  children: [
                                    const TrendingIndustriesGraph(),
                                    TrendingIndustryItem(data: data),
                                  ],
                                );
                              }

                              return TrendingIndustryItem(data: data);
                            },
                            separatorBuilder: (context, index) {
                              // return const SpacerVertical(height: 10);
                              return Divider(
                                color: ThemeColors.greyBorder,
                                height: 12.sp,
                              );
                            },
                            itemCount: provider.data?.length ?? 0,
                          ),
                        )
                      : (provider.data == null ||
                                  provider.data?.isEmpty == true) &&
                              !provider.isLoading
                          ? Center(
                              child: ErrorDisplayNewWidget(
                                error: provider.error,
                                onRefresh: provider.getData,
                              ),
                            )
                          : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
