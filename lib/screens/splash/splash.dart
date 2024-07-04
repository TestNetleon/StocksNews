import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/modals/welcome_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/homeSpash/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class Splash extends StatefulWidget {
  static const String path = "splash";

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

//
class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  List<WelcomeRes>? welcome;
  var deviceType;

  @override
  void initState() {
    super.initState();
    splashLoaded = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getAppVersion();
      _startProcess();
      // Preference.saveDataList(DeeplinkData(from: "Splash Loaded"));
    });
  }

  @override
  void dispose() {
    splashLoaded = true;
    super.dispose();
  }

  void _startProcess() async {
    // _callAPI();
    try {
      var deviceType = getDeviceType(
        Size(ScreenUtil().screenWidth, ScreenUtil().scaleHeight),
      );

      if (deviceType == DeviceScreenType.tablet) {
        isPhone = false;
      } else if (deviceType == DeviceScreenType.mobile) {
        isPhone = true;
      }
    } catch (e) {
      //
      // popUpAlert(message: "$e", title: "Error");
      // Navigator.pushAndRemoveUntil(context, Tabs.path, (route) => false);
    }

    Timer(const Duration(seconds: 3), () {
      _getDeviceType();
    });
  }

  void _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
    } catch (e) {
      //
    }
  }

  void _callAPI() async {
    bool firstTime = await Preference.getShowIntro();
    if (firstTime) {
      getWelcomeData();
    }
  }

  void _getDeviceType() async {
    try {
      UserProvider provider = context.read<UserProvider>();

      MessageRes? messageObject = await Preference.getLocalDataBase();

      if (messageObject?.error != null) {
        Const.errSomethingWrong = messageObject!.error!;
      }

      if (messageObject?.loading != null) {
        Const.loadingMessage = messageObject!.loading!;
      }

      UserRes? user = await Preference.getUser();
      if (user != null) {
        provider.setUser(user);
      }
    } catch (e) {
      //
    }
    _navigateToRequiredScreen();
  }

  Future _navigateToRequiredScreen() async {
    if (popHome) return;
    if (onDeepLinking) {
      popHome = true;
      return;
    }
    // Preference.saveDataList(
    //   DeeplinkData(
    //     from: "Navigating from Splash"
    //         "\n"
    //         " OnDeepLinking = $onDeepLinking "
    //         "\n"
    //         " PopHome = $popHome",
    //   ),
    // );
    // isAppUpdating = false;

    // Navigator.pushReplacement(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(builder: (_) => const Tabs()),
    // );
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const HomeSplash()),
    );
    // Navigator.pushReplacement(
    //   navigatorKey.currentContext!,
    //   Tabs.path,
    //   // HomeSplash.path,
    // );

    // bool firstTime = await Preference.getShowIntro();
    // if (firstTime) {
    //   if (welcome?.isEmpty == true || welcome == null) {
    //     // Navigator.pushAndRemoveUntil(
    //     //     navigatorKey.currentContext!, Tabs.path, (route) => false);
    //     // Navigator.pushReplacement(
    //     //     navigatorKey.currentContext!, HomeSplash.path);
    //   } else {
    //     Navigator.pushAndRemoveUntil(
    //       navigatorKey.currentContext!,
    //       MaterialPageRoute(
    //         builder: (context) => StartIndex(welcome: welcome),
    //       ),
    //       (route) => false,
    //     );
    //   }
    // } else {
    //   // Navigator.pushAndRemoveUntil(
    //   //     navigatorKey.currentContext!, Tabs.path, (route) => false);
    //   Navigator.pushReplacement(
    //     navigatorKey.currentContext!,
    //     HomeSplash.path,
    //   );
    //   // Navigator.push(
    //   //     navigatorKey.currentContext!,
    //   //     MaterialPageRoute(
    //   //       builder: (context) => const ReferSuccess(),
    //   //     ));
    // }
    // // Navigator.pushAndRemoveUntil(
    // //     navigatorKey.currentContext!, Tabs.path, (route) => false);
  }

  Future getWelcomeData() async {
    try {
      Map request = {"token": ""};

      ApiResponse response = await apiRequest(
        url: Apis.welcome,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        welcome = welcomeResFromJson(jsonEncode(response.data));
        setState(() {});
      } else {
        //
        welcome = null;
      }
    } catch (e) {
      welcome = null;

      Utils().showLog("Catch error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .6,
          height: MediaQuery.of(context).size.width * .6,
          child: Image.asset(Images.logo),
        ),
      ),
    );
  }
}
