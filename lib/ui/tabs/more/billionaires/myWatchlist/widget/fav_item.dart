import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/crypto_container.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FavItem extends StatelessWidget {
  final CryptoTweetPost? item;
  final Function()? onTap;
  const FavItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return
      Consumer<ThemeManager>(builder: (context, value, child) {
      bool isDark = value.isDarkMode;
      return CryptoContainer(
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
              padding: EdgeInsets.symmetric(horizontal: 10,vertical:10),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                    [
                      Colors.transparent,
                      ThemeColors.primary.withValues(alpha: 1.3),
                    ],
                  ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: item?.name != null && item?.name != '',
                    child:  Text(
                      "${item?.name}",
                      style:styleBaseBold(fontSize: 16,color: isDark ? null : ThemeColors.white),
                    ),
                  ),
                  SpacerVertical(height: 5),
                  Visibility(
                    visible: item?.designation != null && item?.designation != '',
                    child: Text(
                      "${item?.designation}",
                      style: styleBaseRegular(fontSize: 14,color: isDark ? null : ThemeColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

          ],
        )
    );});
  }
}
