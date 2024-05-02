import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:webview_flutter/webview_flutter.dart';

//
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
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    KeyStats? keyStats = provider.data?.keyStats;
    return Column(
      children: [
        ScreenTitle(
          title: "${keyStats?.name} (${keyStats?.symbol})",
          subTitle: provider.dataMentions?.forecastText,
        ),
        Container(
          width: double.infinity,
          height: 250.sp,
          color: ThemeColors.background,
          child: WebViewWidget(
            controller: controller,
          ),
        ),
        const SpacerVertical(height: Dimen.itemSpacing),
      ],
    );
  }
}
