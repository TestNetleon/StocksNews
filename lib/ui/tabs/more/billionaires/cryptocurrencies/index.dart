import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/top_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class Cryptocurrencies extends StatelessWidget {
  final BillionairesRes? billionairesRes;
  const Cryptocurrencies({super.key, this.billionairesRes});

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return Column(
      children: [
        Visibility(
          visible: billionairesRes?.cryptoTweetPost != null,
          child: CommonRefreshIndicator(
            onRefresh: manager.getBillionaires,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                CryptoTweetPost? item =
                    billionairesRes?.cryptoTweetPost?[index];
                return CryptoItem(
                  item: item,
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) {
                return SpacerVertical(height: Pad.pad3);
              },
              itemCount: billionairesRes?.cryptoTweetPost?.length ?? 0,
            ),
          ),
        ),
        Visibility(
            visible: billionairesRes?.topBillionaires != null,
            child: SpacerVertical(height: Pad.pad10)),
        Visibility(
          visible: billionairesRes?.topBillionaires != null,
          child: BaseTabs(
            data: manager.innerTabs,
            // textStyle: styleBaseBold(fontSize: 16, color: ThemeColors.splashBG),
            onTap: manager.onScreenChangeInner,
          ),
        ),
        if (manager.selectedInnerScreen == 0)
          if (billionairesRes?.topBillionaires == null) SizedBox(),
        TopBilIndex(
          topBils: billionairesRes?.topBillionaires,
        ),
        if (manager.selectedInnerScreen == 1) SizedBox(),
      ],
    );
  }
}
