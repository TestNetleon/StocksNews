import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/graph_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StockDetailTopGraph extends StatefulWidget {
  const StockDetailTopGraph({super.key});

  @override
  State<StockDetailTopGraph> createState() => _StockDetailTopGraphState();
}

class _StockDetailTopGraphState extends State<StockDetailTopGraph> {
  WebViewController? _controller;

  List<GraphRes> graphRes = [
    GraphRes(name: "1D", isSelected: true),
    GraphRes(name: "5D"),
    GraphRes(name: "1M"),
    GraphRes(name: "6M"),
    GraphRes(name: "YTD"),
    GraphRes(name: "1Y"),
    GraphRes(name: "5Y"),
  ];

  @override
  void initState() {
    super.initState();
    _setData();
  }

  void _setData({String range = "1D"}) {
    String? symbol = context.read<StockDetailProvider>().data?.keyStats?.symbol;
    String? name = context.read<StockDetailProvider>().data?.keyStats?.name;
    String? exchange =
        context.read<StockDetailProvider>().data?.keyStats?.exchange;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));

    if (Platform.isAndroid) {
      _controller!.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.prevent;
          },
        ),
      );
    }

    _controller!.loadHtmlString(
      _buildHtmlContent(symbol, name, range, exchange),
    );
  }

  String _buildHtmlContent(
      String? symbol, String? name, String range, String? exchange) {
//https://in.tradingview.com/widget/symbol-overview/  GRAPH CAN BE EDITED FROM THIS LINK

    return '''
        <meta name="viewport" content="width=device-width, initial-scale=0.6">
        <div class="tradingview-widget-container" style="height:100%;width:100%">
          <div class="tradingview-widget-container__widget" style="height:calc(100% - 32px);width:100%"></div>
          <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js" async>
          {
          "autosize": true,
          "symbol": "$exchange:$symbol",
          "interval": "D",
          "timezone": "Etc/UTC",
          "theme": "dark",
          "style": "1",
          "locale": "in",
          "enable_publishing": false,
          "support_host": "https://www.tradingview.com"
        }
          </script>
        </div>
        <!-- TradingView Widget END -->
        ''';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_controller != null)
          Container(
            color: ThemeColors.primaryLight,
            width: double.infinity,
            height: 300.sp,
            margin: EdgeInsets.symmetric(vertical: Dimen.padding.sp),
            child: WebViewWidget(
              controller: _controller!,
            ),
          ),
        // Container(
        //   padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10.sp),
        //     color: ThemeColors.primaryLight,
        //     boxShadow: const [
        //       BoxShadow(
        //         color: ThemeColors.background,
        //         blurRadius: 3,
        //         spreadRadius: 2,
        //       ),
        //     ],
        //   ),
        //   height: 40.sp,
        //   child: ListView.separated(
        //     physics: const NeverScrollableScrollPhysics(),
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) {
        //       return InkWell(
        //         onTap: () => _onTap(index),
        //         child: Text(
        //           graphRes[index].name,
        //           style: stylePTSansBold(
        //               color: graphRes[index].isSelected
        //                   ? ThemeColors.accent
        //                   : Colors.white),
        //         ),
        //       );
        //     },
        //     separatorBuilder: (context, index) {
        //       return VerticalDivider(
        //         color: ThemeColors.greyBorder,
        //         thickness: 2,
        //         width: 20.sp,
        //       );
        //     },
        //     itemCount: graphRes.length,
        //   ),
        // )
      ],
    );
  }

  // _onTap(index) {
  //   _setData(range: graphRes[index].name);
  //   for (int i = 0; i < graphRes.length; i++) {
  //     if (i != index) {
  //       graphRes[i].isSelected = false;
  //     }
  //   }
  //   graphRes[index].isSelected = true;

  //   setState(() {});
  // }
}
