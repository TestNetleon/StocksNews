import 'package:flutter/material.dart';
import 'package:stocks_news_new/route/my_app.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/screens/auth/otp/otp_login.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/widgets/progress_dialog.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:webview_flutter/webview_flutter.dart';

morningStarInfoSheet({required String data}) async {
  await showModalBottomSheet(
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(5.sp),
        topRight: Radius.circular(5.sp),
      ),
    ),
    backgroundColor: ThemeColors.transparent,
    isScrollControlled: true,
    context: navigatorKey.currentContext!,
    builder: (context) {
      return MorningStarInfo(data: data);
    },
  );
}

class MorningStarInfo extends StatefulWidget {
  final String data;
  const MorningStarInfo({required this.data, super.key});

  @override
  State<MorningStarInfo> createState() => _MorningStarInfoState();
}

class _MorningStarInfoState extends State<MorningStarInfo> {
  WebViewController controller = WebViewController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  setLoading(value) {
    setState(() {
      loading = value;
    });
  }

  void _setData() {
    String styledData = """
  <!DOCTYPE html>
  <html>
  <head>
    <style>
      body {
        color: white; /* Set your desired text color here */
        font-family: Arial, sans-serif; /* Set your desired font family here */
        font-size: 40px; /* Set your desired font size here */
        padding-bottom: 50px;
      }
    </style>
  </head>
  <body>
    ${widget.data}
  </body>
  </html>
  """;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadHtmlString(styledData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.sp),
          topRight: Radius.circular(10.sp),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ThemeColors.bottomsheetGradient, Colors.black],
        ),
        color: ThemeColors.background,
        border: const Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.9,
        maxChildSize: 1.0,
        expand: true,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 6.sp,
                  width: 50.sp,
                  margin: EdgeInsets.only(top: 8.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    color: ThemeColors.greyBorder,
                  ),
                ),
                const SpacerVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.all(Dimen.authScreenPadding),
                  child: loading
                      ? const ProgressDialog()
                      : Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.9,
                          ),
                          child: WebViewWidget(controller: controller),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(10.sp),
  //         topRight: Radius.circular(10.sp),
  //       ),
  //       gradient: const LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [ThemeColors.bottomsheetGradient, Colors.black],
  //       ),
  //       color: ThemeColors.background,
  //       border: const Border(
  //         top: BorderSide(color: ThemeColors.greyBorder),
  //       ),
  //     ),

  //     child: DraggableScrollableSheet(
  //       initialChildSize: 1.0,
  //       minChildSize: 0.5,
  //       maxChildSize: 1.0,
  //       // expand: true,
  //       builder: (BuildContext context, ScrollController scrollController) {
  //         return SingleChildScrollView(
  //           controller: scrollController,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             // mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Container(
  //                 height: 6.sp,
  //                 width: 50.sp,
  //                 margin: EdgeInsets.only(top: 8.sp),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10.sp),
  //                   color: ThemeColors.greyBorder,
  //                 ),
  //               ),
  //               const SpacerVertical(height: 10),
  //               Container(
  //                 height: MediaQuery.of(context).size.height * 0.9,
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(Dimen.authScreenPadding),
  //                   child: loading
  //                       ? const ProgressDialog()
  //                       : SingleChildScrollView(
  //                           controller: scrollController,
  //                           child: WebViewWidget(controller: controller),
  //                         ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     ),

  //     // child: Column(
  //     //   crossAxisAlignment: CrossAxisAlignment.center,
  //     //   mainAxisSize: MainAxisSize.max,
  //     //   children: [
  //     //     Container(
  //     //       height: 6.sp,
  //     //       width: 50.sp,
  //     //       margin: EdgeInsets.only(top: 8.sp),
  //     //       decoration: BoxDecoration(
  //     //         borderRadius: BorderRadius.circular(10.sp),
  //     //         color: ThemeColors.greyBorder,
  //     //       ),
  //     //     ),
  //     //     const SpacerVertical(height: 10),
  //     //     Expanded(
  //     //       child: DraggableScrollableSheet(
  //     //           expand: true,
  //     //           builder:
  //     //               (BuildContext context, ScrollController scrollController) {
  //     //             return Padding(
  //     //               padding: const EdgeInsets.all(Dimen.authScreenPadding),
  //     //               child: loading
  //     //                   ? const ProgressDialog()
  //     //                   : WebViewWidget(
  //     //                       controller: controller,
  //     //                       gestureRecognizers: Set()
  //     //                         ..add(Factory<VerticalDragGestureRecognizer>(
  //     //                             () => VerticalDragGestureRecognizer())),
  //     //                     ),
  //     //             );
  //     //           }),
  //     //     ),
  //     //   ],
  //     // ),
  //   );
  // }
}
