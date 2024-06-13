import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/modals/stockDetailRes/ownership.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/ownership/ownership_item.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_faq.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/sd_top.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdOwnership extends StatefulWidget {
  final String symbol;
  const SdOwnership({super.key, required this.symbol});

  @override
  State<SdOwnership> createState() => _SdOwnershipState();
}

class _SdOwnershipState extends State<SdOwnership> {
  int openIndex = -1;
  int openIndexItem = -1;
  void changeOpenIndex(int index) {
    setState(() {
      openIndex = openIndex == index ? -1 : index;
    });
  }

  void changeOpenIndexItem(int index) {
    setState(() {
      openIndexItem = openIndexItem == index ? -1 : index;
    });
  }

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
        .getOwnershipData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingOwnership && provider.ownershipRes != null,
      isLoading: provider.isLoadingOwnership,
      showPreparingText: true,
      error: provider.errorOwnership,
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

                CustomGridView(
                  length: provider.ownershipRes?.top?.length ?? 0,
                  paddingVerticle: 8,
                  getChild: (index) {
                    SdTopRes? top = provider.ownershipRes?.top?[index];
                    return SdTopCard(top: top);
                  },
                ),
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
                    OwnershipList? data =
                        provider.ownershipRes?.ownershipList?[index];
                    // return Text("Hello");
                    return SdOwnershipItem(
                      data: data,
                      isOpen: openIndexItem == index,
                      // index: index,
                      onTap: () => changeOpenIndexItem(index),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: ThemeColors.greyBorder,
                      height: 20,
                    );
                  },
                  itemCount: provider.ownershipRes?.ownershipList?.length ?? 0,
                ),
                const SpacerVertical(height: 20),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    FaQsRes? data = provider.ownershipRes?.faq?[index];
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
                  itemCount: provider.ownershipRes?.faq?.length ?? 0,
                ),
                const SpacerVertical(height: 10),
                if (provider.extraOwnership?.disclaimer != null)
                  DisclaimerWidget(data: provider.extraOwnership!.disclaimer!),
                const SpacerVertical(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
