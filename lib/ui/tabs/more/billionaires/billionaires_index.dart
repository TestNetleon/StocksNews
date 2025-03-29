import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/mention_list.dart';
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
  State<BillionairesDetailIndex> createState() =>
      _BillionairesDetailIndexState();
}

class _BillionairesDetailIndexState extends State<BillionairesDetailIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    BillionairesManager manager = context.read<BillionairesManager>();
    await manager.getBilDetail(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    CryptoTweetPost? billionaireInfo =
        manager.billionairesDetailRes?.billionaireInfo;

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: !manager.isLoadingBDetail ? billionaireInfo?.name ?? "" : "",
        showSearch: true,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoadingBDetail,
        hasData:
            manager.billionairesDetailRes != null && !manager.isLoadingBDetail,
        showPreparingText: true,
        error: manager.error,
        onRefresh: () {
          _callAPI();
        },
        child: BaseLoadMore(
          onRefresh: _callAPI,
          onLoadMore: () => manager.getBilDetail(widget.slug, loadMore: true),
          canLoadMore: manager.canLoadMoreDetail,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Pad.pad16, vertical: Pad.pad10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Visibility(
                          visible: billionaireInfo?.image != null,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ThemeColors.white, width: 1),
                                shape: BoxShape.circle),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: CachedNetworkImagesWidget(
                                billionaireInfo?.image ?? '',
                                height: 55,
                                width: 55,
                                placeHolder: Images.placeholder,
                                showLoading: true,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SpacerHorizontal(width: Pad.pad16),
                        Expanded(
                          child: Visibility(
                            visible: billionaireInfo?.name != null &&
                                billionaireInfo?.name != '',
                            child: BaseHeading(
                              title: "${billionaireInfo?.name}",
                              titleStyle: styleBaseBold(fontSize: 20),
                              subtitle: billionaireInfo?.designation ?? "",
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                        ),
                        IntrinsicWidth(
                          child: BaseButton(
                            fullWidth: false,
                            color: billionaireInfo?.isFavoritePersonAdded == 0
                                ? ThemeColors.transparentGreen
                                : ThemeColors.transparentRed,
                            onPressed: () {
                              if (billionaireInfo?.isFavoritePersonAdded == 0) {
                                manager.requestAddToFav(
                                    billionaireInfo?.twitterName ?? "",
                                    profiles: billionaireInfo);
                              } else {
                                manager.requestRemoveToFav(
                                    billionaireInfo?.twitterName ?? "",
                                    profiles: billionaireInfo);
                              }
                            },
                            text: billionaireInfo?.isFavoritePersonAdded == 0
                                ? "FOLLOW"
                                : "UNFOLLOW",
                            textSize: 14,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ],
                    ),
                    SpacerVertical(height: Pad.pad10),
                    HtmlWidget(
                      billionaireInfo?.description ?? "",
                      textStyle: styleBaseRegular(height: 1.6, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SpacerVertical(height: Pad.pad8),
              Visibility(
                  visible:
                      manager.billionairesDetailRes?.symbolMentionList != null,
                  child: MentionsListIndex(
                      symbolMentionRes:
                          manager.billionairesDetailRes?.symbolMentionList)),
              Visibility(
                  visible:
                      manager.billionairesDetailRes?.symbolMentionList != null,
                  child: SpacerVertical(height: Pad.pad10)),
              Visibility(
                  visible: manager.billionairesDetailRes?.recentTweet?.title !=
                          null &&
                      manager.billionairesDetailRes?.recentTweet?.title != '',
                  child: BaseHeading(
                    margin: const EdgeInsets.symmetric(horizontal: Pad.pad16),
                    title:
                        manager.billionairesDetailRes?.recentTweet?.title ?? "",
                    titleStyle: styleBaseBold(),
                  )),
              SpacerVertical(height: Pad.pad10),
              Visibility(
                visible:
                    manager.billionairesDetailRes?.recentTweet?.data != null,
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    CryptoTweetPost? item = manager
                        .billionairesDetailRes?.recentTweet?.data?[index];
                    return CryptoItem(
                      item: item,
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SpacerVertical(height: Pad.pad20);
                  },
                  itemCount: manager
                          .billionairesDetailRes?.recentTweet?.data?.length ??
                      0,
                ),
              ),
              SpacerVertical(height: Pad.pad10),
            ],
          )),
        ),
      ),
    );
  }
}
