// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

class DemoWeb extends StatefulWidget {
  const DemoWeb({super.key});

  @override
  State<DemoWeb> createState() => _DemoWebState();
}

class _DemoWebState extends State<DemoWeb> {
  void _showAlert({required title, description, image, onClick}) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return SafeArea(
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 10.0,
                backgroundColor: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (image != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        child: CachedNetworkImagesWidget(
                          image ??
                              "https://img.freepik.com/free-vector/gradient-stock-market-concept_23-2149166910.jpg?t=st=1716027320~exp=1716030920~hmac=fb2ed98c07151bfa1e80148a0a59fc074a616b58d6d9ceca573c8bf414731371&w=720",
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title ?? 'Dialog Title',
                            style: stylePTSansBold(color: Colors.black),
                          ),
                          if (description != null)
                            Container(
                              margin: EdgeInsets.only(top: 5.sp),
                              child: Text(
                                description ??
                                    'This is a custom dialog with a different style.',
                                style: stylePTSansRegular(color: Colors.black),
                              ),
                            ),
                          if (onClick != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Okay',
                                    style: stylePTSansRegular(
                                      color: ThemeColors.buttonBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      },
    );

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Dialog(
    //     );
    //   },
    // );
  }

  void _showAlert2({required title, description, image, onClick}) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return SafeArea(
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 10.0,
                  backgroundColor: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              title,
                              style: stylePTSansBold(color: Colors.black),
                            ),
                            if (image != null)
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                child: const CachedNetworkImagesWidget(
                                  "https://img.freepik.com/free-vector/gradient-stock-market-concept_23-2149166910.jpg?t=st=1716027320~exp=1716030920~hmac=fb2ed98c07151bfa1e80148a0a59fc074a616b58d6d9ceca573c8bf414731371&w=720",
                                ),
                              ),
                            if (description != null)
                              Container(
                                margin: EdgeInsets.only(top: 5.sp),
                                child: Text(
                                  description,
                                  style:
                                      stylePTSansRegular(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (onClick != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Okay',
                                      style: stylePTSansRegular(
                                        color: ThemeColors.buttonBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Dialog(
    //     );
    //   },
    // );
  }

  // void _showAlert2() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //         elevation: 10.0,
  //         backgroundColor: Colors.white,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(12.0),
  //               child: Column(
  //                 children: [
  //                   Text(
  //                     'Dialog Title',
  //                     style: stylePTSansBold(color: Colors.black),
  //                   ),
  //                   Container(
  //                     margin: const EdgeInsets.all(8.0),
  //                     child: const CachedNetworkImagesWidget(
  //                       "https://img.freepik.com/free-vector/gradient-stock-market-concept_23-2149166910.jpg?t=st=1716027320~exp=1716030920~hmac=fb2ed98c07151bfa1e80148a0a59fc074a616b58d6d9ceca573c8bf414731371&w=720",
  //                     ),
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.only(top: 5.sp),
  //                     child: Text(
  //                       'This is a custom dialog with a different style.',
  //                       style: stylePTSansRegular(color: Colors.black),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       TextButton(
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                         child: Text(
  //                           'Okay',
  //                           style: stylePTSansRegular(
  //                               color: ThemeColors.buttonBlue),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showAlert3({required image, onClick}) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return SafeArea(
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 10.0,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.sp),
                    child: const CachedNetworkImagesWidget(
                      "https://img.freepik.com/free-vector/gradient-stock-market-concept_23-2149166910.jpg?t=st=1716027320~exp=1716030920~hmac=fb2ed98c07151bfa1e80148a0a59fc074a616b58d6d9ceca573c8bf414731371&w=720",
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Dialog(
    //     );
    //   },
    // );
  }

  // void _showAlert3() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //         elevation: 10.0,
  //         backgroundColor: Colors.white,
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(12.sp),
  //           child: const CachedNetworkImagesWidget(
  //             "https://img.freepik.com/free-vector/gradient-stock-market-concept_23-2149166910.jpg?t=st=1716027320~exp=1716030920~hmac=fb2ed98c07151bfa1e80148a0a59fc074a616b58d6d9ceca573c8bf414731371&w=720",
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showAlert4({required title, description, image, onClick}) {
  //   showGeneralDialog(
  //       barrierColor: Colors.black.withOpacity(0.5),
  //       transitionBuilder: (context, a1, a2, widget) {
  //         return SafeArea(
  //           child: Transform.scale(
  //             scale: a1.value,
  //             child: Opacity(
  //               opacity: a1.value,
  //               child: Dialog(
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(16.0),
  //                 ),
  //                 elevation: 10.0,
  //                 backgroundColor: Colors.white,
  //                 child: Container(
  //                   padding: EdgeInsets.all(12.sp),
  //                   child: Row(
  //                     children: [
  //                       if (image != null)
  //                         Container(
  //                           margin: EdgeInsets.only(right: 10.sp),
  //                           width: ScreenUtil().screenWidth * .20,
  //                           child: const AspectRatio(
  //                             aspectRatio: 4 / 3,
  //                             child: CachedNetworkImagesWidget(
  //                               "https://img.freepik.com/free-vector/gradient-stock-market-concept_23-2149166910.jpg?t=st=1716027320~exp=1716030920~hmac=fb2ed98c07151bfa1e80148a0a59fc074a616b58d6d9ceca573c8bf414731371&w=720",
  //                             ),
  //                           ),
  //                         ),
  //                       Flexible(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Text(
  //                               title,
  //                               style: stylePTSansBold(color: Colors.black),
  //                             ),
  //                             if (description != null)
  //                               Container(
  //                                 margin: EdgeInsets.only(top: 5.sp),
  //                                 child: Text(
  //                                   description,
  //                                   style:
  //                                       stylePTSansRegular(color: Colors.black),
  //                                 ),
  //                               ),
  //                             // Row(
  //                             //   mainAxisAlignment: MainAxisAlignment.end,
  //                             //   children: [
  //                             //     TextButton(
  //                             //       onPressed: () {
  //                             //         Navigator.pop(context);
  //                             //       },
  //                             //       child: Text(
  //                             //         'Okay',
  //                             //         style: stylePTSansRegular(
  //                             //           color: ThemeColors.buttonBlue,
  //                             //         ),
  //                             //       ),
  //                             //     ),
  //                             //   ],
  //                             // ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       transitionDuration: const Duration(milliseconds: 200),
  //       barrierDismissible: true,
  //       barrierLabel: '',
  //       context: context,
  //       pageBuilder: (context, animation1, animation2) {
  //         return const SizedBox();
  //       });
  //   // showDialog(
  //   //   context: context,
  //   //   builder: (BuildContext context) {
  //   //     return Dialog(
  //   //     );
  //   //   },
  //   // );
  // }

  void _showAlert4({required title, description, image, onClick}) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return SafeArea(
            child: Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                opacity: a1.value,
                child: Dialog(
                  alignment: Alignment.topCenter,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 10.0,
                  backgroundColor: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(12.sp),
                    child: Row(
                      children: [
                        if (image != null)
                          Container(
                            margin: EdgeInsets.only(right: 10.sp),
                            width: ScreenUtil().screenWidth * .20,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: CachedNetworkImagesWidget(image ?? ""),
                            ),
                          ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Dialog Title',
                                style: stylePTSansBold(color: Colors.black),
                              ),
                              if (description != null)
                                Container(
                                  margin: EdgeInsets.only(top: 5.sp),
                                  child: Text(
                                    description,
                                    style:
                                        stylePTSansRegular(color: Colors.black),
                                  ),
                                ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     TextButton(
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //       },
                              //       child: Text(
                              //         'Okay',
                              //         style: stylePTSansRegular(
                              //           color: ThemeColors.buttonBlue,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 450),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarHome(
        isHome: false,
        // showQR: false,
        // showTrailing: false,
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            _showAlert4(
              title: "Dialog Title",
              description: "This is description for this custom dialog",
              image:
                  "https://img.freepik.com/free-vector/gradient-stock-market-concept_23-2149166910.jpg?t=st=1716027320~exp=1716030920~hmac=fb2ed98c07151bfa1e80148a0a59fc074a616b58d6d9ceca573c8bf414731371&w=720",
              onClick: () {},
            );
          },
          child: Text(
            "Show InAppMessage",
            style: stylePTSansRegular(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
