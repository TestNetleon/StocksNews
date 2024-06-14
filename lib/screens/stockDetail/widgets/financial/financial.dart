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

import '../../../../modals/stockDetailRes/financial.dart';
import 'item.dart';

class SdFinancial extends StatefulWidget {
  final String? symbol;
  const SdFinancial({super.key, this.symbol});

  @override
  State<SdFinancial> createState() => _SdFinancialState();
}

class _SdFinancialState extends State<SdFinancial> {
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
      if (provider.sdFinancialRes == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getFinancialData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      hasData: !provider.isLoadingFinancial && provider.sdFinancialRes != null,
      isLoading: provider.isLoadingFinancial,
      showPreparingText: true,
      error: provider.errorFinancial,
      isFull: true,
      onRefresh: _callApi,
      child: CommonRefreshIndicator(
        onRefresh: () async => _callApi(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              children: [
                const SdCommonHeading(),
                const Divider(
                  color: ThemeColors.greyBorder,
                  height: 20,
                ),
                ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      FinanceStatement? data =
                          provider.sdFinancialRes?.financeStatement?[index];
                      return SdFinancialItem(
                        data: data,
                        index: index,
                        openIndex: openIndex,
                        onCardTapped: changeOpenIndex,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SpacerVertical(height: 15);
                    },
                    itemCount:
                        provider.sdFinancialRes?.financeStatement?.length ?? 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
