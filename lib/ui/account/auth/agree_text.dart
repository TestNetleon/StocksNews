import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/managers/onboarding.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/legal/index.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../../utils/utils.dart';

class AccountAgreeText extends StatefulWidget {
  final bool showFull;
  final int defaultLength;

  const AccountAgreeText({
    super.key,
    this.showFull = false,
    this.defaultLength = 150,
  });

  @override
  State<AccountAgreeText> createState() => _AccountAgreeTextState();
}

class _AccountAgreeTextState extends State<AccountAgreeText> {
  bool _isExpanded = false;

  String get _truncatedContent {
    MyHomeManager provider = context.read<MyHomeManager>();

    HomeLoginBoxRes? loginBox = provider.data?.loginBox;
    Utils().showLog("data => ${loginBox == null} ...");
    if (loginBox == null) {
      OnboardingManager onBoardingManager = context.watch<OnboardingManager>();
      loginBox = onBoardingManager.data?.loginBox;
    }

    String content = loginBox?.agreeUrl ?? _agreeUrl;

    return content.length > widget.defaultLength
        ? '${content.substring(0, widget.defaultLength)}...'
        : content;
  }

  final String _agreeUrl =
      'By CHECKING THE BOX, I agree that Stocks.News and our affiliates including <b><span id=\"advertiser_id\">InteractiveOffers<\/span><\/b> may contact me at the number I entered, with offers and other info, including possible use of automated technology, recorded and SMS messages. Consent is not a condition of purchase. Additionally, By CHECKING THE BOX I agree to the following <a style=\"color:#1bb449;\" href=\"terms-of-service\">terms of service<\/a>, <a style=\"color:#1bb449;\" href=\"privacy-policy\">privacy policy<\/a> and <a style=\"color:#1bb449;\" href=\"https:\/\/www.interactiveoffers.com\/privacy-policy\" target=\"_blank\">affiliate privacy policy<\/a>.<br><br>';

  @override
  Widget build(BuildContext context) {
    MyHomeManager provider = context.watch<MyHomeManager>();

    HomeLoginBoxRes? loginBox = provider.data?.loginBox;
    Utils().showLog("data => ${loginBox == null} ...");
    if (loginBox == null) {
      OnboardingManager onBoardingManager = context.watch<OnboardingManager>();
      loginBox = onBoardingManager.data?.loginBox;
    }

    if (loginBox == null || loginBox.id == null || loginBox.id == '') {
      return SizedBox();
    }

    String content = widget.showFull || _isExpanded
        ? loginBox.agreeUrl ?? _agreeUrl
        : _truncatedContent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
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
            if (!(url.startsWith('https:') || url.startsWith('http:'))) {
              Navigator.pushNamed(context, LegalInfoIndex.path, arguments: {
                'slug': url == "terms-of-service"
                    ? "terms-of-service"
                    : "privacy-policy",
              });
            } else {
              openUrl(url);
            }

            return true;
          },
          textStyle: styleGeorgiaRegular(fontSize: 14, height: 1.6),
        ),
        if (content.length > widget.defaultLength && !widget.showFull)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Read Less' : 'Read More',
              style: stylePTSansRegular(
                color: ThemeColors.primary120,
              ),
            ),
          ),
      ],
    );
  }
}
