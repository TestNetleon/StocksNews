import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class AppMaintenance extends StatefulWidget {
  static const path = "ServerErrorWidget";

  const AppMaintenance({
    required this.onClick,
    this.log,
    this.title,
    this.description,
    super.key,
  });

  final dynamic onClick;
  final String? log;
  final String? title;
  final String? description;
  // final String? image;

  @override
  State<AppMaintenance> createState() => _ServerErrorState();
}

class _ServerErrorState extends State<AppMaintenance> {
  bool isInternetError = false;
  bool checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkForInternet();
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

  Future _checkForMaintenanceMode() async {
    MyHomeManager provider = context.read<MyHomeManager>();

    setState(() {
      checking = true;
    });
    bool isUnderMaintenance = await provider.checkMaintenanceMode() ?? true;

    setState(() {
      checking = false;
    });

    if (!isUnderMaintenance) {
      provider.getHomeData();
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Tabs()),
      );
    }
  }

  @override
  void dispose() {
    isShowingError = false;
    callCheckServer = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeManager>().isDarkMode;
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: double.infinity,
        color: ThemeColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isInternetError)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                // margin: const EdgeInsets.only(bottom: 50),
                child: Image.asset(
                  isDark ? Images.mainLogo : Images.mainBlackLogo,
                  width: ScreenUtil().screenWidth * .6,
                  height: ScreenUtil().screenWidth * .2,
                ),
              ),
            if (isInternetError)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 50),
                child: Image.asset(
                  Images.connectionGIF,
                  width: ScreenUtil().screenWidth * .6,
                ),
              ),
            const SpacerVertical(height: 20),
            Text(
              isInternetError
                  ? "You're Offline"
                  : widget.title != null
                      ? "${widget.title}"
                      : "App Under Maintenance",
              textAlign: TextAlign.center,
              style: styleBaseBold(fontSize: 30),
            ),
            const SpacerVertical(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                isInternetError
                    ? "There's a problem with your internet connection.\nPlease ensure you have a stable internet connection."
                    : widget.description != null
                        ? "${widget.description}"
                        : "Scheduled maintenance in progress.\nWe'll be back soon. Thanks for your support!",
                textAlign: TextAlign.center,
                style: styleBaseBold(fontSize: 14),
              ),
            ),
            if (kDebugMode && widget.log != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  widget.log ?? "",
                  textAlign: TextAlign.center,
                  style: styleBaseBold(fontSize: 14),
                ),
              ),
            const SpacerVertical(),
            checking
                ? Image.asset(
                    Images.progressGIF,
                    width: 100,
                    height: 100,
                  )
                : ThemeButtonSmall(
                    onPressed: () async {
                      if (isInternetError) {
                        bool isNet = await _checkForInternet();
                        if (isNet) {
                          // Navigator.pop(context);
                          isShowingError = false;
                          Navigator.popUntil(navigatorKey.currentContext!,
                              (route) => route.isFirst);
                          Navigator.pushReplacement(
                            navigatorKey.currentContext!,
                            MaterialPageRoute(builder: (_) => const Tabs()),
                          );
                        }
                      } else {
                        _checkForMaintenanceMode();
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
