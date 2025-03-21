import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LandingPageIndex extends StatefulWidget {
  final Uri? url;
  final String? stringURL;
  final String? notificationId;
  const LandingPageIndex({
    super.key,
    this.url,
    this.stringURL,
    this.notificationId,
  });

  @override
  State<LandingPageIndex> createState() => _AnalysisForecastState();
}

//
class _AnalysisForecastState extends State<LandingPageIndex> {
  WebViewController controller = WebViewController();
  bool loading = false;
  @override
  void initState() {
    super.initState();
    Utils().showLog("-------${widget.url}---- ${widget.stringURL}---------");
    _setData(url: widget.url, stringURL: widget.stringURL);
  }

  setLoading(value) {
    loading = value;
    setState(() {});
  }

  void _setData({Uri? url, String? stringURL}) {
    Utils().showLog('navigated url: $url');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            Utils().showLog("progress $progress");
          },
          onPageStarted: (String url) {
            setLoading(true);
            Utils().showLog("page finished $url");
          },
          onPageFinished: (String url) {
            setLoading(false);
            Utils().showLog("page finished $url");
          },
          onWebResourceError: (WebResourceError error) {
            setLoading(false);
          },
        ),
      )
      ..loadRequest(
          (stringURL != null && stringURL != "") ? Uri.parse(stringURL) : url!);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(showBack: true),
      body: loading
          ? const ProgressDialog()
          : WebViewWidget(
              controller: controller,
            ),
    );
  }
}
