import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_industries_res.dart';
import 'package:stocks_news_new/providers/trending_industries.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/trendingIndustries/graph/graph.dart';
import 'package:stocks_news_new/screens/trendingIndustries/item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class TrendingIndustriesContainer extends StatefulWidget {
  const TrendingIndustriesContainer({super.key});

  @override
  State<TrendingIndustriesContainer> createState() =>
      _TrendingIndustriesContainerState();
}

class _TrendingIndustriesContainerState
    extends State<TrendingIndustriesContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TrendingIndustriesProvider>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    TrendingIndustriesProvider provider =
        context.watch<TrendingIndustriesProvider>();
    return BaseContainer(
      appbar: const AppBarHome(
          isPopback: true, showTrailing: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            Dimen.padding.sp, Dimen.padding.sp, Dimen.padding.sp, 0),
        child: Column(
          children: [
            const ScreenTitle(title: "Trending Industries"),
            Expanded(
              child: provider.isLoading
                  ? Center(
                      child: Text(
                        "We are preparing …",
                        style: styleGeorgiaRegular(
                          color: Colors.white,
                        ),
                      ),
                    )
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
                              return const SpacerVerticel(height: 10);
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
