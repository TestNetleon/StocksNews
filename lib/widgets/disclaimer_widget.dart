import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DisclaimerWidget extends StatelessWidget {
  final String data;
  final EdgeInsets? padding;
  const DisclaimerWidget({required this.data, super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.only(bottom: 16, top: 16),
      // color: ThemeColors.background,
      child: HtmlWidget(
        customStylesBuilder: (element) {
          if (element.localName == 'a') {
            return {'color': '#1bb449', 'text-decoration': 'none'};
          }
          return null;
        },
        onTapUrl: (url) async {
          bool a = await launchUrl(Uri.parse(url));
          Utils().showLog("clicked ur---$url, return value $a");
          return a;
        },
        data,
        textStyle: styleGeorgiaRegular(
          fontSize: 11,
          height: 1.5,
          color: ThemeColors.greyText,
        ),
      ),
    );
  }
}
