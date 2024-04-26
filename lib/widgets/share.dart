import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommonShare extends StatefulWidget {
  final bool visible;
  final String linkShare;
  final String title;
  const CommonShare(
      {super.key,
      required this.visible,
      required this.linkShare,
      required this.title});

  @override
  State<CommonShare> createState() => _CommonShareState();
}

class _CommonShareState extends State<CommonShare> {
  List<ShareClass> shareList = [
    ShareClass(
      image: Images.facebook,
      onTap: (link, title) async {
        String baseUrl =
            "https://www.facebook.com/sharer/sharer.php?u=$link&quote=$title";

        String url = Platform.isAndroid ? baseUrl : "fb://share/?url=$link";

        await openUrl(url, extraUrl: baseUrl);
      },
    ),
    ShareClass(
      image: Images.twitter,
      onTap: (link, title) async {
        String baseUrl =
            "https://twitter.com/intent/tweet?url=$link&text=$title";

        String url = Platform.isAndroid
            ? baseUrl
            : "twitter://post?message=$title:url=$link";

        await openUrl(url, extraUrl: baseUrl);
      },
    ),
    ShareClass(
      image: Images.linkedin,
      onTap: (link, title) async {
        String baseUrl = "https://www.linkedin.com/share?url=$link";

        String url =
            Platform.isAndroid ? baseUrl : "linkedin://share?url=$link";

        await openUrl(url, extraUrl: baseUrl);
      },
    ),
    ShareClass(
      image: Images.whatsapp,
      onTap: (link, title) {
        String baseUrl = "https://api.whatsapp.com/send?text=$title $link";
        String url = Platform.isAndroid
            ? baseUrl
            : 'whatsapp://send?text=$title:url=$link';

        openUrl(url, extraUrl: baseUrl);
      },
    ),
    ShareClass(
      image: Images.telegram,
      onTap: (link, title) async {
        String baseUrl = "https://t.me/share/url?url=$link&text=$title";

        String url = Platform.isAndroid ? baseUrl : baseUrl;

        await openUrl(url,
            mode: LaunchMode.externalNonBrowserApplication, extraUrl: baseUrl);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: AnimatedContainer(
        decoration: const BoxDecoration(
          color: ThemeColors.greyBorder,
          // border: const Border(
          //   right: BorderSide(color: ThemeColors.border),
          //   left: BorderSide(color: ThemeColors.border),
          //   top: BorderSide(color: ThemeColors.border),
          // ),
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(5.sp),
          //   topRight: Radius.circular(5.sp),
          // ),
        ),
        duration: const Duration(milliseconds: 400),
        height: widget.visible ? 30.0 : 0.0,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => shareList[0].onTap(widget.linkShare, widget.title),
                // onTap: () => shareList[0].onTap(widget.linkShare, "Hi, There"),

                child: Container(
                  color: const Color(0xFF1976D2),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5.sp, 6.sp, 8.sp),
                    child: Image.asset(
                      shareList[0].image ?? "",
                      // height: 20,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => shareList[1].onTap(widget.linkShare, widget.title),
                // onTap: () => shareList[1].onTap(widget.linkShare, "Hi, There"),

                child: Container(
                  color: const Color(0xFF000000),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(6.sp, 9.sp, 6.sp, 9.sp),
                    child: Image.asset(
                      shareList[1].image ?? "",
                      color: ThemeColors.white,
                      // height: 20,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => shareList[2].onTap(widget.linkShare, widget.title),
                child: Container(
                  color: const Color(0xFF0077B5),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.sp, 5.sp, 6.sp, 5.sp),
                    child: Image.asset(
                      shareList[2].image ?? "",
                      // height: 20,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => shareList[3].onTap(widget.linkShare, widget.title),
                // onTap: () => shareList[3].onTap(widget.linkShare, "Hi, There"),

                child: Container(
                  color: const Color(0xFF29A71A),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.sp, 4.sp, 6.sp, 4.sp),
                    child: Image.asset(
                      shareList[3].image ?? "",
                      // height: 20,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => shareList[4].onTap(widget.linkShare, widget.title),
                // onTap: () => shareList[4].onTap(widget.linkShare, "Hi, There"),

                child: Container(
                  color: const Color(0xFF25A3E1),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.sp, 3.sp, 6.sp, 3.sp),
                    child: Image.asset(
                      shareList[4].image ?? "",
                      // height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareClass {
  String? image;
  String? name;
  Function(String link, String title) onTap;
  ShareClass({
    this.image,
    this.name,
    required this.onTap,
  });
}
