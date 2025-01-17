import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScannerWebview extends StatefulWidget {
  const ScannerWebview({super.key});

  @override
  State<ScannerWebview> createState() => _ScannerWebviewState();
}

class _ScannerWebviewState extends State<ScannerWebview> {
  WebViewController controller = WebViewController();

  String data = "";

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   MarketScannerProvider provider = context.read<MarketScannerProvider>();
    //   provider.startListeningPorts();
    // });

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            Utils().showLog("Error $error");
          },
        ),
      )
      ..loadRequest(Uri.parse('https://app.stocks.news/market-scanner'));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
