import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/billionaires_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/billionaire_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TopBilIndex extends StatelessWidget {
  final TopTab? topTabs;
  const TopBilIndex({super.key, this.topTabs});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: topTabs?.billionaires != null,
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            CryptoTweetPost? item = topTabs?.billionaires?.data?[index];
            return BillionaireItem(
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
                });
          },
          separatorBuilder: (context, index) {
            return SpacerVertical(height: Pad.pad20);
          },
          itemCount: topTabs?.billionaires?.data?.length ?? 0,
        ));
  }
}
