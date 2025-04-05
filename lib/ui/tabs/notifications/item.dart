import 'package:flutter/material.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/models/notification_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/landing/page.dart';
import 'package:stocks_news_new/ui/account/auth/login.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/tabs/more/articles/detail.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/chats/index.dart';
import 'package:stocks_news_new/ui/tabs/more/news/detail.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/index.dart';
import 'package:stocks_news_new/ui/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NotificationItem extends StatelessWidget {
  final Notifications? data;
  const NotificationItem({super.key, this.data});

  void _onTap(
    BuildContext context,
  ) async {
    try {
      String? type = data?.type;
      String? slug = data?.slug;
      // Navigator.popUntil(
      //   navigatorKey.currentContext!,
      //   (route) => route.isFirst,
      // );

      if (type == NotificationType.dashboard.name) {
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);
        Navigator.pushReplacement(navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => Tabs()));
      } else if (slug != '' && type == NotificationType.ticketDetail.name) {
        // Navigator.pushReplacementNamed(
        //     navigatorKey.currentContext!, HelpDeskAllChatsIndex.path,
        //     arguments: {'ticketId': slug ?? "N/A"});
        Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => HelpDeskAllChatsIndex(
                      ticketId: slug ?? '',
                    )));
      } else if (slug != '' && type == NotificationType.newsDetail.name) {
        // Navigator.pushNamed(navigatorKey.currentContext!, NewsDetailIndex.path,
        //     arguments: {
        //       'slug': slug,
        //     });
        Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => NewsDetailIndex(
                      slug: slug ?? '',
                    )));
      } else if (slug != '' && type == NotificationType.lpPage.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => LandingPageIndex(
              stringURL: slug,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.blogDetail.name) {
        // Navigator.pushNamed(navigatorKey.currentContext!, BlogsDetailIndex.path,
        //     arguments: {
        //       'slug': slug ?? "",
        //     });

        Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => BlogsDetailIndex(
                      slug: slug ?? '',
                    )));
      } else if (slug != '' && type == NotificationType.review.name) {
        Utils().showLog("--navigate to blog detail---");
      } else if (slug != '' && type == NotificationType.register.name) {
        if (await Preference.isLoggedIn()) {
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          // Navigator.pushReplacementNamed(
          //     navigatorKey.currentContext!, Tabs.path);
          Navigator.pushReplacement(navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => Tabs()));

          popUpAlert(
              message: "Welcome to the Home Screen!",
              title: "Alert",
              icon: Images.alertPopGIF);

          return;
        }
        Navigator.pop(context);
        Navigator.push(
          navigatorKey.currentContext!,
          createRoute(AccountLoginIndex()),
        );
      } else if (slug != '' && type == NotificationType.stockDetail.name ||
          isValidTickerSymbol(type ?? "")) {
        // Navigator.pushNamed(navigatorKey.currentContext!, SDIndex.path,
        //     arguments: {
        //       'symbol': slug,
        //     });

        Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => SDIndex(
                      symbol: slug ?? '',
                    )));
      } else if (type == NotificationType.referRegistration.name) {
        // Navigator.pushNamed(navigatorKey.currentContext!, ReferralIndex.path);

        Navigator.push(navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => ReferralIndex()));
      } else if (slug != '' && type == NotificationType.nudgeFriend.name) {
        //referLogin();
      } else {
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);

        Navigator.pushReplacement(navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => Tabs()));
      }
    } catch (e) {
      Utils().showLog("Exception ===>> $e");
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      // Navigator.pushReplacementNamed(navigatorKey.currentContext!, Tabs.path);
      Navigator.pushReplacement(navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => Tabs()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(context),
      child: Container(
        margin:
            EdgeInsets.symmetric(vertical: Pad.pad16, horizontal: Pad.pad10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImagesWidget(data?.image),
              ),
            ),
            SpacerHorizontal(width: Pad.pad10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.title ?? "",
                    style: styleBaseRegular(
                        fontSize: 14, color: ThemeColors.splashBG),
                  ),
                  const SpacerVertical(height: Pad.pad5),
                  Text(
                    data?.message ?? "",
                    style: styleBaseRegular(
                        fontSize: 12, color: ThemeColors.neutral40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
