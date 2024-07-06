import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/notification_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/index.dart';
import 'package:stocks_news_new/screens/auth/signup/signup_sheet.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/screens/drawer/widgets/review_app_pop_up.dart';
import 'package:stocks_news_new/screens/help/chatScreen/chat_screen.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
//
import '../../widgets/theme_image_view.dart';
import '../auth/refer/refer_code.dart';
import '../auth/signup/signup_sheet_tablet.dart';
import '../blogDetail/index.dart';
import '../stockDetail/index.dart';

class NotificationsItem extends StatelessWidget {
  final NotificationData data;
  const NotificationsItem({super.key, required this.data});

  void _onTap(
    BuildContext context,
  ) async {
    try {
      String? type = data.type;
      String? slug = data.slug;
      // Navigator.popUntil(
      //   navigatorKey.currentContext!,
      //   (route) => route.isFirst,
      // );

      if (type == NotificationType.dashboard.name) {
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
      } else if (slug != '' && type == NotificationType.ticketDetail.name) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              slug: "1",
              ticketId: slug,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.newsDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => NewsDetails(slug: slug)),
        );
      } else if (slug != '' && type == NotificationType.lpPage.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => WebviewLink(
              stringURL: slug,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.blogDetail.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => BlogDetail(
              slug: slug ?? "",
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.review.name) {
        Utils().showLog("--navigate to blog detail---");

        showDialog(
          context: navigatorKey.currentContext!,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) {
            return const ReviewAppPopUp();
          },
        );
      } else if (slug != '' && type == NotificationType.register.name) {
        if (await Preference.isLoggedIn()) {
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const Tabs()),
          );
          popUpAlert(
              message: "Welcome to the Home Screen!",
              title: "Alert",
              icon: Images.alertPopGIF);

          return;
        }
        Navigator.pop(context);
        isPhone ? signupSheet() : signupSheetTablet();
      } else if (slug != '' && type == NotificationType.stockDetail.name ||
          isValidTickerSymbol(type)) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => StockDetail(symbol: slug!)),
        );
      } else if (type == NotificationType.referRegistration.name) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const ReferAFriend()),
        );
      } else if (slug != '' && type == NotificationType.nudgeFriend.name) {
        referLogin();
      } else {
        Navigator.popUntil(
            navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => const Tabs()),
        );
      }
    } catch (e) {
      Utils().showLog("Exception ===>> $e");
      Navigator.popUntil(
          navigatorKey.currentContext!, (route) => route.isFirst);
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Tabs()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // String date =
    //     DateFormat("MMM dd, yyyy").format(data.createdAt ?? DateTime.now());

    // String time = DateFormat("h:mm a").format(data.createdAt ?? DateTime.now());
    return InkWell(
      onTap: () => _onTap(context),
      // onTap: data.type == "dashboard"
      //     ? () {
      //         Navigator.pushAndRemoveUntil(
      //             navigatorKey.currentContext!, Tabs.path, (route) => false);
      //       }
      //     : data.slug != "" && data.type == ''
      //         ? () {
      //             if (data.slug == '') {
      //               return;
      //             }
      //             Navigator.push(context, NewsDetails.path,
      //                 arguments: data.slug);
      //           }
      //         : () {
      //             if (data.type == '') {
      //               return;
      //             }

      //             Navigator.push(context, StockDetails.path,
      //                 arguments: data.type);
      //           },
      borderRadius: BorderRadius.circular(5.sp),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 23, 23, 23),
                // ThemeColors.greyBorder,
                Color.fromARGB(255, 39, 39, 39),
              ],
            ),
            borderRadius: BorderRadius.circular(5.sp)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(13.sp, 13.sp, 13.sp, 13.sp),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.chat_rounded,
                    color: ThemeColors.accent,
                  ),
                  const SpacerHorizontal(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: stylePTSansRegular(),
                        ),
                        const SpacerVertical(height: 6),
                        Text(
                          data.message,
                          style: stylePTSansRegular(
                              fontSize: 12, color: ThemeColors.greyText),
                        ),

                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Text(
                        //     date,
                        //     style: stylePTSansRegular(fontSize: 13),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 10),
              Visibility(
                visible: data.image != null && data.image != '',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.sp),
                  child: ThemeImageView(
                    url: data.image ?? "",
                    // height: 60.sp,
                    // width: 60.sp,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SpacerVertical(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  data.postDateString ?? "",
                  style: stylePTSansRegular(
                      fontSize: 12, color: ThemeColors.greyText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
