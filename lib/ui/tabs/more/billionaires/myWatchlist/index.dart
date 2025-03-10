import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_table.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/myWatchlist/widget/fav_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MyWatchListIndex extends StatelessWidget {
  const MyWatchListIndex({super.key});

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return BaseLoaderContainer(
      hasData: manager.cryptoWatchRes != null,
      isLoading: manager.isLoadingCrypto,
      error: manager.error,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: manager.getWatchList,
        margin: EdgeInsets.zero,
        children:[
          SpacerVertical(height: Pad.pad20),
          Visibility(
              visible: manager.cryptoWatchRes?.watchlistData?.data!=null && (manager.cryptoWatchRes?.watchlistData?.data?.isNotEmpty==true),
              child: CryptoTable(symbolMentionRes:manager.cryptoWatchRes?.watchlistData)),
          SpacerVertical(height: Pad.pad16),

          Visibility(
              visible: manager.cryptoWatchRes?.favoritePerson?.title != null && manager.cryptoWatchRes?.favoritePerson?.title!= '',
              child: BaseHeading(
                title: manager.cryptoWatchRes?.favoritePerson?.title??"",
                titleStyle: stylePTSansBold(fontSize: 24,color: ThemeColors.splashBG),
                margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),

              )
          ),
          SpacerVertical(height: Pad.pad5),
          Visibility(
            visible: manager.cryptoWatchRes?.favoritePerson?.data != null,
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Pad.pad8),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                CryptoTweetPost? item = manager.cryptoWatchRes?.favoritePerson?.data?[index];
                return FavItem(
                  item: item,
                  onTap: () {

                  },
                );
              },
              separatorBuilder: (context, index) {
                return SpacerVertical(height: Pad.pad3);
              },
              itemCount: manager.cryptoWatchRes?.favoritePerson?.data?.length ?? 0,
            ),
          ),

          SpacerVertical(height: Pad.pad5),

          Visibility(
              visible: manager.cryptoWatchRes?.recentTweetPost?.title != null && manager.cryptoWatchRes?.recentTweetPost?.title!= '',
              child: BaseHeading(
                title: manager.cryptoWatchRes?.recentTweetPost?.title??"",
                titleStyle: stylePTSansBold(fontSize: 24,color: ThemeColors.splashBG),
                margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),

              )
          ),
          SpacerVertical(height: Pad.pad5),
          Visibility(
            visible: manager.cryptoWatchRes?.recentTweetPost?.data != null,
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Pad.pad8),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                CryptoTweetPost? item = manager.cryptoWatchRes?.recentTweetPost?.data?[index];
                return CryptoItem(
                  item: item,
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) {
                return SpacerVertical(height: Pad.pad3);
              },
              itemCount: manager.billionairesRes?.cryptoTweetPost?.length ?? 0,
            ),
          ),
        ]
      ),
    );
  }
}
