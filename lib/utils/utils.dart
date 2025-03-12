import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/ui/tabs/more/articles/detail.dart';
import 'package:stocks_news_new/ui/tabs/more/news/detail.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../routes/my_app.dart';
import '../ui/tabs/more/helpdesk/front/index.dart';
import '../ui/tabs/tabs.dart';

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

  // void print(data) {
  //   if (kDebugMode) {
  //     print("==================");
  //     log("$data");
  //     print("==================");
  //   }
  // }
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

bool isValidTickerSymbol(String value) {
  // Define the regular expression
  final RegExp tickerRegExp = RegExp(r'^[A-Z]+$');

  // Check if the value matches the regular expression
  return tickerRegExp.hasMatch(value);
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

List<SdTopRes>? convertMultipleStringListsToSdTopResLists(
    SdFinancialRes? data) {
  // Ensure data and financeStatement are not null
  if (data == null || data.financeStatement == null) {
    return null;
  }

  // Initialize a list to hold the converted SdTopRes objects
  List<SdTopRes> convertedList = [];

  // Iterate over each period in the financeStatement list
  for (var period in data.financeStatement!) {
    // Assuming period is an object with period and value properties
    if (period.period != null) {
      String cleanedPeriod = period.period!.replaceAll('-20', '');

      SdTopRes convertedPeriod = SdTopRes(
        key: cleanedPeriod,
        value: cleanedPeriod,
      );

      convertedList.add(convertedPeriod);
    }
  }

  Utils().showLog("Converted list: $convertedList");

  return convertedList;
}

List<SdTopRes>? convertMultipleStringListsToSdTopResListsQuarter(
    SdFinancialRes? data) {
  // Ensure data and financeStatement are not null
  if (data == null || data.financeStatement == null) {
    return null;
  }

  // Initialize a list to hold the converted SdTopRes objects
  List<SdTopRes> convertedList = [];

  // Iterate over each period in the financeStatement list
  for (var period in data.financeStatement!) {
    // Assuming period is an object with period and value properties
    if (period.period != null) {
      String cleanedPeriod = period.period!.replaceAll('-20', ' FY');

      SdTopRes convertedPeriod = SdTopRes(
        key: cleanedPeriod,
        value: cleanedPeriod,
      );

      convertedList.add(convertedPeriod);
    }
  }

  Utils().showLog("Converted list: $convertedList");

  return convertedList;
}

bool containsMinusSymbol(String input) {
  return input.contains('-');
}

// List<SdTopRes>? convertMultipleStringListsToSdTopResLists() {
//   StockDetailProviderNew provider =
//       navigatorKey.currentContext!.read<StockDetailProviderNew>();
//   SdFinancialRes? data = provider.sdFinancialChartRes;

//   // Ensure data and financeStatement are not null
//   if (data == null || data.financeStatement == null) {
//     return null;
//   }

//   // Initialize a list to hold the converted SdTopRes objects
//   List<SdTopRes> convertedList = [];

//   // Iterate over each period in the financeStatement list
//   for (var period in data.financeStatement!) {
//     // Assuming period is an object with period and value properties
//     SdTopRes convertedPeriod = SdTopRes(
//       key: period.period,
//       value: period.period,
//     );

//     convertedList.add(convertedPeriod);
//   }

//   Utils().showLog("Converted list: $convertedList");

//   return convertedList;
// }

String convertToReadableValue(double value) {
  String suffix = '';
  double formattedValue = value;

  if (value.abs() >= 1e9) {
    formattedValue = value / 1e9;
    suffix = 'B';
  } else if (value.abs() >= 1e6) {
    formattedValue = value / 1e6;
    suffix = 'M';
  }

  String formattedString = formattedValue.toStringAsFixed(1);
  if (value < 0) {
    return '-\$${formattedString.substring(1)}$suffix';
  } else {
    return '\$$formattedString$suffix';
  }
}

// String convertDollarValue(double amount) {
//   if (amount >= 1000000000) {
//     return "\$${(amount / 1000000000).toStringAsFixed(2)} B";
//   } else if (amount >= 1000000) {
//     return "\$${(amount / 1000000).toStringAsFixed(2)} M";
//   } else {
//     return "\$${amount.toStringAsFixed(2)}";
//   }
// }

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
      transitionDuration: duration ?? const Duration(milliseconds: 300),
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
  try {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
    // FocusScope.of(navigatorKey.currentContext!).requestFocus(FocusNode());
    FocusManager.instance.primaryFocus?.unfocus();
  } catch (e) {
    //
  }
}

void openKeyboard(FocusNode focusNode) {
  try {
    FocusScope.of(navigatorKey.currentContext!).requestFocus(focusNode);
  } catch (e) {
    //
  }
}

Future openUrl(String? url,
    {LaunchMode mode = LaunchMode.platformDefault}) async {
  if (url == null || url.isEmpty) {
    // showErrorMessage(message: "Exception: Could not launch.");
  } else {
    Utils().showLog(url);
    try {
      if (!await launchUrl(Uri.parse(url), mode: mode)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      Utils().showLog('Catch error $e');
      await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
    }
  }
}

commonShare({String? url, String? title}) {
  if (url == null || url == '') {
    // showErrorMessage(message: "No url found.");
  } else {
    Share.share(
      "$title $url",
      subject: title,
    );
  }
}

// void handleDeepLinkNavigation({
//   Uri? uri,
//   bool conditionalCheck = false,
//   int? duration,
// }) {
//   Utils().showLog('url $uri');
//   if (uri == null) {
//     onDeepLinking = false;
//     return;
//   }

//   try {
//     extractCodeFromMEM(uri, "4");
//     Utils().showLog("Calling from handle deep link MEM CODE => $memCODE");

//     if (memCODE != null &&
//         memCODE != '' &&
//         uri.toString().contains('.page.link')) {
//       Utils().showLog("Going to membership page-------");
//       Timer(Duration(seconds: duration ?? 0), () {
//         // Navigator.push(navigatorKey.currentContext!,
//         //     MaterialPageRoute(builder: (context) {
//         //   return NewMembership();
//         // }));
//         closeKeyboard();
//         // UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
//         Extra? extra = navigatorKey.currentContext!.read<HomeProvider>().extra;

//         if (extra?.showBlackFriday == true) {
//           Navigator.push(
//             navigatorKey.currentContext!,
//             MaterialPageRoute(
//               builder: (context) => const BlackFridayMembershipIndex(),
//             ),
//           );
//         } else if (extra?.christmasMembership == true ||
//             extra?.newYearMembership == true) {
//           Navigator.push(
//             navigatorKey.currentContext!,
//             createRoute(
//               const ChristmasMembershipIndex(),
//             ),
//           );
//         } else {
//           subscribe();
//           // Navigator.push(
//           //   navigatorKey.currentContext!,
//           //   MaterialPageRoute(
//           //     builder: (context) => const NewMembership(),
//           //   ),
//           // );
//         }
//       });

//       return;
//     }
//   } catch (e) {
//     //
//   }

//   bool isRef = uri.toString().contains("/install") ||
//       uri.toString().contains(".page.link") ||
//       uri.toString().contains("app.stocks.news://");

//   if (isRef) {
//     onDeepLinking = false;
//     return;
//   }

//   // onDeepLinking = true;
//   DeeplinkEnum type = containsSpecificPath(uri);
//   String slug = extractLastPathComponent(uri);

// //EXTRA Condition for News, Blog, AI navigation started-------------
//   if (conditionalCheck && type == DeeplinkEnum.outsider) {
//     openUrl("$uri");
//     return;
//   }
// //-------------------------------

//   // here will be some conditions to handle in background
//   // like if from background then add 4 sec else 1 sec
//   Timer(const Duration(milliseconds: 300), () {
//     handleNavigation(
//       uri: uri,
//       slug: slug,
//       type: type,
//       fromBackground: false,
//       from: "Handle Navigation Common",
//     );
//   });
// }

// void handleNavigation({
//   DeeplinkEnum? type,
//   required Uri uri,
//   String? slug,
//   fromBackground = false,
//   String from = "",
//   bool setPopHome = true,
// }) async {
//   if (type != DeeplinkEnum.login && type != DeeplinkEnum.signup) {
//     isAppUpdating = false;
//   }
//   // Utils().showLog("---Type $type, -----Uri $uri,-----Slug $slug");
//   // String slugForTicker = extractLastPathComponent(uri);
//   bool userPresent = false;

//   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
//   if (await provider.checkForUser()) {
//     userPresent = true;
//   }

//   if (slug == null && type == null) {
//     return;
//   }

//   if (setPopHome && type != DeeplinkEnum.login && type != DeeplinkEnum.signup) {
//     popHome = true;
//   }

//   Utils().showLog("----$userPresent---");

//   // if (type == "blog") {
//   if (type == DeeplinkEnum.blogDetail) {
//     if (fromBackground) {
//       Navigator.pushReplacement(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (context) => BlogDetail(slug: slug),
//         ),
//       );
//     } else {
//       Navigator.push(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (context) => BlogDetail(slug: slug),
//         ),
//       );
//     }
//     // } else if (type == "news") {
//   } else if (type == DeeplinkEnum.newsDetail) {
//     if (fromBackground) {
//       Navigator.pushReplacement(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (context) => NewsDetails(slug: slug),
//         ),
//       );
//     } else {
//       Navigator.push(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (context) => NewsDetails(slug: slug),
//         ),
//       );
//     }
//     // } else if (type == "stock_detail") {
//   } else if (type == DeeplinkEnum.stocksDetail) {
//     if (fromBackground) {
//       Navigator.pushReplacement(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (context) => StockDetail(symbol: slug!),
//         ),
//       );
//     } else {
//       Navigator.push(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (context) => StockDetail(symbol: slug!),
//         ),
//       );
//     }
//     // } else if (type == "login") {
//   } else if (type == DeeplinkEnum.login) {
//     if (userPresent) {
//       if (fromBackground) {
//         Navigator.popUntil(
//           navigatorKey.currentContext!,
//           (route) => route.isFirst,
//         );
//         Navigator.pushReplacement(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(builder: (_) => const Tabs()),
//         );
//       }
//     } else {
//       Timer(Duration(milliseconds: splashLoaded ? 0 : 3500), () {
//         // loginSheet();
//         loginFirstSheet();
//       });
//     }
//     // } else if (type == "signUp") {
//   } else if (type == DeeplinkEnum.signup) {
//     if (userPresent) {
//       if (fromBackground) {
//         Navigator.popUntil(
//           navigatorKey.currentContext!,
//           (route) => route.isFirst,
//         );
//         Navigator.pushReplacement(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(builder: (_) => const Tabs()),
//         );
//       }
//     } else {
//       Timer(Duration(milliseconds: splashLoaded ? 0 : 3500), () {
//         // signupSheet();
//         loginFirstSheet();
//       });
//     }
//     // } else if (type == "dashboard") {
//   } else if (type == DeeplinkEnum.dashboard) {
//     // if (fromBackground) {
//     Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
//     Navigator.pushReplacement(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (_) => const Tabs()),
//     );
//     // }
//     // } else if (type == "page") {
//   } else if (type == DeeplinkEnum.page) {
//     if (fromBackground) {
//       Navigator.pushReplacement(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (context) => TCandPolicy(
//             policyType: PolicyType.aboutUs,
//             slug: "$slug",
//           ),
//         ),
//       );
//     } else {
//       Navigator.push(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (context) => TCandPolicy(
//             policyType: PolicyType.aboutUs,
//             slug: "$slug",
//           ),
//         ),
//       );
//     }
//   } else if (type == DeeplinkEnum.insiderTrades) {
//     Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
//     Navigator.pushReplacement(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (_) => const Tabs(index: 2)),
//     );
//   } else if (type == DeeplinkEnum.membership) {
//     // UserProvider userProvider =
//     //     navigatorKey.currentContext!.read<UserProvider>();
//     // if (userProvider.user == null) {
//     //   UserRes? user = await Preference.getUser();
//     //   if (user != null) {
//     //     provider.setUser(user);
//     //   }
//     //   await navigatorKey.currentContext!.read<HomeProvider>().getHomeSlider(
//     //         showProgress: true,
//     //       );
//     // }

//     // UserProvider userProvider =
//     //     navigatorKey.currentContext!.read<UserProvider>();

//     if (provider.user == null || provider.user?.membership?.purchased != 1) {
//       subscribe();
//       // Navigator.push(
//       //   navigatorKey.currentContext!,
//       //   MaterialPageRoute(
//       //     builder: (_) => const NewMembership(),
//       //   ),
//       // );
//     } else {
//       Navigator.popUntil(
//           navigatorKey.currentContext!, (route) => route.isFirst);
//       Navigator.pushReplacement(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (_) => const Tabs(),
//         ),
//       );
//     }
//   } else if (type == DeeplinkEnum.trendingIndustries) {
//     Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
//     Navigator.pushReplacement(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (_) => const Tabs(
//           index: 1,
//           trendingIndex: 4,
//         ),
//       ),
//     );
//   } else if (type == DeeplinkEnum.sentiments) {
//     Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
//     Navigator.pushReplacement(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (_) => const Tabs(index: 3)),
//     );
//   } else if (type == DeeplinkEnum.helpdesk) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       // MaterialPageRoute(builder: (_) => const HelpDesk()),
//       MaterialPageRoute(builder: (_) => const HelpDeskNew()),
//     );
//     // *********** Market data Pages from Here ********
//   } else if (type == DeeplinkEnum.gainerLoser) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const GainersLosersIndex(
//           type: StocksType.gainers,
//         ),
//       ),
//     );
//   } else if (type == DeeplinkEnum.gapUpDown) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const GapUpDownStocks(type: StocksType.gapUp),
//       ),
//     );
//   } else if (type == DeeplinkEnum.highLowPE) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const HighLowPEIndex(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.fiftyTwoWeeks) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const FiftyTwoWeeksIndex(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.highLowBeta) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const HighLowsBetaStocksIndex(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.indices) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const IndicesIndex(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.lowPriceStocks) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const LowPriceStocksIndex(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.mostActive) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const MostActiveIndex(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.pennyStocks) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const PennyStocks(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.congressional) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const CongressionalIndex(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.dividents) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const DividendsScreen(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.earnings) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const EarningsScreen(),
//       ),
//     );
//   } else if (type == DeeplinkEnum.stocks) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (context) => const StocksIndex(),
//       ),
//     );
//   } else {
//     Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
//     Navigator.pushReplacement(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (_) => const Tabs()),
//     );
//   }
//   Timer(const Duration(seconds: 4), () {
//     onDeepLinking = false;
//   });
// }

bool isSvgFromUrl(String? url) {
  try {
    if (url == null || url == '') {
      return false;
    } else {
      if (url.contains("stock-news-images")) {
        return false;
      } else {
        return true;
      }
    }
  } catch (e) {
    //
    return false;
  }
}

String formatBalance(num balance) {
  final formatter = NumberFormat('#,##0.00');
  return formatter.format(balance);
}

//MARK: Deep Linking
void handleDeepLinkNavigation({
  Uri? uri,
  bool conditionalCheck = false,
  int? duration,
}) {
  Utils().showLog('url $uri');
  if (uri == null) {
    onDeepLinking = false;
    return;
  }

  try {
    extractCodeFromMEM(uri, "4");
    Utils().showLog("Calling from handle deep link MEM CODE => $memCODE");

    if (memCODE != null &&
        memCODE != '' &&
        uri.toString().contains('.page.link')) {
      Utils().showLog("Going to membership page-------");
      SubscriptionManager manager =
          navigatorKey.currentContext!.read<SubscriptionManager>();
      manager.startProcess();

      return;
    }
  } catch (e) {
    //
  }

  bool isRef = uri.toString().contains("/install") ||
      uri.toString().contains(".page.link") ||
      uri.toString().contains("app.stocks.news://");

  if (isRef) {
    onDeepLinking = false;
    return;
  }

  // onDeepLinking = true;
  DeeplinkEnum type = containsSpecificPath(uri);
  String slug = extractLastPathComponent(uri);

//EXTRA Condition for News, Blog, AI navigation started-------------
  if (conditionalCheck && type == DeeplinkEnum.outsider) {
    openUrl("$uri");
    return;
  }
//-------------------------------

  // here will be some conditions to handle in background
  // like if from background then add 4 sec else 1 sec
  Timer(const Duration(milliseconds: 300), () {
    handleNavigation(
      uri: uri,
      slug: slug,
      type: type,
      fromBackground: false,
      from: "Handle Navigation Common",
    );
  });
}

void handleNavigation({
  DeeplinkEnum? type,
  required Uri uri,
  String? slug,
  fromBackground = false,
  String from = "",
  bool setPopHome = true,
}) async {
  if (type != DeeplinkEnum.login && type != DeeplinkEnum.signup) {
    isAppUpdating = false;
  }

  bool userPresent = false;

  UserManager manager = navigatorKey.currentContext!.read<UserManager>();

  if (await manager.checkForUser()) {
    userPresent = true;
  }

  if (slug == null && type == null) {
    return;
  }

  if (setPopHome && type != DeeplinkEnum.login && type != DeeplinkEnum.signup) {
    popHome = true;
  }

  Utils().showLog("----$userPresent---");

  if (type == DeeplinkEnum.blogDetail) {
    Navigator.pushNamed(navigatorKey.currentContext!, BlogsDetailIndex.path,
        arguments: {
          'slug': slug,
        });
  } else if (type == DeeplinkEnum.newsDetail) {
    Navigator.pushNamed(navigatorKey.currentContext!, NewsDetailIndex.path,
        arguments: {
          'slug': slug,
        });
  } else if (type == DeeplinkEnum.stocksDetail) {
    Navigator.pushNamed(navigatorKey.currentContext!, SDIndex.path, arguments: {
      'slug': slug,
    });
  } else if (type == DeeplinkEnum.login) {
    if (userPresent) {
      if (fromBackground) {
        Navigator.popUntil(
          navigatorKey.currentContext!,
          (route) => route.isFirst,
        );
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
      }
    } else {
      Timer(Duration(milliseconds: splashLoaded ? 0 : 3500), () {
        manager.askLoginScreen();
      });
    }
  } else if (type == DeeplinkEnum.signup) {
    if (userPresent) {
      //
    } else {
      Timer(Duration(milliseconds: splashLoaded ? 0 : 3500), () {
        manager.askLoginScreen();
      });
    }
  } else if (type == DeeplinkEnum.dashboard) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const Tabs()),
    );
    // } else if (type == DeeplinkEnum.page) {
    // navigation pending
    // } else if (type == DeeplinkEnum.insiderTrades) {
    //   Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    //   Navigator.pushReplacement(
    //     navigatorKey.currentContext!,
    //     MaterialPageRoute(builder: (_) => const Tabs(index: 2)),
    //   );
  } else if (type == DeeplinkEnum.membership) {
    if (manager.user == null || manager.user?.membership?.purchased != 1) {
      SubscriptionManager manager =
          navigatorKey.currentContext!.read<SubscriptionManager>();
      manager.startProcess();
    } else {
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Tabs()),
      );
    }
    // } else if (type == DeeplinkEnum.trendingIndustries) {
    // Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    // Navigator.pushReplacement(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (_) => const Tabs(
    //       index: 1,
    //       trendingIndex: 4,
    //     ),
    //   ),
    // );
  } else if (type == DeeplinkEnum.sentiments) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const Tabs(index: 2)),
    );
  } else if (type == DeeplinkEnum.helpdesk) {
    Navigator.pushNamed(navigatorKey.currentContext!, HelpDeskIndex.path);
    // *********** Market data Pages from Here ********
  } else if (type == DeeplinkEnum.gainerLoser) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 1,
      },
    );
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const GainersLosersIndex(
    //       type: StocksType.gainers,
    //     ),
    //   ),
    // );
  } else if (type == DeeplinkEnum.gapUpDown) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 2,
      },
    );
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const GapUpDownStocks(type: StocksType.gapUp),
    //   ),
    // );
  } else if (type == DeeplinkEnum.highLowPE) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 3,
      },
    );
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const HighLowPEIndex(),
    //   ),
    // );
  } else if (type == DeeplinkEnum.fiftyTwoWeeks) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 4,
      },
    );
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const FiftyTwoWeeksIndex(),
    //   ),
    // );
  } else if (type == DeeplinkEnum.highLowBeta) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 5,
      },
    );
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const HighLowsBetaStocksIndex(),
    //   ),
    // );
  } else if (type == DeeplinkEnum.indices) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 6,
      },
    );
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const IndicesIndex(),
    //   ),
    // );
  } else if (type == DeeplinkEnum.lowPriceStocks) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 7,
      },
    );
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const LowPriceStocksIndex(),
    //   ),
    // );
  } else if (type == DeeplinkEnum.mostActive) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 8,
      },
    );

    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const MostActiveIndex(),
    //   ),
    // );
  } else if (type == DeeplinkEnum.pennyStocks) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 9,
      },
    );

    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const PennyStocks(),
    //   ),
    // );
    // } else if (type == DeeplinkEnum.congressional) {
    //   Navigator.push(
    //     navigatorKey.currentContext!,
    //     MaterialPageRoute(
    //       builder: (context) => const CongressionalIndex(),
    //     ),
    //   );
  } else if (type == DeeplinkEnum.dividents) {
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 10,
      },
    );
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const DividendsScreen(),
    //   ),
    // );
  } else if (type == DeeplinkEnum.earnings) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      Tabs.path,
      arguments: {
        "index": 1,
        "childIndex": 11,
      },
    );
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const EarningsScreen(),
    //   ),
    // );
  } else if (type == DeeplinkEnum.stocks) {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);
    // Navigator.push(
    //   navigatorKey.currentContext!,
    //   MaterialPageRoute(
    //     builder: (context) => const StocksIndex(),
    //   ),
    // );
  } else {
    Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const Tabs()),
    );
  }
  Timer(const Duration(seconds: 4), () {
    onDeepLinking = false;
  });
}
