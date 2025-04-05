import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/billionaires_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/crypto_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

recentTweetSheet({CryptoTweetPost? mentions}) {
  BaseBottomSheet().bottomSheet(
      isScrollable: false,
      barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
      child: RecentTweet(
        mentions: mentions,
      ));
}

class RecentTweet extends StatefulWidget {
  final CryptoTweetPost? mentions;
  const RecentTweet({super.key, this.mentions});

  @override
  State<RecentTweet> createState() => _RecentTweetState();
}

class _RecentTweetState extends State<RecentTweet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BillionairesManager manager = context.read<BillionairesManager>();
      manager.getBillionaireTweets(tName: widget.mentions?.twitterName ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return BaseLoaderContainer(
      hasData: manager.recentTweetRes != null,
      isLoading: manager.isTweetLoading,
      error: manager.error,
      showPreparingText: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.background,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImagesWidget(
                    widget.mentions?.image ?? "",
                    height: 50,
                    width: 50,
                    showLoading: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SpacerHorizontal(width: Pad.pad16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.mentions?.name}',
                      style: styleBaseBold(fontSize: 20),
                    ),
                    Text(
                      '${widget.mentions?.designation}',
                      style: styleBaseRegular(fontSize: 14),
                    ),
                  ],
                ),
              ),
              IntrinsicWidth(
                child: BaseButton(
                  fullWidth: false,
                  fontBold: true,
                  color: widget.mentions?.isFavoritePersonAdded == 0
                      ? ThemeColors.success
                      : ThemeColors.error,
                  // height: 35,
                  onPressed: () {
                    if (widget.mentions?.isFavoritePersonAdded == 0) {
                      manager.requestAddToFav(
                          widget.mentions?.twitterName ?? "",
                          profiles: widget.mentions);
                    } else {
                      manager.requestRemoveToFav(
                          widget.mentions?.twitterName ?? "",
                          profiles: widget.mentions);
                    }
                  },
                  text: widget.mentions?.isFavoritePersonAdded == 0
                      ? "FOLLOW"
                      : "UNFOLLOW",
                  // textColor:ThemeColors.white,
                  textSize: 14,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ],
          ),
          SpacerVertical(height: 10),
          Divider(
            color: ThemeColors.greyBorder,
            height: 10,
          ),
          Expanded(
            child: Visibility(
              visible: manager.recentTweetRes?.tweets != null,
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  CryptoTweetPost? item =
                      manager.recentTweetRes?.tweets?[index];
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
                  return SpacerVertical(height: 10);
                },
                itemCount: manager.recentTweetRes?.tweets?.length ?? 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
