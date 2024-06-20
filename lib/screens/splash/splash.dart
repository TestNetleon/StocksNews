import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _startProcess();
    });
  }

  void _startProcess() async {
    // final connection = await _checkForConnection();
    // if (!connection) return;

    // _callAPI();
    Timer(const Duration(seconds: 3), () {
      _getDeviceType();
    });
  }

  // Future<bool> _checkForConnection() async {
  //   try {
  //     final result = await (Connectivity().checkConnectivity());
  //     if (result[0] == ConnectivityResult.none && result.length == 1) {
  //       isShowingError = true;
  //       showErrorFullScreenDialog(
  //           errorCode: 0, onClick: null, log: "From Splash");
  //       return false;
  //     }
  //   } catch (e) {
  //     return true;
  //   }
  //   return true;
  // }

  void _callAPI() async {
    bool firstTime = await Preference.getShowIntro();
    if (firstTime) {
      getWelcomeData();
    }
  }

  void _getDeviceType() async {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    UserProvider provider = context.read<UserProvider>();

    MessageRes? messageObject = await Preference.getLocalDataBase();

    if (messageObject?.error != null) {
      Const.errSomethingWrong = messageObject!.error!;
    }
    if (messageObject?.loading != null) {
      Const.loadingMessage = messageObject!.loading!;
    }

    if (deviceType == DeviceScreenType.tablet) {
      isPhone = false;
    } else if (deviceType == DeviceScreenType.mobile) {
      isPhone = true;
    }

    UserRes? user = await Preference.getUser();
    if (user != null) {
      Utils().showLog("-------FROM SPLASH USER UPDATING---------");
      provider.setUser(user);
    }

    _navigateToRequiredScreen();
  }

  Future _navigateToRequiredScreen() async {
    Navigator.pushReplacementNamed(
        navigatorKey.currentContext!, HomeSplash.path);

    // bool firstTime = await Preference.getShowIntro();

    // if (firstTime) {
    //   if (welcome?.isEmpty == true || welcome == null) {
    //     // Navigator.pushNamedAndRemoveUntil(
    //     //     navigatorKey.currentContext!, Tabs.path, (route) => false);
    //     // Navigator.pushReplacementNamed(
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
    //   // Navigator.pushNamedAndRemoveUntil(
    //   //     navigatorKey.currentContext!, Tabs.path, (route) => false);

    //   Navigator.pushReplacementNamed(
    //     navigatorKey.currentContext!,
    //     HomeSplash.path,
    //   );
    //   // Navigator.push(
    //   //     navigatorKey.currentContext!,
    //   //     MaterialPageRoute(
    //   //       builder: (context) => const ReferSuccess(),
    //   //     ));
    // }

    // // Navigator.pushNamedAndRemoveUntil(
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
