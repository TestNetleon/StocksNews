import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingWebview extends StatefulWidget {
  final String? symbol;
  const TradingWebview({super.key, this.symbol});

  @override
  State<TradingWebview> createState() => _ScannerWebviewState();
}

class _ScannerWebviewState extends State<TradingWebview> {
  WebViewController controller = WebViewController();

  bool loaded = false;

  final String htmlContent = """
<div class="tradingview-widget-container" style="height:100%;width:100%">
  <div class="tradingview-widget-container__widget" style="height:calc(100% - 32px);width:100%"></div>
  <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
  <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js" async>
  {
  "autosize": true,
  "symbol": "NASDAQ:AAPL",
  "interval": "D",
  "timezone": "Etc/UTC",
  "theme": "light",
  "style": "1",
  "locale": "en",
  "allow_symbol_change": true,
  "calendar": false,
  "support_host": "https://www.tradingview.com"
}
  </script>
</div>
  """;


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
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
