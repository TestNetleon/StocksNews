import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/errorScreens/app_maintenance.dart';
import 'package:stocks_news_new/screens/errorScreens/server_error.dart';
import 'package:stocks_news_new/screens/marketData/widget/extra_sorting_list.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/app_update_content.dart';
import 'package:stocks_news_new/widgets/bottom_sheet_container.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// void showProgressDialog(BuildContext context) {
//   showPlatformDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return const ProgressDialog();
//       });
// }
//
void showGlobalProgressDialog({bool optionalParent = false}) {
  showDialog(
    context: navigatorKey.currentContext ??
        navigatorKey.currentState!.overlay!.context,
    barrierDismissible: false,
    builder: (context) {
      return ProgressDialog(
        optionalParent: optionalParent,
      );
    },
  );
}

void closeGlobalProgressDialog() {
  navigatorKey.currentState?.pop();
}

void onSortingClick({
  breakOutType = false,
  volumeType = false,
  required void Function(String)? onTap,
  required String? selected,
  required void Function()? onResetClick,
}) async {
  FilterProvider provider = navigatorKey.currentContext!.read<FilterProvider>();
  if (provider.data == null) {
    await provider.getFilterData();
  }
  if (provider.data != null) {
    BaseBottomSheets().gradientBottomSheet(
      title: "SORT BY",
      onResetClick: onResetClick,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemCount: provider.data?.sorting?.length ?? 0,
            itemBuilder: (context, index) {
              FiltersData? data = context.watch<FilterProvider>().data;
              if (data == null) {
                return const SizedBox();
              }
              return GestureDetector(
                onTap: () {
                  if (onTap == null) {
                    return;
                  }
                  onTap(provider.data?.sorting?[index].key ?? "");
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 10.sp),
                  child: Text(
                    data.sorting?[index].value ?? "",
                    // sortingArrayList[index].value,
                    style: stylePTSansBold(
                      color: selected == provider.data?.sorting?[index].key
                          ? ThemeColors.accent
                          : Colors.white,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          ),
          if (breakOutType && provider.data?.breakOutType != null)
            ExtraSortingList(
              onTap: (value) {
                if (onTap == null) {
                  return;
                }
                onTap(value);
              },
              selected: selected,
              list: provider.data?.breakOutType,
            ),
          if (volumeType && provider.data?.volumeType != null)
            ExtraSortingList(
              onTap: (value) {
                if (onTap == null) {
                  return;
                }
                onTap(value);
              },
              selected: selected,
              list: provider.data?.volumeType,
            )
        ],
      ),
    );
  }
}

void showErrorMessage(
    {required message,
    type = SnackbarType.error,
    bool snackbar = true,
    int duration = 2}) {
  // if (Platform.isAndroid) {
  if (snackbar) {
    final snackBar = SnackBar(
      duration: Duration(seconds: duration),
      // behavior: SnackBarBehavior.floating,
      backgroundColor: type == SnackbarType.error ? Colors.red : Colors.green,
      content: Text(
        message ?? '',
        style:
            stylePTSansRegular().copyWith(color: Colors.white, fontSize: 14.sp),
      ),
    );
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
  }
}

Future<dynamic> showConfirmAlertCallbackDialog({
  context,
  title = "Confirm",
  message = "",
  okText = "Ok",
  onclick,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title != null
                ? Text(title, style: stylePTSansBold(fontSize: 17))
                : const SizedBox(),
            SizedBox(height: 12.sp),
            Text(message, style: stylePTSansBold()),
          ],
        ),
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.fromLTRB(16.sp, 12.sp, 16.sp, 4.sp),
        buttonPadding: EdgeInsets.zero,
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.sp),
            child: TextButton(
              child: Text(okText, style: stylePTSansBold()),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pop(context);
                if (onclick != null) {
                  onclick();
                }
              },
            ),
          ),
        ],
      );
    },
  );
}

Future<dynamic> showConfirmAlertDialog(
    {context,
    title = "Confirm",
    message = "",
    okText = "Ok",
    cancelText = "Cancel",
    onclick}) {
  return showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title,
            style: stylePTSansBold(fontSize: 17, color: Colors.black)),
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(5.sp),
        //     side: const BorderSide(color: ThemeColors.border)),
        // backgroundColor: ThemeColors.primaryLight,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visibility(
            //     visible: title != "",
            //     child: Text(title,
            //         style: stylePTSansBold(fontSize: 17, color: Colors.black))),
            Visibility(visible: title != "", child: SizedBox(height: 12.sp)),
            Text(message, style: stylePTSansRegular(color: Colors.black)),
          ],
        ),
        // actionsPadding: EdgeInsets.zero,
        // contentPadding: EdgeInsets.fromLTRB(16.sp, 12.sp, 16.sp, 20.sp),
        // buttonPadding: EdgeInsets.zero,
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.sp),
            child: TextButton(
              child:
                  Text(cancelText, style: stylePTSansBold(color: Colors.black)),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pop(context);
                // if (onclick != null) {
                //   onclick();
                // }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.sp, bottom: 2.sp),
            child: TextButton(
              child: Text(okText, style: stylePTSansBold(color: Colors.black)),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pop(context);
                if (onclick != null) {
                  onclick();
                }
              },
            ),
          ),
        ],
      );
    },
  );
}

void showPlatformBottomSheet({
  required BuildContext context,
  required Widget content,
  Color? backgroundColor,
  // = ThemeColors.primaryLight,
  bool? enableDrag,
  showClose = true,
  EdgeInsets? padding,
}) {
  showModalBottomSheet(
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.sp),
        topRight: Radius.circular(10.sp),
      ),
      side: const BorderSide(color: ThemeColors.greyBorder),
    ),
    context: context,
    backgroundColor: backgroundColor ?? ThemeColors.bottomsheetGradient,
    isScrollControlled: true,
    enableDrag: enableDrag ?? true,
    builder: (BuildContext ctx) {
      return Container(
        color: ThemeColors.bottomsheetGradient,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BottomSheetContainerPlain(
          showClose: showClose,
          padding: padding,
          child: content,
        ),
      );
    },
  );
}

// class CommonSnackbar {
//   static bool _isShowing = false;

//   static void show({
//     String? message,
//     int duration = 2,
//     Duration? displayDuration,
//     Color? backgroundColor,
//     Function()? onTap,
//     SnackbarType type = SnackbarType.error,
//   }) {
//     if (!_isShowing) {
//       _isShowing = true;

//       final snackBar = SnackBar(
//         duration: displayDuration ?? Duration(seconds: duration),
//         // behavior: SnackBarBehavior.floating,
//         backgroundColor: backgroundColor ??
//             (type == SnackbarType.error ? Colors.red : Colors.green),
//         action: SnackBarAction(
//           backgroundColor: ThemeColors.background,
//           label: onTap != null ? "Settings" : 'Close',
//           textColor: ThemeColors.white,
//           onPressed: onTap ??
//               () {
//                 ScaffoldMessenger.of(navigatorKey.currentContext!)
//                     .hideCurrentSnackBar();
//                 _isShowing = false;
//               },
//         ),
//         content: Text(
//           message ?? "No message present.",
//           style: stylePTSansRegular(color: ThemeColors.white, fontSize: 17),
//         ),
//       );
//       ScaffoldMessenger.of(navigatorKey.currentContext!)
//           .showSnackBar(snackBar)
//           .closed
//           .then((value) => _isShowing = false);
//     }
//   }
// }
class CustomSnackbar extends StatelessWidget {
  final String message;
  final Duration displayDuration;
  final VoidCallback? onTap;

  const CustomSnackbar({
    super.key,
    required this.message,
    this.displayDuration = const Duration(seconds: 2),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 255, 5, 5)),
            color: Color.fromARGB(255, 199, 5, 5),
            // borderRadius: BorderRadius.circular(0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              SpacerHorizontal(width: 5),
              if (onTap != null)
                ElevatedButton(
                  onPressed: onTap,
                  child: Text(
                    'Enable',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              // if (onTap == null)
              //   TextButton(
              //     onPressed: () {
              //       // Handle close action
              //     },
              //     child: Text(
              //       'Close',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAppUpdateDialog(Extra extra) {
  showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return PopScope(
        canPop: false,
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                      ),
                    ),
                    Dialog(
                      insetPadding: EdgeInsets.symmetric(
                        horizontal:
                            ScreenUtil().screenWidth * (isPhone ? .1 : .2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: AppUpdateContent(extra: extra),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: false,
    barrierLabel: '',
    context: navigatorKey.currentContext!,
    pageBuilder: (context, animation1, animation2) {
      return const SizedBox();
    },
  );
}

void showErrorFullScreenDialog({errorCode, onClick, log}) {
  showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                  Dialog(
                    insetPadding: EdgeInsets.zero,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: PopScope(
                      canPop: false,
                      child: ServerError(
                        errorCode: errorCode,
                        onClick: onClick,
                        log: log,
                      ),
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
    barrierDismissible: false,
    barrierLabel: '',
    context: navigatorKey.currentContext!,
    pageBuilder: (context, animation1, animation2) {
      return const PopScope(
        canPop: false,
        child: SizedBox(),
      );
    },
  );
}

void showMaintenanceDialog({title, description, onClick, log}) {
  showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                  Dialog(
                    insetPadding: EdgeInsets.zero,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: PopScope(
                      canPop: false,
                      child: AppMaintenance(
                        onClick: onClick,
                        log: log,
                        title: title,
                        description: description,
                      ),
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
    context: navigatorKey.currentContext!,
    pageBuilder: (context, animation1, animation2) {
      return const PopScope(
        canPop: false,
        child: SizedBox(),
      );
    },
  );
}

// Future openNotificationsSettings() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   NotificationSettings settings = await messaging.getNotificationSettings();
//   Utils()
//       .showLog("--Firebase Permission Status: ${settings.authorizationStatus}");
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     //
//   } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
//     _showSnackbar("Enable notifications in app settings.");
//   } else if (settings.authorizationStatus == AuthorizationStatus.provisional ||
//       settings.authorizationStatus == AuthorizationStatus.notDetermined) {
//     _showSnackbar(
//         "Notifications are not fully enabled. Please enable them in your device settings.");
//   }
// }

Future<bool> openNotificationsSettings() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.getNotificationSettings();
  Utils()
      .showLog("--Firebase Permission Status: ${settings.authorizationStatus}");
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    return false;
  } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
    return true;
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional ||
      settings.authorizationStatus == AuthorizationStatus.notDetermined) {
    return true;
  }
  return true;
}

closeSnackbar() {
  ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();
}
