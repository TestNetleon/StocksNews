import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/top_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_table.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/mention_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class Cryptocurrencies extends StatelessWidget {
  const Cryptocurrencies({super.key});

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return BaseLoaderContainer(
      hasData: manager.billionairesRes != null,
      isLoading: manager.isLoadingCrypto,
      error: manager.error,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: manager.getCryptoCurrencies,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: manager.billionairesRes?.cryptoTweetPost != null,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Pad.pad10),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  CryptoTweetPost? item =
                      manager.billionairesRes?.cryptoTweetPost?[index];
                  return CryptoItem(
                    item: item,
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return SpacerVertical(height: Pad.pad3);
                },
                itemCount:
                    manager.billionairesRes?.cryptoTweetPost?.length ?? 0,
              ),
            ),
            Visibility(
                visible: manager.billionairesRes?.topTab != null,
                child: SpacerVertical(height: Pad.pad5)),
            Visibility(
              visible: manager.billionairesRes?.topTab != null,
              child: Column(
                children: [
                  BaseTabs(
                    data: manager.billionairesRes?.topTab?.data ?? [],
                    // textStyle: styleBaseBold(fontSize: 16, color: ThemeColors.splashBG),
                    onTap: manager.onScreenChangeInner,
                  ),
                  SpacerVertical(height: Pad.pad10),
                  if (manager.selectedInnerScreen == 0)
                    TopBilIndex(
                      topTabs: manager.billionairesRes?.topTab,
                    ),
                  if (manager.selectedInnerScreen == 1) SizedBox(),
                ],
              ),
            ),
            SpacerVertical(height: Pad.pad5),
            Visibility(
                visible:
                    manager.billionairesRes?.recentMentions?.title != null &&
                        manager.billionairesRes?.recentMentions?.title != '',
                child: BaseHeading(
                  title: manager.billionairesRes?.recentMentions?.title ?? "",
                  titleStyle: stylePTSansBold(
                      fontSize: 24, color: ThemeColors.splashBG),
                  margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                )),
            SpacerVertical(height: Pad.pad10),
            Visibility(
              visible: manager.billionairesRes?.recentMentions != null &&
                  (manager.billionairesRes?.recentMentions?.data?.isNotEmpty ==
                      true),
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  RecentMentionsRes? item =
                      manager.billionairesRes?.recentMentions?.data?[index];
                  return MentionItem(
                    item: item,
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return SpacerVertical(height: Pad.pad16);
                },
                itemCount:
                    manager.billionairesRes?.recentMentions?.data?.length ?? 0,
              ),
            ),
            SpacerVertical(height: Pad.pad10),
            Visibility(
                visible: true,
                //visible: manager.billionairesRes?.recentMentions?.title != null && manager.billionairesRes?.recentMentions?.title!= '',
                child: BaseHeading(
                  title: "Top 360 Mentions",
                  titleStyle: stylePTSansBold(
                      fontSize: 24, color: ThemeColors.splashBG),
                  margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                )),
            SpacerVertical(height: Pad.pad10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
              child: Image.asset(Images.btc),
            ),
            SpacerVertical(height: Pad.pad10),
            Visibility(
                visible:
                    manager.billionairesRes?.symbolMentionList?.title != null &&
                        manager.billionairesRes?.symbolMentionList?.title != '',
                child: BaseHeading(
                  title:
                      manager.billionairesRes?.symbolMentionList?.title ?? "",
                  titleStyle: stylePTSansBold(
                      fontSize: 24, color: ThemeColors.splashBG),
                  margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                )),
            SpacerVertical(height: Pad.pad16),
            /* Padding(
              padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
              child: Row(
                children: [
                  Expanded(child: BaseColorContainer(
                    bgColor: ThemeColors.neutral5.withValues(alpha: 0.2),
                    child: Column(
                      children: [
                        Text(
                          "Market Cap",
                          style: stylePTSansRegular(fontSize: 18,color: ThemeColors.neutral7),
                        ),
                        SpacerVertical(height: Pad.pad5),
                        Text(
                          "\$3.37 T",
                          style: stylePTSansBold(fontSize: 30,color: ThemeColors.splashBG),
                        ),
                        SpacerVertical(height: Pad.pad5),
                        Visibility(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                2 >= 0
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: 2>= 0
                                    ? ThemeColors.success120
                                    : ThemeColors.error120,
                                size: 18,
                              ),
                              Text(
                                "\$3.37 (0.02%)",
                                style: stylePTSansBold(
                                  fontSize: 12,
                                  color: 2 >= 0
                                      ? ThemeColors.success120
                                      : ThemeColors.error120,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                  SpacerHorizontal(width: Pad.pad10),
                  Expanded(child: BaseColorContainer(
                    bgColor: ThemeColors.neutral5.withValues(alpha: 0.2),
                    child: Column(
                      children: [
                        Text(
                          "Total Volume",
                          style: stylePTSansRegular(fontSize: 18,color: ThemeColors.neutral7),
                        ),
                        SpacerVertical(height: Pad.pad5),
                        Text(
                          "\$152.1B",
                          style: stylePTSansBold(fontSize: 30,color: ThemeColors.splashBG),
                        ),
                        SpacerVertical(height: Pad.pad5),
                        Visibility(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Icon(
                                2 >= 0
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: 2>= 0
                                    ? ThemeColors.success120
                                    : ThemeColors.error120,
                                size: 18,
                              ),
                              Text(
                                "\$3.37 (0.02%)",
                                style: stylePTSansBold(
                                  fontSize: 12,
                                  color: 2 >= 0
                                      ? ThemeColors.success120
                                      : ThemeColors.error120,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),

                ],
              ),
            ),
            SpacerVertical(height: Pad.pad10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),

              child: BaseColorContainer(
                bgColor: ThemeColors.neutral5.withValues(alpha: 0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dominance",
                      style: stylePTSansRegular(fontSize: 18,color: ThemeColors.neutral7),
                    ),
                    SpacerVertical(height: Pad.pad5),
                    Row(
                      children: List.generate(
                        3,(index) {
                          //Symbols items= item!.symbols![index];
                          return Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.circle,color: ThemeColors.warning120,size: 10),
                                    SpacerHorizontal(width: Pad.pad3),
                                    BaseHeading(
                                      title: "Bitcoin",
                                      titleStyle: stylePTSansBold(fontSize: 12,color: ThemeColors.black),
                                    )
                                  ],
                                ),
                                Text(
                                  "58.3%",
                                  style: stylePTSansBold(fontSize: 26,color: ThemeColors.splashBG),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SpacerVertical(height: Pad.pad10),*/
            CryptoTable(
                symbolMentionRes: manager.billionairesRes?.symbolMentionList)
          ],
        ),
      ),
    );
  }
}
