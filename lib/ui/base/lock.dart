import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/subscription/action_required.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../managers/user.dart';
import '../../models/lock.dart';
import '../../routes/my_app.dart';

class BaseLockItem extends StatefulWidget {
  final dynamic manager;
  final bool lockWithImage;

  final Future Function()? callAPI;

  const BaseLockItem({
    super.key,
    this.callAPI,
    this.lockWithImage = true,
    required this.manager,
  });

  @override
  State<BaseLockItem> createState() => _BaseLockItemState();
}

class _BaseLockItemState extends State<BaseLockItem> {
  bool isVisible = true;
  bool showPoints = true;

  void _toggleSheet(value) {
    showPoints = value;
    setState(() {});
  }

  @override
  void dispose() {
    isVisible = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BaseLockInfoRes? info = widget.manager.getLockINFO();
    // print('----$info');
    if (info == null) {
      return SizedBox();
    }

    ThemeManager manager = context.read<ThemeManager>();
    String? image = manager.isDarkMode ? info.imageDark : info.image;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        isVisible = false;
        setState(() {});
      },
      child: OptionalParent(
        addParent: widget.lockWithImage,
        parentBuilder: (child) {
          return Stack(
            children: [
              // Background Blur Effect
              Positioned.fill(
                child: image != null && image != ''
                    ? CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Container(
                            decoration: BoxDecoration(
                              color: ThemeColors.white,
                            ),
                          );
                        },
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: ThemeColors.white.withValues(alpha: 0.95),
                        ),
                      ),
              ),
              Positioned(bottom: 0, right: 0, left: 0, child: child),
            ],
          );
        },
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
            decoration: BoxDecoration(
              color: ThemeColors.white,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      Images.tickCircle,
                                      height: 32,
                                      width: 32,
                                      color: ThemeColors.secondary120,
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
                    baseSUBSCRIBE(
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
    );
  }
}

// Future baseSUBSCRIBE(
//   BaseLockInfoRes info, {
//   Future Function()? callAPI,
//   required dynamic manager,
// }) async {
//   UserManager userManager = navigatorKey.currentContext!.read<UserManager>();
//   UserRes? user = userManager.user;

//   if (user == null) {
//     if (kDebugMode) {
//       print("🛑 User is not logged in. Asking for login screen...");
//     }
//     await userManager.askLoginScreen();

//     user = userManager.user;
//     if (user == null) {
//       if (kDebugMode) {
//         print("🛑 User did not log in. Exiting...");
//       }
//       return;
//     }

//     if (user.signupStatus == true) {
//       if (kDebugMode) {
//         print("🛑 User signup. Exiting...");
//       }
//       return;
//     }

//     if (user.phone == null || user.phone?.isEmpty == true) {
//       if (kDebugMode) {
//         print("User has no phone number. Skipping API call...");
//       }
//       return;
//     }

//     if (callAPI != null) await callAPI();
//   }

//   if (user.phone == null || user.phone!.isEmpty) {
//     if (kDebugMode) {
//       print("User phone number is missing. Prompting for update...");
//     }
//     SubscriptionManager manager =
//         navigatorKey.currentContext!.read<SubscriptionManager>();
//     await manager.getMembershipLayout();
//     await Navigator.push(
//       navigatorKey.currentContext!,
//       createRoute(
//         MembershipActionRequired(),
//       ),
//     );
//   }

//   if (user.phone == null || user.phone!.isEmpty) return;

//   BaseLockInfoRes? lockInfo = manager.getLockINFO();
//   if (lockInfo == null) {
//     if (kDebugMode) {
//       print("🛑 Lock info is null. Exiting...");
//     }
//     return;
//   }

//   if (kDebugMode) {
//     print("User has a valid phone number and lock info is available.");
//   }
//   if (kDebugMode) {
//     print("🚀 Initializing RevenueCat subscription...");
//   }

//   SubscriptionManager subscriptionManager =
//       navigatorKey.currentContext!.read<SubscriptionManager>();
//   subscriptionManager.startProcess();
// }

Future baseSUBSCRIBE(
  BaseLockInfoRes info, {
  Future Function()? callAPI,
  required dynamic manager,
}) async {
  final context = navigatorKey.currentContext!;
  final userManager = context.read<UserManager>();
  final subscriptionManager = context.read<SubscriptionManager>();

  UserRes? user = userManager.user;
  bool checkWithAPI = false;
  // Ensure user is logged in
  if (user == null) {
    if (kDebugMode) print("🛑 User not logged in. Prompting for login...");

    await userManager.askLoginScreen();
    user = userManager.user;

    if (user == null || user.signupStatus == true) {
      if (kDebugMode) print("🛑 User did not log in or signed up. Exiting...");
      return;
    }
    checkWithAPI = true;
  }

  // Validate user phone number
  if (user.phone?.isEmpty == true || user.phone == '') {
    if (kDebugMode) print("User phone number missing. Prompting for update...");

    await subscriptionManager.getMembershipLayout();
    await Navigator.push(
      context,
      createRoute(MembershipActionRequired()),
    );
    user = userManager.user;
  }

  if (user?.phone?.isEmpty == true || user?.phone == '') return;

  // Fetch lock info
  final lockInfo = manager.getLockINFO();
  if (lockInfo == null) {
    if (kDebugMode) print("🛑 Lock info is null. Exiting...");
    return;
  }

  if (kDebugMode) {
    print("✅ Valid phone number and lock info available.");
    print("🚀 Initializing RevenueCat subscription...");
  }

  // Execute API call if provided
  if (callAPI != null && checkWithAPI) await callAPI();

  // Start subscription process
  subscriptionManager.startProcess();
}
