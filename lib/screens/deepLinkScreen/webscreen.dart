import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';

import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewLink extends StatefulWidget {
  final Uri? url;
  final String? stringURL;
  const WebviewLink({super.key, this.url, this.stringURL});

  @override
  State<WebviewLink> createState() => _AnalysisForecastState();
}

//
class _AnalysisForecastState extends State<WebviewLink> {
  WebViewController controller = WebViewController();
  bool loading = false;
  @override
  void initState() {
    super.initState();
    log("-------${widget.url}---- ${widget.stringURL}---------");
    _setData(url: widget.url, stringURL: widget.stringURL);
  }

  setLoading(value) {
    loading = value;
    setState(() {});
  }

  void _setData({Uri? url, String? stringURL}) {
    log('navigated url: $url');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log("progress $progress");
          },
          onPageStarted: (String url) {
            setLoading(true);
            log("page finished $url");
          },
          onPageFinished: (String url) {
            setLoading(false);
            log("page finished $url");
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
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        showTrailing: false,
      ),
      body: loading
          ? const ProgressDialog()
          : WebViewWidget(
              controller: controller,
            ),
    );
  }
}
