import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_table.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
class MyWatchListIndex extends StatelessWidget {
  const MyWatchListIndex({super.key});

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return BaseLoaderContainer(
      hasData: manager.billionairesRes!= null,
      isLoading: manager.isLoadingCrypto,
      error: manager.error,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: manager.getCryptoCurrencies,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpacerVertical(height: Pad.pad10),
            CryptoTable(
                symbolMentionRes:manager.billionairesRes?.symbolMentionList
            ),
            SpacerVertical(height: Pad.pad10),
            Visibility(
                visible: manager.billionairesRes?.symbolMentionList?.title != null && manager.billionairesRes?.symbolMentionList?.title!= '',
                child: BaseHeading(
                  title: manager.billionairesRes?.symbolMentionList?.title??"",
                  titleStyle: stylePTSansBold(fontSize: 24,color: ThemeColors.splashBG),
                  margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),

                )
            ),
            SpacerVertical(height: Pad.pad10),
            Visibility(
              visible: manager.billionairesRes?.cryptoTweetPost != null,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Pad.pad10),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  CryptoTweetPost? item = manager.billionairesRes?.cryptoTweetPost?[index];
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






          ],
        ),
      ),
    );
  }
}
