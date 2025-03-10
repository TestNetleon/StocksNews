import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';

class DynamicLinkService {
  static final DynamicLinkService _singleton = DynamicLinkService._internal();
  DynamicLinkService._internal();
  static DynamicLinkService get instance => _singleton;

// // Create new dynamic link
//   void createDynamicLink(code) async {
//     UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
//     final dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse(
//           "https://app.stocks.news/install?code=$code&_id=${user?.userId}"),
//       uriPrefix: "https://stocksnews.page.link",
//       androidParameters: const AndroidParameters(
//         packageName: "com.stocks.news",
//         minimumVersion: 0,
//       ),
//       iosParameters: const IOSParameters(
//         bundleId: "app.stocks.news",
//       ),
//     );
//     final dynamicLink =
//         await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
//     debugPrint("${dynamicLink.shortUrl}");
//     Share.share(
//       "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${dynamicLink.shortUrl}",
//     );
//   }

  Future<Uri> getDynamicLink() async {
    UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
    Utils().showLog("REFER CODE=>${user?.referralCode}, ID=>${user?.userId}");
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
        "https://app.stocks.news/install?code=${user?.referralCode}&_id=${user?.userId}",
      ),
      uriPrefix: "https://stocksnews.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.stocks.news",
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(bundleId: "app.stocks.news"),
    );

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    // debugPrint("${dynamicLink.shortUrl}");
    return dynamicLink.shortUrl;
  }

  // Future<Uri> getMembershipDynamicLink() async {
  //   final dynamicLinkParams = DynamicLinkParameters(
  //     link: Uri.parse("https://app.stocks.news/membership100000"),
  //     uriPrefix: "https://stocksnews.page.link",
  //     androidParameters: AndroidParameters(
  //       packageName: "com.stocks.news",
  //       minimumVersion: 0,
  //       fallbackUrl: Uri.parse(
  //           "https://play.google.com/store/apps/details?id=com.stocks.news"),
  //     ),
  //     iosParameters: IOSParameters(
  //       bundleId: "app.stocks.news",
  //       fallbackUrl: Uri.parse(
  //           "https://apps.apple.com/in/app/stocks-news-stock-market/id6476615803"),
  //     ),
  //   );

  //   final dynamicLink =
  //       await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  //   return dynamicLink.shortUrl;
  // }

  // Future<Uri> getDynamicLink(code) async {
  //   UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
  //   final dynamicLinkParams = DynamicLinkParameters(
  //     link: Uri.parse(
  //         "https://app.stocks.news/install?code=${user?.userId}&_id=${user?.userId}"),
  //     // link: Uri.parse(
  //     //     "https://app.stocks.news/install?code=$code&_id=${user?.userId}"),
  //     uriPrefix: "https://stocksnews.page.link",
  //     androidParameters: const AndroidParameters(
  //       packageName: "com.stocks.news",
  //       minimumVersion: 0,
  //     ),
  //     iosParameters: const IOSParameters(
  //       bundleId: "app.stocks.news",
  //     ),
  //   );
  //   final dynamicLink =
  //       await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  //   debugPrint("${dynamicLink.shortUrl}");
  //   return dynamicLink.shortUrl;
  // }
}
