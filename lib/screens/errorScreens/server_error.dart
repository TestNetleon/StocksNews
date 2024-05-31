// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class ServerError extends StatefulWidget {
  static const path = "ServerErrorWidget";

  const ServerError({
    required this.errorCode,
    required this.onClick,
    this.log,
    super.key,
  });

  final int errorCode;
  final dynamic onClick;
  final String? log;

  @override
  State<ServerError> createState() => _ServerErrorState();
}

class _ServerErrorState extends State<ServerError> {
  bool isInternetError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isInternetError = widget.errorCode == 0;
      });
      if (widget.errorCode != 0) _checkForInternet();
    });
  }

  Future<bool> _checkForInternet() async {
    final result = await (Connectivity().checkConnectivity());
    if (result[0] == ConnectivityResult.none && result.length == 1) {
      setState(() {
        isInternetError = true;
      });
    } else {
      setState(() {
        isInternetError = false;
      });
    }
    return isInternetError;
  }

  @override
  void dispose() {
    isShowingError = false;
    super.dispose();
  }

  // String _getErrorTitle() {
  //   switch (widget.errorCode) {
  //     case 400:
  //       return "Bad Request";
  //     case 401:
  //       return "Unauthorized";
  //     case 403:
  //       return "Forbidden";
  //     case 404:
  //       return "Not Found";
  //     case 405:
  //       return "Method Not Allowed";
  //     case 408:
  //       return "Request Timeout";
  //     case 429:
  //       return "Too Many Requests";
  //     case 500:
  //       return "Internal Server Error";
  //     case 503:
  //       return "Service Unavailable";
  //     case 504:
  //       return "Gateway Timeout";
  //     default:
  //       return "Service Unavailable";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                isInternetError
                    ? AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 50),
                        child: Image.asset(
                          Images.connectionGIF,
                          width: ScreenUtil().screenWidth * .6,
                        ),
                      )
                    : Lottie.asset(Images.serverErrorGIF),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Text(
                    isInternetError ? "You're Offline" : "Service Unavailable",
                    textAlign: TextAlign.center,
                    style: styleGeorgiaBold(fontSize: 30),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                isInternetError
                    ? "There's a problem with your internet connection.\nPlease ensure you have a stable internet connection."
                    : "Apologies for the inconvenience.\nPlease bear with us while we are fixing it.",
                textAlign: TextAlign.center,
                style: styleGeorgiaBold(fontSize: 14),
              ),
            ),
            if (kDebugMode && widget.log != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  widget.log ?? "",
                  textAlign: TextAlign.center,
                  style: styleGeorgiaBold(fontSize: 14),
                ),
              ),
            const SpacerVertical(),
            ThemeButtonSmall(
              onPressed: () async {
                if (widget.onClick != null && !isInternetError) {
                  isShowingError = false;
                  Navigator.pop(context);
                  widget.onClick();
                } else if (isInternetError) {
                  bool isNet = await _checkForInternet();
                  if (isNet) {
                    isShowingError = false;
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacementNamed(context, Tabs.path);
                  }
                } else {
                  isShowingError = false;
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, Tabs.path);
                }
              },
              showArrow: false,
              text: "Refresh",
              fontBold: true,
            ),
          ],
        ),
      ),
    );
  }
}
