import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';

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
//           style: styleBaseRegular(color: ThemeColors.white, fontSize: 17),
//         ),
//       );
//       ScaffoldMessenger.of(navigatorKey.currentContext!)
//           .showSnackBar(snackBar)
//           .closed
//           .then((value) => _isShowing = false);
//     }
//   }
// }

Future<bool> openNotificationsSettings() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.getNotificationSettings();
    Utils().showLog(
        "--Firebase Permission Status: ${settings.authorizationStatus}");
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return false;
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return true;
    } else if (settings.authorizationStatus ==
            AuthorizationStatus.provisional ||
        settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      return true;
    }
    return true;
  } catch (e) {
    return false;
  }
}

closeSnackbar() {
  ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();
}
