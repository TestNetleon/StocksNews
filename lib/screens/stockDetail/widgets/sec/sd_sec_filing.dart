import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/sec_filing_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sec/sd_sec_filing_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdSecFilings extends StatefulWidget {
  final String symbol;
  const SdSecFilings({super.key, required this.symbol});

  @override
  State<SdSecFilings> createState() => _SdSecFilingsState();
}

class _SdSecFilingsState extends State<SdSecFilings> {
  // int openIndex = -1;

  // void changeOpenIndex(int index) {
  //   setState(() {
  //     openIndex = openIndex == index ? -1 : index;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callApi();
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getSecFilingData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingSec && provider.secRes != null,
      isLoading: provider.isLoadingSec,
      showPreparingText: true,
      error: provider.errorSec,
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
                  color: ThemeColors.greyBorder,
                  height: 20,
                ),
                // ScreenTitle(
                //   title: "${provider.tabRes?.keyStats?.name} Earnings - FAQs",
                // ),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    SecFiling? data = provider.secRes?.secFilings[index];
                    return SdSecFilingItem(
                      data: data,
                      index: index,
                      onCardTapped: () {},
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SpacerVertical(height: 10);
                  },
                  itemCount: provider.secRes?.secFilings.length ?? 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
