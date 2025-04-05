import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/managers/onboarding.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/onboarding/default_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:video_player/video_player.dart';

class SplashFirstTime extends StatefulWidget {
  static const path = 'SplashFirstTime';
  const SplashFirstTime({super.key});

  @override
  State<SplashFirstTime> createState() => _SplashFirstTimeState();
}

class _SplashFirstTimeState extends State<SplashFirstTime> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
      _startProcess();
    });

    _controller = VideoPlayerController.asset(Images.splashVideo)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    // _controller.addListener(() {
    //   if (_controller.value.isCompleted) {
    //     navigateToNextScreen();
    //   }
    // });

    Future.delayed(
      Duration(seconds: 5),
      () {
        navigateToNextScreen();
      },
    );
  }

  void navigateToNextScreen() async {
    if (mounted) {
      try {
        UserManager provider = context.read<UserManager>();
        UserRes? user = await Preference.getUser();
        if (user != null) {
          provider.setUser(user);
        } else {
          //
        }
        MessageRes? messageObject = await Preference.getLocalDataBase();

        if (messageObject?.error != null) {
          Const.errSomethingWrong = messageObject!.error!;
        }

        if (messageObject?.loading != null) {
          Const.loadingMessage = messageObject!.loading!;
        }
      } catch (e) {
        //
      }
      Utils().showLog('POP HOME1 $popHome, ON DEEP LINKING $onDeepLinking');
      if (popHome) return;
      if (onDeepLinking) {
        popHome = true;
        return;
      }

      // Navigator.pushReplacementNamed(
      //     navigatorKey.currentContext!, DefaultHome.path);

      Navigator.pushReplacement(navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => DefaultHome()));
    }
  }

  @override
  void dispose() {
    splashLoaded = true;
    _controller.dispose();
    super.dispose();
  }

  void _startProcess() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
    } catch (e) {
      //
    }

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
    }
  }

  void _callAPI() async {
    bool firstTime = await Preference.isFirstOpen();
    Utils().showLog('FIRST TIME $firstTime');
    if (firstTime) {
      OnboardingManager provider = context.read<OnboardingManager>();
      provider.getOnBoardingData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? Stack(
              children: [
                Positioned.fill(
                  child: VideoPlayer(_controller),
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
