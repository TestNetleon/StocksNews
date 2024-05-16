import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
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
  } else {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(10.sp),
            backgroundColor: const Color.fromARGB(255, 39, 39, 39),
            content: Text(
              message,
              style: stylePTSansRegular(fontSize: 14),
            ),
            actions: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Text(
                    "Okay",
                    style: stylePTSansRegular(fontSize: 14),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
  // } else {
  //   showDialog(
  //       context: navigatorKey.currentContext!,
  //       builder: (context) {
  //         return CupertinoAlertDialog(
  //           content: Text(
  //             message,
  //             style: stylePTSansRegular(fontSize: 12),
  //           ),
  //           actions: <Widget>[
  //             CupertinoDialogAction(
  //               child: Text(
  //                 "Dismiss",
  //                 style: stylePTSansRegular(fontSize: 14),
  //               ),
  //               onPressed: () {
  //                 FocusManager.instance.primaryFocus?.unfocus();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }
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

void showPlatformBottomSheet(
    {required BuildContext context,
    required Widget content,
    Color backgroundColor = ThemeColors.primaryLight,
    bool? enableDrag,
    showClose = true}) {
  showModalBottomSheet(
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
        child: BottomSheetContainerPlain(showClose: showClose, child: content),
      );
    },
  );
}
