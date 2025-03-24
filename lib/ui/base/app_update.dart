import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BaseAppUpdate extends StatelessWidget {
  final HomeLoginBoxRes? data;

  const BaseAppUpdate({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bgColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Image.asset(
            Images.updateApp,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(Pad.pad24),
              child: Column(
                children: [
                  HtmlWidget(
                    data?.title ?? '',
                    textStyle: TextStyle(fontFamily: Fonts.roboto),
                  ),
                  SpacerVertical(height: 10),
                  HtmlWidget(
                    data?.subtitle ?? '',
                    textStyle: TextStyle(fontFamily: Fonts.roboto),
                  ),
                  SpacerVertical(height: 30),
                  BaseButton(
                    onPressed: _onUpdateClick,
                    text: data?.buttonText ?? '',
                  ),
                  SpacerVertical(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onUpdateClick() {
    if (Platform.isAndroid) {
      openUrl("https://play.google.com/store/apps/details?id=com.stocks.news");
    } else {
      openUrl("https://apps.apple.com/us/app/stocks-news/id6476615803");
    }
  }
}
