import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class AppUpdateContent extends StatelessWidget {
  const AppUpdateContent({
    super.key,
    required this.extra,
  });

  final Extra extra;

  void _onUpdateClick() {
    if (Platform.isAndroid) {
      openUrl("https://play.google.com/store/apps/details?id=com.stocks.news");
    } else {
      openUrl("https://apps.apple.com/us/app/stocks-news/id6476615803");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 60),
          constraints: const BoxConstraints(
            minHeight: 200,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            extra.appUpdateTitle ?? "",
                            style: stylePTSansBold(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          "V${Platform.isAndroid ? extra.androidBuildVersion : extra.iOSBuildVersion}",
                          style: stylePTSansBold(
                            color: const Color.fromARGB(255, 2, 80, 12),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.sp),
                      child: HtmlWidget(
                        extra.appUpdateMsg ?? "",
                        textStyle: styleGeorgiaRegular(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: ThemeButtonSmall(
                        onPressed: _onUpdateClick,
                        text: "Update Now",
                        showArrow: false,
                        fontBold: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            child: Image.asset(
              Images.updateGIF,
              fit: BoxFit.contain,
              height: 120,
              width: 120,
            ),
          ),
        ),
      ],
    );
  }
}
