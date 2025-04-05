import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/billionaires_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/myWatchlist/widget/fav_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/mention_list.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MyWatchListIndex extends StatelessWidget {
  const MyWatchListIndex({super.key});

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    SymbolMentionList? symbolMentionRes = manager.cryptoWatchRes?.watchlistData;

    return BaseLoaderContainer(
      hasData: manager.cryptoWatchRes != null,
      isLoading: manager.isLoadingCrypto,
      error: manager.error,
      showPreparingText: true,
      child: BaseScroll(
          onRefresh: manager.getWatchList,
          margin: EdgeInsets.zero,
          children: [
            Visibility(
                visible: symbolMentionRes != null,
                child: MentionsListIndex(symbolMentionRes: symbolMentionRes)),
            SpacerVertical(height: 20),
            Visibility(
                visible:
                    manager.cryptoWatchRes?.favoritePerson?.title != null &&
                        manager.cryptoWatchRes?.favoritePerson?.title != '',
                child: BaseHeading(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: manager.cryptoWatchRes?.favoritePerson?.title ?? "",
                  titleStyle: styleBaseBold(),
                )),
            Visibility(
                visible:
                    manager.cryptoWatchRes?.favoritePerson?.title != null &&
                        manager.cryptoWatchRes?.favoritePerson?.title != '',
                child: SpacerVertical(height: 10)),
            Visibility(
              visible: manager.cryptoWatchRes?.favoritePerson?.data != null,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CustomGridViewPerChild(
                  paddingHorizontal: 8,
                  paddingVertical: 8,
                  length:
                      manager.cryptoWatchRes?.favoritePerson?.data?.length ?? 0,
                  getChild: (index) {
                    CryptoTweetPost? item =
                        manager.cryptoWatchRes?.favoritePerson?.data?[index];
                    bool? isEven = index % 2 == 0;
                    if (item == null) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: isEven ? 8 : 0.0),
                      child: FavItem(
                        item: item,
                        onTap: () {
                          // Navigator.pushNamed(context, BillionairesDetailIndex.path,
                          //     arguments: {'slug': item.slug ?? ""});

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BillionairesDetailIndex(
                                        slug: item.slug ?? "",
                                      )));
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Visibility(
                visible: manager.cryptoWatchRes?.favoritePerson?.data != null,
                child: SpacerVertical(height: 20)),
            Visibility(
                visible:
                    manager.cryptoWatchRes?.recentTweetPost?.title != null &&
                        manager.cryptoWatchRes?.recentTweetPost?.title != '',
                child: BaseHeading(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: manager.cryptoWatchRes?.recentTweetPost?.title ?? "",
                  titleStyle: styleBaseBold(),
                )),
            Visibility(
                visible:
                    manager.cryptoWatchRes?.recentTweetPost?.title != null &&
                        manager.cryptoWatchRes?.recentTweetPost?.title != '',
                child: SpacerVertical(height: 10)),
            Visibility(
              visible: manager.cryptoWatchRes?.recentTweetPost?.data != null,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  CryptoTweetPost? item =
                      manager.cryptoWatchRes?.recentTweetPost?.data?[index];
                  return CryptoItem(
                    item: item,
                    onTap: () {
                      // Navigator.pushNamed(context, BillionairesDetailIndex.path,
                      //     arguments: {'slug': item?.slug ?? ""});

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BillionairesDetailIndex(
                                    slug: item?.slug ?? "",
                                  )));
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return SpacerVertical(height: 20);
                },
                itemCount:
                    manager.cryptoWatchRes?.recentTweetPost?.data?.length ?? 0,
              ),
            ),
            SpacerVertical(height: 10),
          ]),
    );
  }
}
