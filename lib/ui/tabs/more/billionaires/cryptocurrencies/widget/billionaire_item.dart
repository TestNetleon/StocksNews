import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/billionaires_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/crypto_container.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BillionaireItem extends StatelessWidget {
  final CryptoTweetPost? item;
  final Function()? onTap;
  const BillionaireItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return Consumer<ThemeManager>(builder: (context, value, child) {
      bool isDark = value.isDarkMode;
      return CryptoContainer(
        isDark: isDark,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: item?.name != null && item?.name != '',
              child: Column(
                children: [
                  Text(
                    "${item?.name}",
                    style: styleBaseBold(fontSize: 24),
                  ),
                  SpacerVertical(height: 5),
                  Text(
                    "${item?.designation}",
                    style: styleBaseBold(fontSize: 14),
                  ),
                ],
              ),
            ),
            SpacerVertical(height: 20),
            Visibility(
              visible:
                  item?.symbols != null || item?.symbols?.isNotEmpty == true,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    item!.symbols!.length,
                    (index) {
                      Symbols items = item!.symbols![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Text(
                              "${items.count ?? ""}",
                              style: styleBaseBold(fontSize: 20),
                            ),
                            SpacerVertical(height: 5),
                            Text(
                              items.symbol ?? "",
                              style: styleBaseBold(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SpacerVertical(height: 20),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BillionairesDetailIndex(slug: item?.slug ?? ""),
                  ),
                );
              },
              label: Text(
                "SEE ALL MENTIONS",
                style: styleBaseRegular(fontSize: 14),
              ),
              icon: Icon(Icons.arrow_right_alt_outlined,color: ThemeColors.black),
              iconAlignment: IconAlignment.end,
            ),
            SpacerVertical(height: 20),
            Visibility(
              visible: item?.image != null,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.black), shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(140),
                  child: CachedNetworkImagesWidget(
                    item?.image ?? '',
                    height: 140,
                    width: 140,
                    placeHolder: Images.userPlaceholderNew,
                    showLoading: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SpacerVertical(height: 20),
            IntrinsicWidth(
              child: BaseButton(
                fullWidth: false,
                fontBold: true,
                color: item?.isFavoritePersonAdded == 0
                    ? ThemeColors.success
                    : ThemeColors.error,
                onPressed: () {
                  if (item?.isFavoritePersonAdded == 0) {
                    manager.requestAddToFav(item?.twitterName ?? "",
                        profiles: item);
                  } else {
                    manager.requestRemoveToFav(item?.twitterName ?? "",
                        profiles: item);
                  }
                },
                text:
                    item?.isFavoritePersonAdded == 0 ? "FOLLOW" : "UNFOLLOW",
                //textColor:ThemeColors.white,
                textSize: 14,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ],
        ),
      );
    });
  }
}
