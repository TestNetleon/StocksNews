import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

import '../../api/api_response.dart';
import '../../route/my_app.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';

class AddOnScreen extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final AdManagerRes? adManager;
  final Function()? onTap;
  const AddOnScreen({super.key, this.margin, this.adManager, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (adManager == null) {
      return SizedBox();
    }

    return GestureDetector(
      onTap: () {
        try {
          if (onTap != null) onTap!();
        } catch (e) {
          //
          Utils().showLog("---$e");
        }
        openUrl(adManager?.url ?? "https://app.stocks.news");
      },
      child: Container(
        margin: margin ??
            const EdgeInsets.only(top: Dimen.homeSpacing, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImagesWidget(
              adManager?.bannerImage,
              fit: BoxFit.contain,
            ),
            Visibility(
              visible: adManager?.adText != null && adManager?.adText != '',
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Ad",
                    style: stylePTSansRegular(color: ThemeColors.greyText),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

addOnSheet({
  AdManagerRes? adManager,
  final Function()? onTap,
}) {
  showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: navigatorKey.currentContext!,
    builder: (context) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              openUrl(adManager?.url ?? "https://app.stocks.news");
              try {
                if (onTap != null) onTap();
              } catch (e) {
                //
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 15),
              width: double.infinity,
              child: CachedNetworkImagesWidget(
                adManager?.popUpImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 30,
            child: Visibility(
              visible: adManager?.adText != null && adManager?.adText != '',
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeColors.greyBorder,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                child: Text(
                  "Ad",
                  style: stylePTSansRegular(
                      color: ThemeColors.greyText, fontSize: 14),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ThemeColors.white),
                  color: ThemeColors.background,
                ),
                child: Icon(
                  Icons.close,
                  size: 17,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
