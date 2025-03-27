import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/modals/welcome_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/onboarding/default_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../base/scaffold.dart';
import '../../managers/onboarding.dart';

//MARK: Splash
class Splash extends StatefulWidget {
  static const String path = "Splash";

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  List<WelcomeRes>? welcome;

  @override
  void initState() {
    super.initState();
    splashLoaded = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _callAPI();
      _startProcess();
    });
  }

  @override
  void dispose() {
    splashLoaded = true;
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
    Timer(const Duration(seconds: 3), () {
      if (popHome) return;
      if (onDeepLinking) {
        popHome = true;
        return;
      }

      Navigator.pushReplacementNamed(
          navigatorKey.currentContext!, DefaultHome.path);
    });
  }

  void _callAPI() async {
    bool firstTime = await Preference.getShowIntro();
    Utils().showLog('FIRST TIME $firstTime');
    if (firstTime) {
      OnboardingManager provider = context.read<OnboardingManager>();
      provider.getOnBoardingData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      bgColor: ThemeColors.splashBackground,
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: ScreenUtil().screenHeight / 5),
        padding: EdgeInsets.symmetric(horizontal: 47),
        child: Image.asset(Images.mainLogo),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/managers/user.dart';
// import 'package:stocks_news_new/modals/user_res.dart';
// import 'package:stocks_news_new/modals/welcome_res.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/ui/onboarding/default_home.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/database/preference.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import '../base/scaffold.dart';
// import '../../managers/onboarding.dart';
// import 'package:http/http.dart' as http;

// class Splash extends StatefulWidget {
//   final String? from;
//   static const String path = "Splash";

//   const Splash({super.key, this.from});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
//   List<WelcomeRes>? welcome;
//   bool hasNavigated = false; // Prevent multiple navigation

//   @override
//   void initState() {
//     super.initState();
//     splashLoaded = false;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       saveSource(widget.from ?? 'none');
//       _callAPI();
//       _startProcess();
//     });
//   }

//   @override
//   void dispose() {
//     splashLoaded = true;
//     super.dispose();
//   }

//   // Future<void> _saveSource(String source) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   List<String> sources = prefs.getStringList('splash_sources') ?? [];

//   //   sources.add(source); // Add the new source to the list
//   //   await prefs.setStringList('splash_sources', sources);
//   // }

//   void _startProcess() async {
//     if (hasNavigated) return;
//     hasNavigated = true;

//     try {
//       PackageInfo packageInfo = await PackageInfo.fromPlatform();
//       appVersion = packageInfo.version;
//     } catch (e) {
//       if (kDebugMode) print("Error in fetching package info: $e");
//     }

//     try {
//       var deviceType = getDeviceType(
//         Size(ScreenUtil().screenWidth, ScreenUtil().scaleHeight),
//       );
//       isPhone = deviceType == DeviceScreenType.mobile;
//     } catch (e) {
//       if (kDebugMode) print("Error in device type detection: $e");
//     }

//     try {
//       UserManager provider = context.read<UserManager>();
//       UserRes? user = await Preference.getUser();
//       if (user != null) provider.setUser(user);

//       MessageRes? messageObject = await Preference.getLocalDataBase();
//       if (messageObject?.error != null) {
//         Const.errSomethingWrong = messageObject!.error!;
//       }
//       if (messageObject?.loading != null) {
//         Const.loadingMessage = messageObject!.loading!;
//       }
//     } catch (e) {
//       if (kDebugMode) print("Error in fetching user data: $e");
//     }

//     /// Ensure splash waits at least 3 seconds before navigating
//     bool hasWaited = await _waitForSplashDelay();

//     if (mounted && hasWaited && navigatorKey.currentContext != null) {
//       saveSource('popHome $popHome');
//       saveSource('onDeepLinking $onDeepLinking');
//       saveSource('context is null? ${navigatorKey.currentContext == null}');

//       if (popHome) return;
//       if (onDeepLinking) {
//         popHome = true;
//         return;
//       }

//       Navigator.pushReplacementNamed(
//           navigatorKey.currentContext!, DefaultHome.path);
//     }
//   }

//   /// Ensures the splash waits for at least 3 seconds
//   Future<bool> _waitForSplashDelay() async {
//     await Future.delayed(const Duration(seconds: 3));
//     return true;
//   }

//   void _callAPI() async {
//     bool firstTime = await Preference.getShowIntro();
//     Utils().showLog('FIRST TIME $firstTime');

//     if (firstTime) {
//       OnboardingManager provider = context.read<OnboardingManager>();
//       provider.getOnBoardingData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       bgColor: ThemeColors.splashBackground,
//       body: Container(
//         alignment: Alignment.topCenter,
//         margin: EdgeInsets.only(top: ScreenUtil().screenHeight / 5),
//         padding: const EdgeInsets.symmetric(horizontal: 47),
//         child: Image.asset(Images.mainLogo),
//       ),
//     );
//   }
// }

// //MARK: Ping
// Future<void> pingApi(UserRes? user) async {
//   const String url = 'https://api.stocks.news/v1/ping';
//   String? fcmToken = await Preference.getFcmToken();

//   final Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'X-API-Token ${user?.token ?? ''}:${fcmToken ?? ''}',
//     'Cache-Control': 'no-cache'
//   };

//   try {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: headers,
//     );

//     if (response.statusCode == 200) {
//       if (kDebugMode) print('Success: ${response.body}');
//     } else {
//       if (kDebugMode) print('Error: ${response.statusCode} - ${response.body}');
//     }
//   } catch (e) {
//     if (kDebugMode) print('Exception: $e');
//   }
// }

// Future<void> saveSource(String source) async {
//   final prefs = await SharedPreferences.getInstance();
//   List<String> sources = prefs.getStringList('splash_sources') ?? [];

//   sources.add(source); // Add the new source to the list
//   await prefs.setStringList('splash_sources', sources);
// }
