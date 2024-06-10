import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/notification_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet_tablet.dart';
import 'package:stocks_news_new/screens/deepLinkScreen/webscreen.dart';
import 'package:stocks_news_new/screens/drawer/widgets/review_app_pop_up.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
//
import '../../widgets/theme_image_view.dart';
import '../blogDetail/index.dart';

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
        Utils().showLog("--navigate to dashboard---");
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!, Tabs.path, (route) => false);
      } else if (slug != '' && type == NotificationType.newsDetail.name) {
        Utils().showLog("--navigate to news detail---");

        Navigator.pushNamed(
          navigatorKey.currentContext!,
          NewsDetails.path,
          arguments: {"slug": slug},
        );
      } else if (slug != '' && type == NotificationType.lpPage.name) {
        Utils().showLog("--navigate to landing page---");

        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => WebviewLink(
              stringURL: slug,
            ),
          ),
        );
      } else if (slug != '' && type == NotificationType.blogDetail.name) {
        Utils().showLog("--navigate to blog detail---");

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
        Utils().showLog("--navigate to blog detail---");
        if (await Preference.isLoggedIn()) {
          Navigator.pushNamedAndRemoveUntil(
              navigatorKey.currentContext!, Tabs.path, (route) => false);
          popUpAlert(
              message: "Welcome to the Home Screen!",
              title: "Alert",
              icon: Images.alertPopGIF);

          return;
        }
        Navigator.pop(context);
        isPhone ? signupSheet() : signupSheetTablet();
      }
      // else {
      //   Utils().showLog("--navigate to stock detail---");

      //   Navigator.pushNamed(
      //     navigatorKey.currentContext!,
      //     StockDetails.path,
      //     // arguments: type,
      //     arguments: {"slug": type},
      //   );
      // }
    } catch (e) {
      Utils().showLog("Exception ===>> $e");
      Navigator.pushNamedAndRemoveUntil(
          navigatorKey.currentContext!, Tabs.path, (route) => false);
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
      //         Navigator.pushNamedAndRemoveUntil(
      //             navigatorKey.currentContext!, Tabs.path, (route) => false);
      //       }
      //     : data.slug != "" && data.type == ''
      //         ? () {
      //             if (data.slug == '') {
      //               return;
      //             }
      //             Navigator.pushNamed(context, NewsDetails.path,
      //                 arguments: data.slug);
      //           }
      //         : () {
      //             if (data.type == '') {
      //               return;
      //             }

      //             Navigator.pushNamed(context, StockDetails.path,
      //                 arguments: data.type);
      //           },
      borderRadius: BorderRadius.circular(5.sp),
      child: Container(
        decoration: BoxDecoration(
            color: ThemeColors.greyBorder.withOpacity(0.6),
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
