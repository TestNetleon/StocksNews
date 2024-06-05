import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_industries_res.dart';
import 'package:stocks_news_new/providers/trending_industries.dart';
import 'package:stocks_news_new/screens/trendingIndustries/graph/graph.dart';
import 'package:stocks_news_new/screens/trendingIndustries/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:stocks_news_new/widgets/loading.dart';

import '../../utils/theme.dart';

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
      // context.read<TrendingIndustriesProvider>().getData();
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          Dimen.padding.sp,
          Dimen.padding.sp,
          0,
        ),
        child: provider.isLoading
            ? const Loading()

            // ? const Loading()
            : (provider.data == null || provider.data?.isNotEmpty == true) &&
                    !provider.isLoading
                ? Center(
                    child: ErrorDisplayWidget(
                      error: provider.error,
                      onRefresh: provider.getData,
                    ),
                  )
                : CommonRefreshIndicator(
                    onRefresh: provider.getData,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: provider.textRes?.subTitle != '',
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20.sp),
                              child: Text(
                                provider.textRes?.subTitle ?? "",
                                style: stylePTSansRegular(
                                    fontSize: 13, color: ThemeColors.greyText),
                              ),
                            ),
                          ),
                          provider.data != null &&
                                  provider.data?.isNotEmpty == true
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
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
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
