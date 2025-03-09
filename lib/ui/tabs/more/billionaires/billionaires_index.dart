import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/color_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_table.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
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
        title: manager.billionairesDetailRes?.billionaireInfo?.name ?? "Billionaires",
        showSearch: true,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoading,
        hasData: manager.billionairesDetailRes != null && !manager.isLoading,
        showPreparingText: true,
        error: manager.error,
        onRefresh: () {
          _callAPI();
        },
        child: BaseScroll(
          onRefresh: () async {
            manager.getBilDetail(widget.slug);
          },
          margin: EdgeInsets.zero,
          children: [
            BaseColorContainer(
              bgColor: ThemeColors.neutral9,
              radius: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Visibility(
                        visible: manager.billionairesDetailRes?.billionaireInfo?.image!=null,
                        child: Container(
                          padding: EdgeInsets.all(Pad.pad5),
                          decoration: BoxDecoration(
                              border: Border.all(color: ThemeColors.neutral20,width: 1),
                              shape: BoxShape.circle
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: CachedNetworkImagesWidget(
                              manager.billionairesDetailRes?.billionaireInfo?.image ?? '',
                              height: 55,
                              width: 55,
                              placeHolder: Images.userPlaceholderNew,
                              showLoading: true,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SpacerHorizontal(width: Pad.pad16),
                      Expanded(
                        child: Visibility(
                          visible: manager.billionairesDetailRes?.billionaireInfo?.name != null && manager.billionairesDetailRes?.billionaireInfo?.name != '',
                          child: BaseHeading(
                            title: "${manager.billionairesDetailRes?.billionaireInfo?.name}",
                            titleStyle: stylePTSansBold(fontSize: 20,color: ThemeColors.splashBG),
                            subtitleStyle: stylePTSansRegular(fontSize: 14,color: ThemeColors.colour66,fontWeight: FontWeight.w400),
                            subtitle: manager.billionairesDetailRes?.billionaireInfo?.designation??"",
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                  BaseHeading(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textAlign: TextAlign.start,
                    subtitle: manager.billionairesDetailRes?.billionaireInfo?.description??"",
                    subtitleStyle: stylePTSansRegular(fontSize: 16,color: ThemeColors.black,fontWeight: FontWeight.w400,height: 1.5),
                  ),
                  IntrinsicWidth(
                    child: BaseButton(
                      fullWidth: false,
                      color: ThemeColors.white,
                      onPressed: (){},
                      text: "ADD TO LIST",
                      textStyle:stylePTSansRegular(fontSize: 12,color: ThemeColors.primaryLight,fontWeight: FontWeight.w600),
                      icon: Images.ic_fav,
                    
                    ),
                  ),


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
            SpacerVertical(height: Pad.pad5),
            Visibility(
              visible: manager.billionairesDetailRes?.recentTweet?.data != null,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Pad.pad8),
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
            SpacerVertical(height: Pad.pad20),
           /* Visibility(
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
            SpacerVertical(height: Pad.pad16),*/
            CryptoTable(
                symbolMentionRes:manager.billionairesDetailRes?.symbolMentionList
            )
          ],
        ),
      ),
    );
  }
}
