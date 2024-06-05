import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StockDetailiFrameItem extends StatefulWidget {
  static const path = "StockDetailiFrameItem";
  final CommentType type;
  const StockDetailiFrameItem({super.key, required this.type});
//
  @override
  State<StockDetailiFrameItem> createState() => _StockDetailiFrameItemState();
}

class _StockDetailiFrameItemState extends State<StockDetailiFrameItem> {
  WebViewController twitter = WebViewController();
  WebViewController reddit = WebViewController();
  String? redditRssId;
  String? twitterRssId;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() {
    CompanyInfo? companyInfo =
        context.read<StockDetailProvider>().data?.companyInfo;

    redditRssId = companyInfo?.redditRssId;
    twitterRssId = companyInfo?.twitterRssId;
    Utils().showLog("Reddit RSS id $redditRssId ");
    Utils().showLog("Twitter RSS id $twitterRssId ");

    setState(() {});

    if (redditRssId != null) {
      _setDataReddit();
    }
    if (twitterRssId != null) {
      _setDataTwitter();
    }
  }

  void _setDataTwitter() {
    twitter = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            Utils().showLog("$progress");
          },
          onPageStarted: (String url) {
            loading = true;
            setState(() {});
            Utils().showLog("page started");
          },
          onPageFinished: (String url) {
            loading = false;
            setState(() {});
            Utils().showLog("page finished");
          },
          onWebResourceError: (WebResourceError error) {
            loading = false;
            setState(() {});
            Utils().showLog("Error $error");
          },
        ),
      )
      ..loadHtmlString(_buildTwitterComments());
  }

  void _setDataReddit() {
    reddit = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            Utils().showLog("Error $error");
          },
        ),
      )
      ..loadHtmlString(_buildRedditComments());
  }

  String _buildTwitterComments() {
    return '''
// <meta name="viewport" content="width=device-width, initial-scale=0.7">
<iframe width="100%" height="100%" src="https://rss.app/embed/v1/wall/$twitterRssId" frameborder="0"></iframe>
<!-- TradingView Widget END -->
''';
  }

  String _buildRedditComments() {
    return '''
// <meta name="viewport" content="width=device-width, initial-scale=0.8">
<iframe width="100%" height="100%" src="https://rss.app/embed/v1/wall/$redditRssId" frameborder="0"></iframe>
''';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == CommentType.reddit && redditRssId == null) {
      return const SizedBox();
    } else if (widget.type == CommentType.twitter && twitterRssId == null) {
      return const SizedBox();
    }

    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding.sp,
          Dimen.padding.sp,
          Dimen.padding.sp,
          0,
        ),
        child: Column(
          children: [
            ScreenTitle(
              title: widget.type == CommentType.reddit
                  ? "All Recent Reddit Post"
                  : "All Recent X Tweets",
            ),
            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ThemeColors.accent,
                      ),
                    )
                  : WebViewWidget(
                      controller:
                          widget.type == CommentType.reddit ? reddit : twitter,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
