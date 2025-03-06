import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/color_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_table.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BillionairesDetailIndex extends StatefulWidget {
  final String slug;

  static const path = 'BillionairesDetailIndex';

  const BillionairesDetailIndex({super.key, required this.slug});

  @override
  State<BillionairesDetailIndex> createState() => _BillionairesDetailIndexState();
}

class _BillionairesDetailIndexState extends State<BillionairesDetailIndex> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    BillionairesManager manager = context.read<BillionairesManager>();
    manager.getBilDetail(widget.slug);
  }


  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.billionairesDetailRes?.title ?? "Billionaires",
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoading,
        hasData: manager.billionairesDetailRes != null && !manager.isLoading,
        showPreparingText: true,
        error: manager.error,
        onRefresh: () {
          _callAPI();
        },
        child: Column(
          children: [
            BaseColorContainer(
              bgColor: ThemeColors.neutral9,
              child: Column(
                children: [
                  BaseHeading(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textAlign: TextAlign.start,
                    subtitle: manager.billionairesDetailRes?.billionaireInfo?.description??"",
                    subtitleStyle: stylePTSansBold(fontSize: 16,color: ThemeColors.black),
                    margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),

                  )
                ],
              ),

            ),
            SpacerVertical(height: Pad.pad10),
            Visibility(
                visible: manager.billionairesDetailRes?.recentTweet?.title != null && manager.billionairesDetailRes?.recentTweet?.title!= '',
                child: BaseHeading(
                  title: manager.billionairesDetailRes?.recentTweet?.title??"",
                  titleStyle: stylePTSansBold(fontSize: 24,color: ThemeColors.splashBG),
                  margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),

                )
            ),
            SpacerVertical(height: Pad.pad10),
            Visibility(
              visible: manager.billionairesDetailRes?.recentTweet?.data != null,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Pad.pad10),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  CryptoTweetPost? item = manager.billionairesDetailRes?.recentTweet?.data?[index];
                  return CryptoItem(
                    item: item,
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return SpacerVertical(height: Pad.pad3);
                },
                itemCount: manager.billionairesDetailRes?.recentTweet?.data?.length ?? 0,
              ),
            ),
            SpacerVertical(height: Pad.pad24),
            Visibility(
                visible: true,
                //visible: manager.billionairesRes?.recentMentions?.title != null && manager.billionairesRes?.recentMentions?.title!= '',
                child: BaseHeading(
                  title: "Top 360 Mentions",
                  titleStyle: stylePTSansBold(fontSize: 24,color: ThemeColors.splashBG),
                  margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),

                )
            ),
            SpacerVertical(height: Pad.pad10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
              child: Image.asset(Images.btc),
            ),
            SpacerVertical(height: Pad.pad10),
            CryptoTable(
                symbolMentionRes:manager.billionairesDetailRes?.symbolMentionList
            )
          ],
        ),
      ),
    );
  }
}
