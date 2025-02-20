// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/ui/base/button.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// class BaseLockItem extends StatelessWidget {
//   const BaseLockItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background Blur Effect
//         Positioned.fill(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//             child: Container(
//               color: Colors.transparent,
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           right: 0,
//           left: 0,
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: Pad.pad16,
//               vertical: Pad.pad10,
//             ),
//             alignment: Alignment.bottomCenter,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromRGBO(202, 209, 223, 0.6),
//                   offset: Offset(0, 4),
//                   blurRadius: 24,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Upgrade to Premium to Unlock Exclusive Features',
//                   style: styleBaseBold(fontSize: 26),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // DraggableScrollableSheet(
//         //   initialChildSize: 0.2,
//         //   minChildSize: 0.15,
//         //   maxChildSize: 0.5,
//         //   builder: (context, scrollController) {
//         //     return Container(
//         //       decoration: const BoxDecoration(
//         //         color: Colors.white,
//         //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//         //       ),
//         //       child: SingleChildScrollView(
//         //         controller: scrollController,
//         //         child: Padding(
//         //           padding: const EdgeInsets.all(16.0),
//         //           child: Column(
//         //             crossAxisAlignment: CrossAxisAlignment.start,
//         //             children: [
//         //               Center(
//         //                 child: Container(
//         //                   width: 40,
//         //                   height: 5,
//         //                   margin: const EdgeInsets.only(bottom: 8),
//         //                   decoration: BoxDecoration(
//         //                     color: Colors.grey[400],
//         //                     borderRadius: BorderRadius.circular(10),
//         //                   ),
//         //                 ),
//         //               ),
//         //               const Text(
//         //                 "Upgrade to Premium",
//         //                 style: TextStyle(
//         //                     fontSize: 18, fontWeight: FontWeight.bold),
//         //               ),
//         //               const SizedBox(height: 20),
//         //               const Text(
//         //                 "Premium Benefits:",
//         //                 style: TextStyle(
//         //                     fontSize: 16, fontWeight: FontWeight.w600),
//         //               ),
//         //               const SizedBox(height: 10),
//         //               const Column(
//         //                 crossAxisAlignment: CrossAxisAlignment.start,
//         //                 children: [
//         //                   ListTile(
//         //                     leading: Icon(Icons.check, color: Colors.green),
//         //                     title: Text("Access exclusive articles"),
//         //                   ),
//         //                   ListTile(
//         //                     leading: Icon(Icons.check, color: Colors.green),
//         //                     title: Text("Ad-free experience"),
//         //                   ),
//         //                   ListTile(
//         //                     leading: Icon(Icons.check, color: Colors.green),
//         //                     title: Text("Early access to new features"),
//         //                   ),
//         //                 ],
//         //               ),
//         //               const SizedBox(height: 10),
//         //               BaseButton(
//         //                 onPressed: () {},
//         //                 text: 'Subscribe Now',
//         //               ),
//         //               const SizedBox(height: 10),
//         //             ],
//         //           ),
//         //         ),
//         //       ),
//         //     );
//         //   },
//         // ),
//       ],
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../managers/user.dart';
import '../../models/lock.dart';
import '../../routes/my_app.dart';
import '../../service/revenue_cat.dart';

class BaseLockItem extends StatefulWidget {
  final dynamic manager;

  final Future Function()? callAPI;

  const BaseLockItem({
    super.key,
    this.callAPI,
    required this.manager,
  });

  @override
  State<BaseLockItem> createState() => _BaseLockItemState();
}

class _BaseLockItemState extends State<BaseLockItem> {
  bool isVisible = true;
  bool showPoints = false;

  @override
  void dispose() {
    isVisible = false;
    super.dispose();
  }

  void _toggleSheet(value) {
    showPoints = value;
    setState(() {});
  }

  Future _subscribe(
    BaseLockInfoRes info, {
    Future Function()? callAPI,
    required dynamic manager,
  }) async {
    UserManager userManager = navigatorKey.currentContext!.read<UserManager>();
    UserRes? user = userManager.user;

    if (user == null) {
      if (kDebugMode) {
        print("🛑 User is not logged in. Asking for login screen...");
      }
      await userManager.askLoginScreen();

      user = userManager.user;
      if (user == null) {
        if (kDebugMode) {
          print("🛑 User did not log in. Exiting...");
        }
        return;
      }

      if (user.signupStatus == true) {
        if (kDebugMode) {
          print("🛑 User signup. Exiting...");
        }
        return;
      }

      if (user.phone == null || user.phone?.isEmpty == true) {
        if (kDebugMode) {
          print("User has no phone number. Skipping API call...");
        }
        return;
      }

      if (callAPI != null) await callAPI();
    }

    if (user.phone == null || user.phone!.isEmpty) {
      if (kDebugMode) {
        print("User phone number is missing. Prompting for update...");
      }
      return;
    }

    BaseLockInfoRes? lockInfo = manager.getLockINFO();
    if (lockInfo == null) {
      if (kDebugMode) {
        print("🛑 Lock info is null. Exiting...");
      }
      return;
    }

    if (kDebugMode) {
      print("User has a valid phone number and lock info is available.");
    }
    if (kDebugMode) {
      print("🚀 Initializing RevenueCat subscription...");
    }
    await RevenueCatService.initializeSubscription();
  }

  @override
  Widget build(BuildContext context) {
    BaseLockInfoRes? info = widget.manager.getLockINFO();
    if (info == null) {
      return SizedBox();
    }
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        isVisible = false;
        setState(() {});
      },
      child: Stack(
        children: [
          // Background Blur Effect
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),

          // Positioned.fill(
          //   child: BackdropFilter(
          //     enabled: isVisible,
          //     filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          //     child: Container(
          //       color: Colors.transparent,
          //     ),
          //   ),
          // ),

          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! < -10) {
                  _toggleSheet(true); // Swipe Up to Expand
                } else if (details.primaryDelta! > 10) {
                  _toggleSheet(false); // Swipe Down to Collapse
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Pad.pad16,
                  vertical: Pad.pad10,
                ),
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(202, 209, 223, 0.6),
                      offset: Offset(0, 4),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                            color: ThemeColors.neutral10,
                            borderRadius: BorderRadius.circular(30)),
                        height: 6,
                        width: 48,
                      ),
                    ),
                    SpacerVertical(height: 24),
                    Text(
                      info.title ??
                          'Upgrade to Premium to Unlock Exclusive Features',
                      style: styleBaseBold(fontSize: 26),
                    ),
                    SpacerVertical(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        child: Visibility(
                          visible: showPoints,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                info.text?.length ?? 0,
                                (index) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          Images.tickCircle,
                                          height: 32,
                                          width: 32,
                                          color: ThemeColors.secondary100,
                                        ),
                                        Flexible(
                                          child: HtmlWidget(
                                            info.text?[index] ?? '',
                                            textStyle: styleBaseRegular(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    BaseButton(
                      text: info.btn ?? 'Purchase Membership',
                      onPressed: () {
                        _subscribe(
                          info,
                          callAPI: widget.callAPI,
                          manager: widget.manager,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
