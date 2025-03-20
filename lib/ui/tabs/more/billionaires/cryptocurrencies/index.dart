import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/all_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/top_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/mention_list.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/recent_tweet_sheet.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class Cryptocurrencies extends StatefulWidget {
  const Cryptocurrencies({super.key});

  @override
  State<Cryptocurrencies> createState() => _CryptocurrenciesState();
}

class _CryptocurrenciesState extends State<Cryptocurrencies>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }


  void _scrollToSelectedIndex(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 50.0;
    double scrollOffset =
        index * itemWidth - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    SymbolMentionList? symbolMentionRes = manager.billionairesRes?.symbolMentionList;
    /* if(manager.billionairesRes?.topTab?.data!=null && manager.billionairesRes?.topTab?.data?.isNotEmpty ==true){
      manager.titleArray = manager.billionairesRes!.topTab!.data!.map((item) => item.title!).toList();
    }*/
    return BaseLoaderContainer(
      hasData: manager.billionairesRes != null,
      isLoading: manager.isLoadingCrypto,
      error: manager.error,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: manager.getCryptoCurrencies,
        margin: EdgeInsets.zero,
        children: [
          Container(
            margin:const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Billionaires –\n",
                    style: styleBaseBold(fontSize: 30),
                  ),
                  TextSpan(
                    text: "Track ",
                    style: styleBaseRegular(fontSize: 30),
                  ),
                  TextSpan(
                    text: "Moves, ",
                    style: styleBaseBold(fontSize: 30),
                  ),
                  TextSpan(
                    text: "Stay ",
                    style: styleBaseRegular(fontSize: 30),
                  ),
                  TextSpan(
                    text: "Ahead!",
                    style: styleBaseBold(fontSize: 30),
                  ),
                ],
                text: "Invest Like ",
                style: styleBaseRegular(fontSize: 30),
              ),
            ),
          ),
          Visibility(
              visible: manager.billionairesRes?.recentMentions != null &&
                  (manager.billionairesRes?.recentMentions?.data
                      ?.isNotEmpty ==
                      true),
              child: SpacerVertical(height: 10)
          ),
          Visibility(
            visible: manager.billionairesRes?.recentMentions != null &&
                (manager.billionairesRes?.recentMentions?.data?.isNotEmpty ==
                    true),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: List.generate(
                        manager.billionairesRes?.recentMentions?.data
                            ?.length ??
                            0,
                            (index) {
                          CryptoTweetPost? data = manager
                              .billionairesRes?.recentMentions?.data?[index];
                          return InkWell(
                            onTap: () {
                              _scrollToSelectedIndex(index);
                              recentTweetSheet(
                                mentions: data,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    ThemeColors.accent,
                                    Color.fromARGB(255, 222, 215, 7),
                                  ],
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ThemeColors.background,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: CachedNetworkImagesWidget(
                                    data?.image ?? '',
                                    height: 60,
                                    width: 60,
                                    showLoading: true,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                ),
              ),
            ),
          ),
          SpacerVertical(height: 10),
          MentionsListIndex(symbolMentionRes: symbolMentionRes),

          SpacerVertical(height: 20),
          TopBilIndex(
            topTabs: manager.billionairesRes?.topTab,
          ),
          SpacerVertical(height: 20),
          BaseButton(
            textSize: 16,
            onPressed: () {
              Navigator.pushNamed(context, AllBillionairesIndex.path);
            },
            text: "View all Billionaires",
            margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
          ),
          SpacerVertical(height: 20),
        ],
      ),
    );
  }
}
