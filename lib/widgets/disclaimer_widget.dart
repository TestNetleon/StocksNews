import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class DisclaimerWidget extends StatelessWidget {
  final String data;
  final EdgeInsets? padding;
  const DisclaimerWidget({required this.data, super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
      // color: ThemeColors.background,
      child: HtmlWidget(
        // customStylesBuilder: (element) {
        //   if (element.localName == 'a') {
        //     return {'color': '#1bb449', 'text-decoration': 'none'};
        //   }
        //   return null;
        // },
        onTapUrl: (url) async {
          // bool a = await launchUrl(Uri.parse(url));
          // bool a = await openUrl(url);
          Navigator.push(
            context,
            createRoute(
              const TCandPolicy(
                policyType: PolicyType.disclaimer,
                slug: "disclaimer",
              ),
            ),
          );
          return true;
        },
        data,
        // textStyle: styleGeorgiaRegular(
        //   fontSize: 11,
        //   height: 1.5,
        //   color: ThemeColors.greyText,
        // ),
        textStyle: const TextStyle(
          fontFamily: Fonts.roboto,
          // color: Colors.grey,
        ),
      ),
    );
  }
}
