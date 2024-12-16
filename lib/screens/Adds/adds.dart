import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/news_details_body.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../api/api_response.dart';
import '../../routes/my_app.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';

class AddOnScreen extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final AdManagerRes? adManager;
  final Function()? onTap;
  const AddOnScreen({super.key, this.margin, this.adManager, this.onTap});
  @override
  State<AddOnScreen> createState() => _AddOnScreenState();
}

class _AddOnScreenState extends State<AddOnScreen> {
  bool _isVisible = false;
  bool _hasCalledAPI = false;

  void _visibilityCall() {
    if (_isVisible && !_hasCalledAPI) {
      Utils().showLog("Calling API");
      _hasCalledAPI = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.adManager == null) {
      return SizedBox();
    }

    return VisibilityDetector(
      key: Key('ad-key'),
      onVisibilityChanged: (visibilityInfo) {
        try {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (visiblePercentage > 20) {
            setState(() {
              _isVisible = true;
            });
            _visibilityCall();
          } else {
            setState(() {
              _isVisible = false;
            });
          }
        } catch (e) {
          //
        }
      },
      child: GestureDetector(
        onTap: () {
          //OPEN WHEN LIVE
          // try {
          //   if (onTap != null) onTap!();
          // } catch (e) {
          //   //
          //   Utils().showLog("---$e");
          // }
          if (Platform.isIOS) {
            // adIOSNavigate(
            //     Uri.parse(widget.adManager?.url ?? "https://app.stocks.news"));
            iOSNavigate(
                Uri.parse(widget.adManager?.url ?? "https://app.stocks.news"));
          } else {
            openUrl(widget.adManager?.url ?? "https://app.stocks.news");
          }
        },
        child: Container(
          margin: widget.margin ??
              const EdgeInsets.only(
                  top: Dimen.homeSpacing, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CachedNetworkImagesWidget(
                widget.adManager?.bannerImage,
                fit: BoxFit.contain,
              ),
              Visibility(
                visible: widget.adManager?.adText != null &&
                    widget.adManager?.adText != '',
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
      ),
    );
  }
}

// adIOSNavigate(Uri event) {
//   // if (event.toString().startsWith("https://app.stocks.news")) {
//   //   DeeplinkEnum type = containsSpecificPath(event);
//   //   String slug = extractLastPathComponent(event);

//   //   handleNavigation(
//   //     uri: event,
//   //     slug: slug,
//   //     type: type,
//   //     setPopHome: false,
//   //   );
//   // } else {
//   //   openUrl("$event");
//   // }
//   handleDeepLinkNavigation(uri: event, conditionalCheck: true);
// }

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
              if (Platform.isIOS) {
                // adIOSNavigate(
                //     Uri.parse(adManager?.url ?? "https://app.stocks.news"));
                iOSNavigate(
                    Uri.parse(adManager?.url ?? "https://app.stocks.news"));
              } else {
                openUrl(adManager?.url ?? "https://app.stocks.news");
              }
              //OPEN WHEN LIVE
              // try {
              //   if (onTap != null) onTap();
              // } catch (e){
              //   Utils().showLog("---$e");
              // }
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
