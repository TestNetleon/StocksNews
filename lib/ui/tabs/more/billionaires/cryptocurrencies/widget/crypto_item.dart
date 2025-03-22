import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/crypto_container.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class CryptoItem extends StatelessWidget {
  final CryptoTweetPost? item;
  final Function()? onTap;
  const CryptoItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, value, child) {
      bool isDark = value.isDarkMode;
      return CryptoContainer(
        isDark: isDark,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: item?.quoteLeft != null && item?.quoteLeft != '',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? ThemeColors.black : null,
                        shape: BoxShape.circle,
                      ),
                      width: 24,
                      height: 24,
                      child: CachedNetworkImagesWidget(item?.quoteLeft ?? "",
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                Visibility(
                  visible: item?.twitterX != null && item?.twitterX != '',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? ThemeColors.black : null,
                        shape: BoxShape.circle,
                      ),
                      width: 24,
                      height: 24,
                      child: CachedNetworkImagesWidget(item?.twitterX ?? "",
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ],
            ),
            SpacerVertical(height: 16),
            Visibility(
              visible: item?.tweet != null && item?.tweet != '',
              child: Text(
                "${item?.tweet}",
                style: styleBaseBold(fontSize: 16),
              ),
            ),
            SpacerVertical(height: Pad.pad10),
            Visibility(
              visible: item?.date != null && item?.date != '',
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${item?.date}",
                  style: styleBaseRegular(fontSize: 12),
                ),
              ),
            ),
            SpacerVertical(height: Pad.pad10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: ThemeColors.primary120, width: 1),
                      shape: BoxShape.circle),
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
                SpacerHorizontal(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: item?.name != null && item?.name != '',
                        child: Text(
                          "${item?.name}",
                          style: styleBaseBold(),
                        ),
                      ),
                      SpacerVertical(height: 3),
                      Visibility(
                        visible: item?.designation != null &&
                            item?.designation != '',
                        child: Text(
                          "${item?.designation}",
                          style: styleBaseRegular(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      );
    });
  }
}
