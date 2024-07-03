import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../../../utils/utils.dart';
import '../../t&cAndPolicy/tc_policy.dart';

class AgreeConditions extends StatelessWidget {
  final bool fromLogin;
  const AgreeConditions({super.key, this.fromLogin = true});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    if ((provider.loginTxt == null || provider.loginTxt == '') &&
        (provider.signUpTxt == null || provider.signUpTxt == '')) {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: fromLogin
              ? 'By log in you agree to our '
              : 'By signing up you agree to our ',
          style: stylePTSansRegular(height: 1.4),
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    createRoute(
                      const TCandPolicy(
                        policyType: PolicyType.tC,
                        slug: "terms-of-service",
                      ),
                    ),
                  );
                },
              text: 'terms of service',
              style: stylePTSansRegular(color: ThemeColors.accent, height: 1.4),
            ),
            TextSpan(
              text: ' and ',
              style: stylePTSansRegular(height: 1.4),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    createRoute(
                      const TCandPolicy(
                        policyType: PolicyType.privacy,
                        slug: "privacy-policy",
                      ),
                    ),
                  );
                },
              text: 'privacy policy',
              style: stylePTSansRegular(color: ThemeColors.accent, height: 1.4),
            ),
            TextSpan(
              text: '.',
              style: stylePTSansRegular(height: 1.4),
            ),
          ],
        ),
      );
    }

    return HtmlWidget(
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {'color': '#1bb449', 'text-decoration': 'none'};
        }
        return null;
      },
      onTapUrl: (url) async {
        Navigator.push(
          context,
          createRoute(
            TCandPolicy(
              policyType: url == "terms-of-service"
                  ? PolicyType.tC
                  : PolicyType.privacy,
              slug: url == "terms-of-service"
                  ? "terms-of-service"
                  : "privacy-policy",
            ),
          ),
        );
        return true;
      },
      fromLogin ? provider.loginTxt ?? "" : provider.signUpTxt ?? "",
      textStyle: styleGeorgiaRegular(height: 1.5),
    );
  }
}
