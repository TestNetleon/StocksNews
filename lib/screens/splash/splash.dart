import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class Splash extends StatefulWidget {
  static const String path = "splash";

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

//
class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      _getDeviceType();
      _navigateToRequiredScreen();
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

    if (provider.user == null) {
      log("-------FROM SPLASH USER UPDATING---------");
      provider.setUser(user!);
    }
  }

  void _navigateToRequiredScreen() {
    // UserProvider provider = context.read<UserProvider>();
    // if (await provider.checkForUser()) {
    //   // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);
    // } else {
    //   // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Login.path);
    // }

    Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!, Tabs.path, (route) => false);
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
