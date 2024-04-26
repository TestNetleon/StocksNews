// ignore_for_file: prefer_typing_uninitialized_variables

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class InternetConnectionWidget extends StatefulWidget {
  const InternetConnectionWidget({super.key});

  @override
  State<InternetConnectionWidget> createState() =>
      _InternetConnectionWidgetState();
}

class _InternetConnectionWidgetState extends State<InternetConnectionWidget> {
  var connectivityResult;
  Future<void> checkConnectivity() async {
    showGlobalProgressDialog();

    Future.delayed(const Duration(seconds: 2), () async {
      // var connectivity = Connectivity();
      // connectivityResult = await connectivity.checkConnectivity();

      // if (connectivityResult == ConnectivityResult.wifi) {
      //   Navigator.push(navigatorKey.currentContext!,
      //       MaterialPageRoute(builder: (_) => const Splash()));
      //   closeGlobalProgressDialog();
      // } else if (connectivityResult == ConnectivityResult.mobile) {
      //   Navigator.push(navigatorKey.currentContext!,
      //       MaterialPageRoute(builder: (_) => const Splash()));
      //   closeGlobalProgressDialog();
      // } else if (connectivityResult == ConnectivityResult.none) {
      //   showErrorMessage(message: "No internet connection ");
      //   closeGlobalProgressDialog();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool isPoped) {},
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("${Const.appName} App"),
          leading: null,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image.asset(Images.internetConnection),
                GestureDetector(
                  onTap: () => checkConnectivity(),
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: ThemeColors.primary,
                    child: Icon(
                      Icons.replay_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                SpacerVerticel(height: 14.sp),
                Text(
                  'No internet connection. Please check your connection and try again.',
                  style: stylePTSansBold(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
