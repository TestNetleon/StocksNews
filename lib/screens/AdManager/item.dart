import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/ad_provider.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/news_details_body.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../api/api_response.dart';
import '../../routes/my_app.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';

class AdManagerItem extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final PopupAdRes? data;
  const AdManagerItem({
    super.key,
    this.margin,
    this.data,
  });
  void _onTap() {
    closeKeyboard();

    if (Platform.isIOS) {
      // adIOSNavigate(Uri.parse(data?.url ?? "https://app.stocks.news"));
      iOSNavigate(Uri.parse(data?.url ?? "https://app.stocks.news"));
    } else {
      openUrl(data?.url ?? "https://app.stocks.news");
    }

    AdProvider provider = navigatorKey.currentContext!.read<AdProvider>();
    provider.callAPI(view: false, id: data?.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        margin: margin ??
            const EdgeInsets.only(top: Dimen.homeSpacing, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImagesWidget(
              data?.image,
              fit: BoxFit.contain,
            ),
            Visibility(
              visible: data?.adText != null && data?.adText != '',
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

bool handleAdVisibility(VisibilityInfo visibilityInfo) {
  try {
    var visiblePercentage = visibilityInfo.visibleFraction * 100;
    return visiblePercentage > 20;
  } catch (e) {
    // Handle error if necessary
    return false;
  }
}

addOnSheetManagers({
  PopupAdRes? popUp,
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
              if (Platform.isIOS) {
                // adIOSNavigate(
                //     Uri.parse(popUp?.url ?? "https://app.stocks.news"));

                iOSNavigate(Uri.parse(popUp?.url ?? "https://app.stocks.news"));
              } else {
                openUrl(popUp?.url ?? "https://app.stocks.news");
              }
              AdProvider provider = context.read<AdProvider>();
              provider.callAPI(view: false, id: popUp?.id);
            },
            child: Container(
              margin: EdgeInsets.only(top: 15),
              width: double.infinity,
              child: CachedNetworkImagesWidget(
                popUp?.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 30,
            child: Visibility(
              visible: popUp?.adText != null && popUp?.adText != '',
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
