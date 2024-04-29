import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';

import 'package:stocks_news_new/widgets/base_container.dart';
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

  @override
  void initState() {
    super.initState();

    _setData(url: widget.url, stringURL: widget.stringURL);
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
            log("page finished $url");
          },
          onPageFinished: (String url) {
            log("page finished $url");
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
          (stringURL != null && stringURL != "") ? Uri.parse(stringURL) : url!);
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appbar: const AppBarHome(
        isPopback: true,
        showTrailing: false,
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
