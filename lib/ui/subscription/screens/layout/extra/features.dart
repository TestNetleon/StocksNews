import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class MembershipFeatures extends StatelessWidget {
  final List<String>? features;
  const MembershipFeatures({super.key, this.features});

  @override
  Widget build(BuildContext context) {
    if (features == null || features?.isEmpty == true) {
      return SizedBox();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          features?.length ?? 0,
          (index) {
            return Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.tickCircle,
                    height: 22,
                    width: 22,
                    color: ThemeColors.accent,
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      child: HtmlWidget(
                        features?[index] ?? '',
                        textStyle:
                            styleBaseRegular(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
