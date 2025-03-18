import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class FavItem extends StatelessWidget {
  final CryptoTweetPost? item;
  final Function()? onTap;
  const FavItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return BaseBorderContainer(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: item?.deleteIcon != null && item?.deleteIcon != '',
            child: GestureDetector(
              onTap: () {
                manager.requestRemoveToFav(item?.twitterName ?? "", from: 1);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: ThemeImageView(
                    url: item?.deleteIcon ?? "",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: item?.designation != null && item?.designation != '',
            child: Text(
              "${item?.designation}",
              style: styleBaseBold(fontSize: 16, color: ThemeColors.splashBG),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SpacerVertical(height: Pad.pad10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Visibility(
                  visible: item?.twitterName != null && item?.twitterName != '',
                  child: Text(
                    "- ${item?.twitterName}",
                    style: styleBaseRegular(
                        fontSize: 16, color: ThemeColors.splashBG),
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
                    fit: BoxFit.contain,
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
