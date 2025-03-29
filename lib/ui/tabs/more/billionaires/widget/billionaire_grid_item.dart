import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/crypto_container.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BillionaireGridItem extends StatelessWidget {
  final CryptoTweetPost? item;
  final Function()? onTap;
  const BillionaireGridItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return
      Consumer<ThemeManager>(builder: (context, value, child) {
      bool isDark = value.isDarkMode;
      return Stack(
      clipBehavior: Clip.none,
      children: [
        CryptoContainer(
            isDark: isDark,
            onTap: onTap,
            innerPadding: EdgeInsets.zero,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  child: CachedNetworkImagesWidget(
                    item?.image ?? '',
                    height: 200,
                    placeHolder: Images.userPlaceholderNew,
                    showLoading: true,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          ThemeColors.primary.withValues(alpha: 1.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: item?.name != null && item?.name != '',
                        child: Text(
                          "${item?.name}",
                          style: styleBaseBold(
                              fontSize: 16, color: isDark ? null : ThemeColors.white),
                        ),
                      ),
                      SpacerVertical(height: 5),
                      Visibility(
                        visible: item?.designation != null &&
                            item?.designation != '',
                        child: Text(
                          "${item?.designation}",
                          style: styleBaseRegular(
                              fontSize: 14, color: isDark ? null : ThemeColors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),
        Positioned(
            bottom: -16,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: item?.isFavoritePersonAdded == 0
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color.fromARGB(255, 23, 23, 23),
                          const Color.fromARGB(255, 39, 39, 39),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          ThemeColors.accent,
                          ThemeColors.transparentGreen,
                        ],
                      ),
                shape: BoxShape.circle,
                border: Border.all(color: ThemeColors.black.withValues(alpha: 0.4)),
              ),
              child: InkWell(
                onTap: () {
                  if (item?.isFavoritePersonAdded == 0) {
                    manager.requestAddToFav(item?.twitterName ?? "",
                        profiles: item);
                  } else {
                    manager.requestRemoveToFav(item?.twitterName ?? "",
                        profiles: item);
                  }
                },
                child: Icon(
                  item?.isFavoritePersonAdded == 0 ? Icons.add : Icons.check,
                  size: 24,
                  color: isDark?null:ThemeColors.white,
                ),
              ),
            )),
      ],
    );
      });
  }
}
