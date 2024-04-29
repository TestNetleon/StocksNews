import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingWidget extends StatelessWidget {
  const TradingWidget({super.key});
//
  @override
  Widget build(BuildContext context) {
    String html = '''
          <!-- TradingView Widget BEGIN -->
          <>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <div class="tradingview-widget-container">
            <div class="tradingview-widget-container__widget"></div>
            <div class="tradingview-widget-copyright"><a href="https://in.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
            <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-mini-symbol-overview.js" async>
            {
            "symbol": "FX:EURUSD",
            "width": "100%",
            "height": "210",
            "locale": "in",
            "dateRange": "12M",
            "colorTheme": "dark",
            "isTransparent": false,
            "autosize": false,
            "largeChartUrl": "",
            "noTimeScale": false,
            "chartOnly": false
          }
            </script>
          </div>
          </>
          <!-- TradingView Widget END -->
          ''';

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadHtmlString(html);

    return SizedBox(
      height: 200,
      width: ScreenUtil().screenWidth,
      child: WebViewWidget(controller: controller),
    );
  }
}
