import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScannerWebview extends StatefulWidget {
  const ScannerWebview({super.key});

  @override
  State<ScannerWebview> createState() => _ScannerWebviewState();
}

class _ScannerWebviewState extends State<ScannerWebview> {
  WebViewController controller = WebViewController();

  bool loaded = false;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            if (url == Apis.stocksScreenerWebUrl) {
              Utils().showLog("Started ****");
              if (!loaded) {
                showGlobalProgressDialog();
              }
            }
          },
          onPageFinished: (String url) {
            if (url == Apis.stocksScreenerWebUrl) {
              if (!loaded) {
                closeGlobalProgressDialog();
              }
              Utils().showLog("Loaded ****");
              loaded = true;
            }
          },
          onWebResourceError: (WebResourceError error) {
            Utils().showLog("Error $error");
          },
        ),
      )
      ..loadRequest(Uri.parse(Apis.stocksScreenerWebUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
