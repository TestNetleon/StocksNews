import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sd_social_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdSocialActivities extends StatefulWidget {
  final String? symbol;
  const SdSocialActivities({super.key, this.symbol});

  @override
  State<SdSocialActivities> createState() => _SdSocialActivitiesState();
}

class _SdSocialActivitiesState extends State<SdSocialActivities> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callApi();
    });
  }

  _callApi() {
    context.read<StockDetailProviderNew>().getSocialData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    SdSocialRes? data = provider.socialRes;
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingSocial && provider.socialRes != null,
      isLoading: provider.isLoadingSocial,
      showPreparingText: true,
      error: provider.errorSocial,
      onRefresh: _callApi,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          _callApi();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SdCommonHeading(),
                const Divider(
                  color: ThemeColors.greyBorder,
                  height: 20,
                ),
                ScreenTitle(
                  title: "${provider.socialRes?.mentionText} - FAQs",
                ),
                SizedBox(
                  height: 130.sp,
                  width: 130.sp,
                  child: PieChart(
                    PieChartData(
                      sections: List.generate(
                        data?.allMention.length ?? 0,
                        (index) => PieChartSectionData(
                          color: Color(int.parse(
                              'FF${hexColors[index].replaceFirst('#', '')}',
                              radix: 16)),
                          value:
                              data?.allMention[index].mentionCount?.toDouble(),
                          title: '',
                          radius: 6,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 5.sp,
                      centerSpaceRadius: 60.sp,
                    ),
                  ),
                ),
                const SpacerVertical(),
                ListView.separated(
                  padding: EdgeInsets.only(top: 20.sp),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      color: Color(int.parse(
                          'FF${hexColors[index].replaceFirst('#', '')}',
                          radix: 16)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data?.allMention[index].website ?? "",
                            style: stylePTSansBold(fontSize: 14),
                          ),
                          const SpacerHorizontal(width: 20),
                          Text(
                            "${data?.allMention[index].mentionCount}",
                            style: stylePTSansBold(fontSize: 14),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SpacerVertical(height: 12);
                  },
                  itemCount: data?.allMention.length ?? 0,
                ),
                if (provider.extra?.disclaimer != null)
                  DisclaimerWidget(
                    data: provider.extra!.disclaimer!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
