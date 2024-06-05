import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../widgets/error_display_common.dart';
import '../stockTopWidgets/common_heading.dart';
import 'i_frame_item.dart';

//
class RedditTwitterIframe extends StatefulWidget {
  final String? redditRssId, twitterRssId;
  const RedditTwitterIframe({super.key, this.redditRssId, this.twitterRssId});

  @override
  State<RedditTwitterIframe> createState() => _RedditTwitterIframeState();
}

class _RedditTwitterIframeState extends State<RedditTwitterIframe> {
  WebViewController twitter = WebViewController();
  WebViewController reddit = WebViewController();

  @override
  void initState() {
    super.initState();
    _setDataReddit();
    _setDataTwitter();
  }

  void _setDataTwitter() {
    twitter = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));
    if (Platform.isAndroid) {
      twitter.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.prevent;
          },
        ),
      );
    }
    // ..loadHtmlString(_buildTwitterComments());

    twitter.loadHtmlString(_buildTwitterComments());
  }

  void _setDataReddit() {
    reddit = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));

    if (Platform.isAndroid) {
      reddit.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.prevent;
          },
        ),
      );
    }
    // ..loadHtmlString(_buildRedditComments());
    reddit.loadHtmlString(_buildRedditComments());
  }

  String _buildTwitterComments() {
    return '''

// <meta name="viewport" content="width=device-width, initial-scale=0.7">
<iframe width="100%" height="100%" src="https://rss.app/embed/v1/wall/${widget.twitterRssId}" frameborder="0"></iframe>
<!-- TradingView Widget END -->
''';
  }

  String _buildRedditComments() {
    return '''
// <meta name="viewport" content="width=device-width, initial-scale=0.8">
<iframe width="100%" height="100%" src="https://rss.app/embed/v1/wall/${widget.redditRssId}" frameborder="0"></iframe>

''';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.redditRssId == null && widget.twitterRssId != null) {
      return const Center(
        child: ErrorDisplayWidget(
          smallHeight: true,
          error: "No recent reddit comments found.",
        ),
        // child: NoDataCustom(
        //   error: "No recent reddit comments found.",
        // ),
      );
    }

    if (widget.twitterRssId == null && widget.redditRssId != null) {
      return const Center(
        child: ErrorDisplayWidget(
          smallHeight: true,
          error: "No recent X tweets found.",
        ),
        // child: NoDataCustom(
        //   error: "No recent X tweets data found.",
        // ),
      );
    }

    if (widget.twitterRssId == null && widget.redditRssId == null) {
      return const Center(
        child: ErrorDisplayWidget(
          smallHeight: true,
          error: "No recent reddit comments/X tweets found.",
        ),
        // child: NoDataCustom(
        //   error: "No recent reddit comments/X tweets data found.",
        // ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CommonHeadingStockDetail(),
            Visibility(
              visible: widget.redditRssId != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const SpacerVertical(height: 15),
                  const ScreenTitle(
                    title: "Recent Reddit Posts",
                    // style: stylePTSansRegular(fontSize: 20),
                  ),
                  SizedBox(
                    height: isPhone
                        ? constraints.maxWidth * 2.45
                        : constraints.maxWidth * .9,
                    child: WebViewWidget(controller: reddit),
                  ),
                  const SpacerVertical(height: 12),
                  ThemeButtonSmall(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        StockDetailiFrameItem.path,
                        arguments: CommentType.reddit,
                      );
                    },
                    text: "Read More",
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.twitterRssId != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SpacerVertical(height: 15),
                  ScreenTitle(
                    title: "Recent X Tweets",
                    style: stylePTSansRegular(fontSize: 20),
                  ),
                  SizedBox(
                    height: isPhone
                        ? constraints.maxWidth * 1.3
                        : constraints.maxWidth * .6,
                    child: WebViewWidget(controller: twitter),
                  ),
                  const SpacerVertical(height: 12),
                  ThemeButtonSmall(
                    onPressed: () {
                      Navigator.pushNamed(context, StockDetailiFrameItem.path,
                          arguments: CommentType.twitter);
                    },
                    text: "Read More",
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
