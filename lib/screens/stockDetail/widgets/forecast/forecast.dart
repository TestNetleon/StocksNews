import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/analyst_forecast.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/forecast/stock_rating.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_faq.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdForecast extends StatefulWidget {
  final String? symbol;
  const SdForecast({super.key, this.symbol});

  @override
  State<SdForecast> createState() => _SdForecastState();
}

class _SdForecastState extends State<SdForecast> {
  int openIndex = -1;

  void changeOpenIndex(int index) {
    setState(() {
      openIndex = openIndex == index ? -1 : index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
      if (provider.forecastRes == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getForecastData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingForecast && provider.forecastRes != null,
      isLoading: provider.isLoadingForecast,
      showPreparingText: true,
      error: provider.errorForecast,
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
                const ScreenTitle(
                  title: "Recent Analyst Forecasts and Stock Ratings",
                ),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    AnalystForecast? data =
                        provider.forecastRes?.analystForecasts?[index];

                    return SdStocksRating(
                      isOpen: provider.openIndex == index,
                      onTap: () {
                        provider.setOpenIndex(
                          provider.openIndex == index ? -1 : index,
                        );
                      },
                      data: data,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 20.sp,
                    );
                  },
                  itemCount:
                      provider.forecastRes?.analystForecasts?.length ?? 0,
                ),
                ScreenTitle(
                  title: "${provider.tabRes?.keyStats?.name} - FAQs",
                ),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    FaQsRes? data = provider.forecastRes?.faq?[index];

                    return SdFaqCard(
                      data: data,
                      index: index,
                      openIndex: openIndex,
                      onCardTapped: changeOpenIndex,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SpacerVertical(height: 10);
                  },
                  itemCount: provider.forecastRes?.faq?.length ?? 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
