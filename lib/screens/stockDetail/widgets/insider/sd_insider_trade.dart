import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/insider/sd_congressional_item.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/insider/sd_insider_item.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_faq.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../modals/stockDetailRes/earnings.dart';
import '../../../../modals/stockDetailRes/sd_insider_res.dart';
import '../../../../widgets/custom_gridview.dart';
import '../sd_top.dart';

class SdInsiderTrade extends StatefulWidget {
  final String? symbol;
  const SdInsiderTrade({super.key, this.symbol});

  @override
  State<SdInsiderTrade> createState() => _SdInsiderTradeState();
}

class _SdInsiderTradeState extends State<SdInsiderTrade> {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        StockDetailProviderNew provider =
            context.read<StockDetailProviderNew>();
        if (provider.sdInsiderTradeRes == null) {
          _callApi();
        }
      });
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getInsiderTradeData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      isFull: true,
      hasData:
          !provider.isLoadingInsiderTrade && provider.sdInsiderTradeRes != null,
      isLoading: provider.isLoadingInsiderTrade,
      showPreparingText: true,
      error: provider.errorInsiderTrade,
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
                CustomGridView(
                  length: provider.sdInsiderTradeRes?.top.length ?? 0,
                  paddingVerticle: 8,
                  getChild: (index) {
                    SdTopRes? top = provider.sdInsiderTradeRes?.top[index];
                    return SdTopCard(top: top);
                  },
                ),
                const SpacerVertical(height: 10),
                ScreenTitle(
                  title: "${provider.sdInsiderTradeRes?.title?.insiderTrade}",
                ),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    InsiderDatum? data =
                        provider.sdInsiderTradeRes?.insiderData[index];
                    if (data == null) {
                      return const SizedBox();
                    }
                    return SdInsiderItem(
                      index: index,
                      data: data,
                    );

                    // if (index == 0) {
                    //   return SdInsiderTradeItemSeparated(
                    //     news: data,
                    //   );
                    // }
                    // return SdInsiderTradeItem(
                    //   news: data,
                    // );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 20.sp,
                    );
                  },
                  itemCount:
                      provider.sdInsiderTradeRes?.insiderData.length ?? 0,
                ),
                const SpacerVertical(height: 10),
                ScreenTitle(
                  title: "${provider.sdInsiderTradeRes?.title?.congressTrade}",
                ),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    CongressionalDatum? data =
                        provider.sdInsiderTradeRes?.congressionalData[index];
                    if (data == null) {
                      return const SizedBox();
                    }
                    return SdCongressionalItem(
                      index: index,
                      data: data,
                    );

                    // if (index == 0) {
                    //   return SdInsiderTradeItemSeparated(
                    //     news: data,
                    //   );
                    // }
                    // return SdInsiderTradeItem(
                    //   news: data,
                    // );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: ThemeColors.greyBorder,
                      height: 20.sp,
                    );
                  },
                  itemCount:
                      provider.sdInsiderTradeRes?.congressionalData.length ?? 0,
                ),
                const SpacerVertical(height: 10),
                ScreenTitle(
                  title: "${provider.sdInsiderTradeRes?.title?.faq}",
                ),
                ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      FaQsRes? data = provider.sdInsiderTradeRes?.faq[index];

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
                    itemCount: provider.sdInsiderTradeRes?.faq.length ?? 0)
                // GridView.builder(
                //   padding: EdgeInsets.zero,
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     crossAxisSpacing: 10.0,
                //     mainAxisSpacing: 10.0,
                //   ),
                //   itemBuilder: (context, index) {
                //     return Container(
                //       color: ThemeColors.gradientLight,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             textAlign: TextAlign.center,
                //             "${provider.sdInsiderTradeRes?.top[index].key}",
                //             style: stylePTSansRegular(fontSize: 12),
                //           ),
                //           Text(
                //             textAlign: TextAlign.center,
                //             "${provider.sdInsiderTradeRes?.top[index].value}",
                //             style: stylePTSansRegular(fontSize: 20),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                //   itemCount: provider.sdInsiderTradeRes?.top.length ?? 0,
                // ),

                ,
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
