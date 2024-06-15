import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:intl/intl.dart';

import 'package:stocks_news_new/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/user_provider.dart';
import '../route/my_app.dart';
import '../screens/auth/bottomSheets/login_sheet.dart';
import '../screens/auth/bottomSheets/signup_sheet.dart';
import '../screens/blogDetail/index.dart';
import '../screens/deepLinkScreen/webscreen.dart';
import '../screens/stockDetail/index.dart';
import '../screens/tabs/news/newsDetail/new_detail.dart';
import '../screens/tabs/tabs.dart';
import 'preference.dart';

// import 'package:whatsapp_share/whatsapp_share.dart';

bool isEven(index) {
  return index % 2 == 0;
}

class Utils {
  void showLog(data) {
    if (kDebugMode) {
      print("==================");
      debugPrint("$data");
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

void navigateDeepLinks({required Uri uri, bool fromBackground = false}) {
  String type = containsSpecificPath(uri);
  String slug = extractLastPathComponent(uri);

  if (slug == 'install') {
    String? referralCode = uri.queryParameters['code'];
    if (referralCode == null || referralCode == '') {
      referralCode = uri.queryParameters['referrer'];
    }
    if (referralCode == null || referralCode == '') {
      referralCode = uri.queryParameters['ref'];
    }
    if (referralCode == null || referralCode == '') {
      referralCode = uri.queryParameters['referral_code'];
    }

    if (referralCode != null && referralCode != "") {
      Preference.saveReferral(referralCode);
    }
  }

  if (fromBackground) {
    Timer(const Duration(seconds: 5), () {
      _navigation(uri: uri, slug: slug, type: type, fromBackground: true);
    });
  } else {
    Timer(const Duration(seconds: 1), () {
      _navigation(uri: uri, slug: slug, type: type);
    });
  }
}

void _navigation({
  String? type,
  required Uri uri,
  String? slug,
  fromBackground = false,
}) async {
  Utils().showLog("---Type $type, -----Uri $uri,-----Slug $slug");
  String slugForTicker = extractSymbolValue(uri);
  Utils().showLog("slug for ticker $slugForTicker");
  bool userPresent = false;

  UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  if (await provider.checkForUser()) {
    userPresent = true;
  }
  Utils().showLog("----$userPresent---");
  if (type == "blog") {
    Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => BlogDetail(
                  // id: "",
                  slug: slug,
                )));
  } else if (type == "news") {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => NewsDetails(
          slug: slug,
        ),
      ),
    );
  } else if (type == "stock_detail") {
    Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => StockDetail(symbol: slugForTicker)));
  } else if (type == "login") {
    if (userPresent) {
      if (fromBackground) {
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!, Tabs.path, (route) => false);
      }
    } else {
      loginSheet();
    }
  } else if (type == "signUp") {
    if (userPresent) {
      if (fromBackground) {
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!, Tabs.path, (route) => false);
      }
    } else {
      signupSheet();
    }
  } else if (type == "dashboard") {
    if (fromBackground) {
      Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!,
        Tabs.path,
        (route) => false,
      );
    }
    Utils().showLog("--goto dashboard---");
  } else {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        // builder: (context) => WebviewLink(url: uri), // Changes by Lokendra Sir
        builder: (context) => const Tabs(),
      ),
    );
  }
}

bool isValidUrl(String? url) {
  if (url == null) return false;

  Uri? uri = Uri.tryParse(url);
  // return uri != null && uri.hasScheme && uri.hasAuthority;
  return uri != null;
}
