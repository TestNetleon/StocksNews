import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_faq.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_top.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdEarnings extends StatefulWidget {
  final String? symbol;
  const SdEarnings({super.key, this.symbol});

  @override
  State<SdEarnings> createState() => _SdEarningsState();
}

class _SdEarningsState extends State<SdEarnings> {
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
      if (provider.earnings == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getEarningsData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingEarning && provider.earnings != null,
      isLoading: provider.isLoadingEarning,
      showPreparingText: true,
      error: provider.errorEarning,
      onRefresh: _callApi,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          _callApi();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SdCommonHeading(),
                CustomGridView(
                  length: provider.earnings?.top?.length ?? 0,
                  paddingVerticle: 8,
                  getChild: (index) {
                    SdTopRes? top = provider.earnings?.top?[index];
                    return SdTopCard(top: top);
                  },
                ),
                const Divider(
                  color: ThemeColors.greyBorder,
                  height: 20,
                ),
                ScreenTitle(
                  title: "${provider.tabRes?.keyStats?.name} Earnings - FAQs",
                ),
                ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      FaQsRes? data = provider.earnings?.faq?[index];

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
                    itemCount: provider.earnings?.faq?.length ?? 0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
