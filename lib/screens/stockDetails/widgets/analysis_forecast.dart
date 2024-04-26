import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AnalysisForecast extends StatefulWidget {
  final String? html;
  const AnalysisForecast({super.key, this.html});

  @override
  State<AnalysisForecast> createState() => _AnalysisForecastState();
}

class _AnalysisForecastState extends State<AnalysisForecast> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    _setData(html: widget.html);
  }

  void _setData({String? html}) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadHtmlString(html ?? "");
  }

  @override
  Widget build(BuildContext context) {
    KeyStats? keyStats = context.watch<StockDetailProvider>().data?.keyStats;
    return Column(
      children: [
        ScreenTitle(
          title: "${keyStats?.name} (${keyStats?.symbol}) Analysis Forecast",
          subTitle:
              "The Analyst Forecasts section displays Wall Street analysts' predictions for stock price growth or decline in the next 12 months.",
          // style: stylePTSansRegular(fontSize: 20),
        ),
        Container(
          width: double.infinity,
          height: 250.sp,
          color: ThemeColors.background,
          child: WebViewWidget(
            controller: controller,
          ),
        ),
        const SpacerVerticel(height: Dimen.itemSpacing),
      ],
    );
  }
}
