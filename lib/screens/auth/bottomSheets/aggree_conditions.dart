import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';

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

class NewAgreeConditions extends StatelessWidget {
  final double fontSize;
  final String? text;
  const NewAgreeConditions({
    super.key,
    this.fontSize = 15,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    // if (text == null || text == '') {
    //   return RichText(
    //     textAlign: TextAlign.center,
    //     text: TextSpan(
    //       text: 'By logging in or signing up you agree to our ',
    //       style: stylePTSansRegular(
    //         height: 1.4,
    //         fontSize: 13,
    //       ),
    //       children: [
    //         TextSpan(
    //           recognizer: TapGestureRecognizer()
    //             ..onTap = () {
    //               Navigator.push(
    //                 context,
    //                 createRoute(
    //                   const TCandPolicy(
    //                     policyType: PolicyType.tC,
    //                     slug: "terms-of-service",
    //                   ),
    //                 ),
    //               );
    //             },
    //           text: 'terms of service',
    //           style: stylePTSansRegular(
    //             color: ThemeColors.accent,
    //             height: 1.4,
    //             fontSize: 13,
    //           ),
    //         ),
    //         TextSpan(
    //           text: ' and ',
    //           style: stylePTSansRegular(
    //             height: 1.4,
    //             fontSize: 13,
    //           ),
    //         ),
    //         TextSpan(
    //           recognizer: TapGestureRecognizer()
    //             ..onTap = () {
    //               Navigator.push(
    //                 context,
    //                 createRoute(
    //                   const TCandPolicy(
    //                     policyType: PolicyType.privacy,
    //                     slug: "privacy-policy",
    //                   ),
    //                 ),
    //               );
    //             },
    //           text: 'privacy policy',
    //           style: stylePTSansRegular(
    //             color: ThemeColors.accent,
    //             height: 1.4,
    //             fontSize: 13,
    //           ),
    //         ),
    //         TextSpan(
    //           text: '.',
    //           style: stylePTSansRegular(
    //             height: 1.4,
    //             fontSize: 13,
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return HtmlWidget(
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {'color': '#1bb449', 'text-decoration': 'none'};
        }
        return null;
      },
      onTapUrl: (url) async {
        Utils().showLog('URL => $url');

        closeKeyboard();
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
      text ?? "",
      textStyle: styleGeorgiaRegular(
        height: 1.5,
        fontSize: fontSize,
      ),
    );
  }
}

class LoginSignupID extends StatefulWidget {
  final double fontSize;
  final bool showFull;
  final int defaultLength;

  const LoginSignupID(
      {super.key,
      this.fontSize = 15,
      this.showFull = false,
      this.defaultLength = 150});

  @override
  State<LoginSignupID> createState() => _LoginSignupIDState();
}

class _LoginSignupIDState extends State<LoginSignupID> {
  bool _isExpanded = false;

  String get _truncatedContent {
    UserProvider provider = context.read<UserProvider>();

    String content = provider.advertiserRes?.agreeUrl ?? "";

    return content.length > widget.defaultLength
        ? '${content.substring(0, widget.defaultLength)}...'
        : content;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();

    if (provider.advertiserRes == null ||
        provider.advertiserRes?.id == null ||
        provider.advertiserRes?.id == '') {
      return SizedBox();
    }

    String content = widget.showFull || _isExpanded
        ? provider.advertiserRes?.agreeUrl ?? ""
        : _truncatedContent;

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              HtmlWidget(
                content,
                customStylesBuilder: (element) {
                  if (element.localName == 'a') {
                    return {'color': '#1bb449', 'text-decoration': 'none'};
                  }
                  return null;
                },
                onTapUrl: (url) async {
                  // Utils().showLog('URL => $url');
                  // closeKeyboard();

                  if (!(url.startsWith('https:') || url.startsWith('http:'))) {
                    Navigator.push(
                      context,
                      createRoute(
                        TCandPolicy(
                          policyType: url == "terms-of-service"
                              ? PolicyType.tC
                              : PolicyType.privacy,
                          slug: url,
                        ),
                      ),
                    );
                  } else {
                    openUrl(url);
                  }

                  return true;
                },
                textStyle: styleGeorgiaRegular(
                  height: 1.5,
                  fontSize: widget.fontSize,
                ),
              ),
              if (content.length > widget.defaultLength && !widget.showFull)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Read Less' : 'Read More',
                      style: stylePTSansRegular(
                        color: ThemeColors.accent,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
