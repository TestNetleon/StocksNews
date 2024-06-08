import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/errorScreens/app_maintenance.dart';
import 'package:stocks_news_new/screens/errorScreens/server_error.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/app_update_content.dart';
import 'package:stocks_news_new/widgets/bottom_sheet_container.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';

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
  Color backgroundColor = ThemeColors.primaryLight,
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
    backgroundColor: backgroundColor,
    isScrollControlled: true,
    enableDrag: enableDrag ?? true,
    builder: (BuildContext ctx) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BottomSheetContainerPlain(
          showClose: showClose,
          padding: padding,
          child: content,
        ),
      );
    },
  );
}

class CommonSnackbar {
  static bool _isShowing = false;

  static void show({
    String? message,
    int duration = 2,
    SnackbarType type = SnackbarType.error,
  }) {
    if (!_isShowing) {
      _isShowing = true;

      final snackBar = SnackBar(
        duration: Duration(seconds: duration),
        // behavior: SnackBarBehavior.floating,
        backgroundColor: type == SnackbarType.error ? Colors.red : Colors.green,
        // action: SnackBarAction(
        //   label: 'Close',
        //   textColor: ThemeColors.white,
        //   onPressed: () {
        //     ScaffoldMessenger.of(navigatorKey.currentContext!)
        //         .hideCurrentSnackBar();
        //     _isShowing = false;
        //   },
        // ),
        content: Text(
          message ?? "No message present.",
          style: stylePTSansRegular(color: ThemeColors.white),
        ),
      );
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(snackBar)
          .closed
          .then((value) => _isShowing = false);
    }
  }
}

void showAppUpdateDialog(Extra extra) {
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
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
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
