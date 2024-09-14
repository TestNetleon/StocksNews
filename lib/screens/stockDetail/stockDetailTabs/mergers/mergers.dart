import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/mergers_res.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/mergers/mergers_item.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdMergers extends StatefulWidget {
  final String? symbol;
  const SdMergers({super.key, this.symbol});

  @override
  State<SdMergers> createState() => _SdMergersState();
}

class _SdMergersState extends State<SdMergers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
      if (provider.sdMergersRes == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getMergersData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;

    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingMergers && provider.sdMergersRes != null,
      isLoading: provider.isLoadingMergers,
      showPreparingText: true,
      error: provider.errorMergers,
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
                  color: ThemeColors.white,
                  height: 20,
                  thickness: 2,
                ),
                const SpacerVertical(height: 20),
                Visibility(
                  visible:
                      provider.sdMergersRes?.mergersList?.isNotEmpty == true &&
                          provider.sdMergersRes?.mergersList != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenTitle(
                        title: "Recent ${keyStats?.symbol} Mergers",
                      ),
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          MergersList? data =
                              provider.sdMergersRes?.mergersList?[index];
                          if (data == null) {
                            return const SizedBox();
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (index == 0)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          maxLines: 1,
                                          "Symbol",
                                          style: stylePTSansRegular(
                                            fontSize: 12,
                                            color: ThemeColors.greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: ThemeColors.greyBorder,
                                      height: 20,
                                      thickness: 1,
                                    )
                                  ],
                                ),
                              SdMergersItem(
                                data: data,
                                isOpen: provider.openIndex == index,
                                onTap: () {
                                  provider.setOpenIndex(
                                    provider.openIndex == index ? -1 : index,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: ThemeColors.greyBorder,
                            height: 20,
                          );
                        },
                        itemCount:
                            provider.sdMergersRes?.mergersList?.length ?? 0,
                      ),
                    ],
                  ),
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
