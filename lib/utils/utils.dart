import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:intl/intl.dart';

import 'package:stocks_news_new/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:whatsapp_share/whatsapp_share.dart';

bool isEven(index) {
  return index % 2 == 0;
}

class Utils {
  void showLog(data) {
    if (kDebugMode) {
      print("==================");
      log("$data");
      print("==================");
    }
  }
}

DateTime parseDate(String dateString) {
  List<String> dateArray = dateString.split('-');

  DateTime date = DateTime(
    int.parse(dateArray[0]),
    int.parse(dateArray[1]),
    int.parse(dateArray[2]),
    // int.parse(dateArray[2]),
    // int.parse(dateArray[1]),
    // int.parse(dateArray[0]),
  );

  return date;
}

String formatDateTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = dateTime.difference(now);

  if (difference.inSeconds < 60) {
    // Utils().showLog("SEC = ${difference.inSeconds}");
    return 'just now';
  } else if (difference.inMinutes < 60) {
    // Utils().showLog("MINIUTES = ${difference.inMinutes}");
    final minutes = difference.inMinutes;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
  } else if (difference.inHours < 24) {
    // Utils().showLog("HOURS = ${difference.inHours}");
    final hours = difference.inHours;
    return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inDays < 7) {
    // Utils().showLog("DAYS = ${difference.inDays}");
    final days = difference.inDays;
    return '$days ${days == 1 ? 'day' : 'days'} ago';
  } else {
    Utils().showLog("DATE = ${difference.inDays}");
    return DateFormat.yMMMd().format(dateTime);
  }
}

void showSnackbar({
  required context,
  required message,
  type = SnackbarType.error,
}) {
  final snackBar = SnackBar(
    backgroundColor: type == SnackbarType.error ? Colors.red : Colors.green,
    content: Text(
      message ?? '',
      style: stylePTSansRegular().copyWith(color: Colors.white),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Route createRoute(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    // const AddLogistic(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

easeOutBuilder(BuildContext context,
    {required Widget child, Duration? duration, bool opaque = true}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: opaque,
      transitionDuration: duration ?? const Duration(milliseconds: 400),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return child;
      },
    ),
  );
}

void financialLogic() {}

class MonthMap {
  int id;
  String name;

  MonthMap({required this.id, required this.name});
}

String formatNumberString(String numberString) {
  // final number = double.parse(numberString);
  // final formattedNumber = number.toStringAsFixed(2);
  // return formattedNumber.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

  final number = double.tryParse(numberString);
  if (number == null) {
    return "0";
  }
  final format = NumberFormat("##0.${"0" * 2}", "en_US");
  return format.format(number);
}

void closeKeyboard() {
  SystemChannels.textInput.invokeMethod("TextInput.hide");

  // FocusScope.of(navigatorKey.currentContext!).requestFocus(FocusNode());
  FocusManager.instance.primaryFocus?.unfocus();
}

Future openUrl(String? url,
    {LaunchMode mode = LaunchMode.platformDefault, String? extraUrl}) async {
  if (url == null || url.isEmpty) {
    // showErrorMessage(message: "Exception: Could not launch.");
  } else {
    Utils().showLog(url);
    try {
      if (!await launchUrl(Uri.parse(url), mode: mode)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      Utils().showLog(e);
      await launchUrl(Uri.parse(extraUrl ?? ""),
          mode: LaunchMode.platformDefault);
    }
  }
}

commonShare({String? url, String? title}) {
  if (url == null || url == '') {
    // showErrorMessage(message: "No url found.");
  } else {
    Share.share("$title $url", subject: title);
  }
}
