// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:stocks_news_new/api/api_requester.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/api/apis.dart';
// import 'package:stocks_news_new/modals/user_res.dart';
// import 'package:stocks_news_new/modals/welcome_res.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/screens/homeSpash/scanner.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/database/preference.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';

// class Splash extends StatefulWidget {
//   static const String path = "splash";

//   const Splash({super.key});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
//   List<WelcomeRes>? welcome;

//   @override
//   void initState() {
//     super.initState();
//     splashLoaded = false;
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _startProcess();
//     });
//   }

//   @override
//   void dispose() {
//     splashLoaded = true;
//     super.dispose();
//   }

//   void _startProcess() async {
//     // _callAPI();

//     try {
//       PackageInfo packageInfo = await PackageInfo.fromPlatform();
//       appVersion = packageInfo.version;
//     } catch (e) {
//       //
//     }

//     try {
//       var deviceType = getDeviceType(
//         Size(ScreenUtil().screenWidth, ScreenUtil().scaleHeight),
//       );

//       if (deviceType == DeviceScreenType.tablet) {
//         isPhone = false;
//       } else if (deviceType == DeviceScreenType.mobile) {
//         isPhone = true;
//       }
//     } catch (e) {
//       //
//     }

//     try {
//       UserProvider provider = context.read<UserProvider>();
//       UserRes? user = await Preference.getUser();
//       if (user != null) {
//         provider.setUser(user);
//       } else {
//         provider.callAdvertiserAPI();
//       }
//       MessageRes? messageObject = await Preference.getLocalDataBase();

//       if (messageObject?.error != null) {
//         Const.errSomethingWrong = messageObject!.error!;
//       }

//       if (messageObject?.loading != null) {
//         Const.loadingMessage = messageObject!.loading!;
//       }
//     } catch (e) {
//       //
//     }
//     Timer(const Duration(seconds: 3), () {
//       // if (popHome) return;
//       // if (onDeepLinking) {
//       //   popHome = true;
//       //   return;
//       // }

//       // Navigator.pushReplacement(
//       //   navigatorKey.currentContext!,
//       //   MaterialPageRoute(builder: (_) => const HomeSplash()),
//       // );
//     });
//   }

//   void _callAPI() async {
//     bool firstTime = await Preference.getShowIntro();
//     if (firstTime) {
//       getWelcomeData();
//     }
//   }

//   Future getWelcomeData() async {
//     try {
//       Map request = {"token": ""};

//       ApiResponse response = await apiRequest(
//         url: Apis.welcome,
//         request: request,
//         showProgress: false,
//       );
//       if (response.status) {
//         welcome = welcomeResFromJson(jsonEncode(response.data));
//         setState(() {});
//       } else {
//         welcome = null;
//       }
//     } catch (e) {
//       welcome = null;

//       Utils().showLog("Catch error $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseContainer(
//       bgColor: ThemeColors.splashBg,
//       body: Container(
//         alignment: Alignment.topCenter,
//         margin: EdgeInsets.only(top: ScreenUtil().screenHeight / 5),
//         padding: EdgeInsets.symmetric(horizontal: 47),
//         child: Image.asset(Images.mainLogo),
//       ),
//     );
//   }
// }
