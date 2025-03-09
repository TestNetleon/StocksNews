import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class CryptoItem extends StatelessWidget {
  final CryptoTweetPost? item;
  final Function()? onTap;
  const CryptoItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BaseBorderContainer(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: item?.qouteLeft != null && item?.qouteLeft != '',
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: ThemeImageView(url: item?.qouteLeft ?? "",fit: BoxFit.fill,),
                ),
              ),
              Visibility(
                visible: item?.twitterX != null && item?.twitterX != '',
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: ThemeImageView(url: item?.twitterX ?? ""),
                ),
              ),
            ],
          ),
          SpacerVertical(
            height: Pad.pad16
          ),
          Visibility(
            visible: item?.tweet != null && item?.tweet != '',
            child:  Text(
              "${item?.tweet}",
              style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SpacerVertical(
              height: Pad.pad10
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Visibility(
                  visible: item?.twitterName != null && item?.twitterName != '',
                  child:  Text(
                    "- ${item?.twitterName}",
                    style: stylePTSansRegular(fontSize: 16,color: ThemeColors.splashBG),
                  ),
                ),
              ),
              Visibility(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImagesWidget(
                    item?.image ?? '',
                    height: 40,
                    width: 40,
                    placeHolder: Images.userPlaceholderNew,
                    showLoading: true,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
