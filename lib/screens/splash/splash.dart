import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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
import 'package:stocks_news_new/screens/start/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import '../tabs/tabs.dart';

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
    getWelcomeData();

    Timer(const Duration(seconds: 3), () {
      _getDeviceType();
    });
  }

  void _getDeviceType() async {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    if (deviceType == DeviceScreenType.tablet) {
      isPhone = false;
    } else if (deviceType == DeviceScreenType.mobile) {
      isPhone = true;
    }

    UserProvider provider = context.read<UserProvider>();
    UserRes? user = await Preference.getUser();

    if (user != null) {
      log("-------FROM SPLASH USER UPDATING---------");
      provider.setUser(user);
    }

    _navigateToRequiredScreen();
  }

  void _navigateToRequiredScreen() async {
    bool firstTime = // kDebugMode ? true :
        await Preference.getFirstTime();
    log("--First Time $firstTime");
    if (firstTime) {
      if (welcome?.isEmpty == true || welcome == null) {
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!, Tabs.path, (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => StartIndex(welcome: welcome),
          ),
          (route) => false,
        );
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!, Tabs.path, (route) => false);
    }
    // Navigator.pushNamedAndRemoveUntil(
    //     navigatorKey.currentContext!, Tabs.path, (route) => false);
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
