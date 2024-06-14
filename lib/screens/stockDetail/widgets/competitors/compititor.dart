import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/competitor.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/competitors/compatitor_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdCompetitor extends StatefulWidget {
  final String symbol;
  const SdCompetitor({super.key, required this.symbol});

  @override
  State<SdCompetitor> createState() => _SdCompetitorState();
}

class _SdCompetitorState extends State<SdCompetitor> {
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
      if (provider.competitorRes == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getCompetitorData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingCompetitor && provider.competitorRes != null,
      isLoading: provider.isLoadingCompetitor,
      showPreparingText: true,
      error: provider.errorCompetitor,
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
                const Divider(
                  color: ThemeColors.white,
                  thickness: 2,
                  height: 20,
                ),

                // ScreenTitle(
                //   title: "${provider.tabRes?.keyStats?.name} Earnings - FAQs",
                // ),
                ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    TickerList? data =
                        provider.competitorRes?.tickerList[index];
                    return SdCompetitorItem(
                      data: data,
                      isOpen: openIndex == index,
                      onTap: () => changeOpenIndex(index),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: ThemeColors.greyBorder,
                      height: 20,
                    );
                  },
                  itemCount: provider.competitorRes?.tickerList.length ?? 0,
                ),
                const SpacerVertical(height: 10),
                if (provider.extraCompetitor?.disclaimer != null)
                  DisclaimerWidget(data: provider.extraCompetitor!.disclaimer!),
                const SpacerVertical(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
