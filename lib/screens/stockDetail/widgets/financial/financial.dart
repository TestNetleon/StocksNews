import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../widgets/disclaimer_widget.dart';
import 'item.dart';
import 'tab.dart';

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
      // if (provider.sdFinancialRes == null) {
      //   _callApi();
      // }
      if (provider.sdFinancialArray == null) {
        _callApi();
      }
    });
  }

  _callApi({reset = false, showProgress = false}) {
    context.read<StockDetailProviderNew>().getFinancialData(
          symbol: widget.symbol,
          reset: reset,
        );
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      hasData:
          !provider.isLoadingFinancial && provider.sdFinancialArray != null,
      isLoading: provider.isLoadingFinancial,
      showPreparingText: true,
      error: provider.errorFinancial,
      isFull: true,
      onRefresh: () => _callApi(reset: true, showProgress: true),
      child: CommonRefreshIndicator(
        onRefresh: () async => _callApi(reset: true, showProgress: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              children: [
                const SdCommonHeading(),
                const Divider(
                  color: ThemeColors.white,
                  thickness: 2,
                  height: 20,
                ),
                const SpacerVertical(height: 15),
                Visibility(
                  visible: provider.extraFinancial?.type != null,
                  child: SdFinancialTabs(
                    tabs: provider.extraFinancial?.type,
                    onChange: (index) =>
                        provider.changeTabType(index, symbol: widget.symbol),
                    selectedIndex: provider.typeIndex,
                  ),
                ),
                Visibility(
                  visible: provider.extraFinancial?.period != null,
                  child: SdFinancialTabs(
                    tabs: provider.extraFinancial?.period,
                    onChange: (index) =>
                        provider.changePeriodType(index, symbol: widget.symbol),
                    selectedIndex: provider.periodIndex,
                  ),
                ),
                ListView.separated(
                    padding: const EdgeInsets.only(top: 0, bottom: 15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // FinanceStatement? data =
                      //     provider.sdFinancsialRes?.financeStatement?[index];
                      Map<String, dynamic>? data =
                          provider.sdFinancialArray?[index];

                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ThemeColors.greyBorder.withOpacity(0.3)),
                        child: SdFinancialItem(
                          data: data,
                          index: index,
                          openIndex: openIndex,
                          onCardTapped: changeOpenIndex,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SpacerVertical(height: 15);
                    },
                    itemCount: provider.sdFinancialArray?.length ?? 0),
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
