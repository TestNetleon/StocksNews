// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class HomeGradientBox extends StatefulWidget {
//   final String name;
//   final String value;
//   final String valueChanged;
//   final String valueChangedPer;
//   final bool positive;
//   final int type;

//   const HomeGradientBox({
//     required this.name,
//     required this.value,
//     required this.valueChanged,
//     required this.valueChangedPer,
//     this.positive = false,
//     this.type = 1,
//     super.key,
//   });
//
//   @override
//   State<HomeGradientBox> createState() => _HomeGradientBoxState();
// }

// class _HomeGradientBoxState extends State<HomeGradientBox> {
//   final WebViewController _controller = WebViewController();

//   String tradingViewHtml = '''
//     <div class="tradingview-widget-container">
//       <div class="tradingview-widget-container__widget"></div>
//       <div class="tradingview-widget-copyright"><a href="https://in.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
//       <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-mini-symbol-overview.js" async>
//       {
//       "symbol": "FX:EURUSD",
//       "width": 350,
//       "height": 220,
//       "locale": "in",
//       "dateRange": "12M",
//       "colorTheme": "light",
//       "isTransparent": false,
//       "autosize": false,
//       "largeChartUrl": ""
//     }
//       </script>
//     </div>
//     ''';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _controller.loadHtmlString(tradingViewHtml);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: BoxDecoration(
//         border: Border.all(color: ThemeColors.greyBorder),
//         borderRadius: BorderRadius.circular(Dimen.radius.r),
//         gradient: LinearGradient(
//           colors: const [ThemeColors.gradientDark, ThemeColors.gradientLight],
//           begin: widget.type == 1
//               ? Alignment.topLeft
//               : widget.type == 2
//                   ? Alignment.topRight
//                   : widget.type == 3
//                       ? Alignment.bottomLeft
//                       : Alignment.bottomRight,
//           end: widget.type == 1
//               ? Alignment.bottomRight
//               : widget.type == 2
//                   ? Alignment.bottomLeft
//                   : widget.type == 3
//                       ? Alignment.topRight
//                       : Alignment.topLeft,
//         ),
//       ),
//       padding: EdgeInsets.all(8.sp),
//       child: WebViewWidget(
        
//         controller: WebViewController(),
//         // initialUrl: Uri.dataFromString(
//         //   tradingViewHtml,
//         //   mimeType: 'text/html',
//         //   encoding: Encoding.getByName('utf-8'),
//         // ).toString(),
//         // javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }
