import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';

class DynamicLinkService {
  static final DynamicLinkService _singleton = DynamicLinkService._internal();
  DynamicLinkService._internal();
  static DynamicLinkService get instance => _singleton;

  Future<Uri> getDynamicLink() async {
    UserRes? user = navigatorKey.currentContext!.read<UserManager>().user;
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
}
