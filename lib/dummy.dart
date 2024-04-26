// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class DemoWeb extends StatefulWidget {
//   const DemoWeb({super.key});

//   @override
//   State<DemoWeb> createState() => _DemoWebState();
// }

// class _DemoWebState extends State<DemoWeb> {
//   WebViewController? controller;

//   @override
//   void initState() {
//     super.initState();

//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {
//             setState(() {});
//           },
//           onPageFinished: (String url) {
//             setState(() {});
//           },
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             // if (request.url.startsWith('https://www.youtube.com/')) {
//             //   return NavigationDecision.prevent;
//             // }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://stocks.news/jtai/'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AppBarHome(
//         isHome: false,
//         showQR: false,
//         showTrailing: false,
//       ),
//       body: controller == null
//           ? const SizedBox()
//           : WebViewWidget(controller: controller!),
//     );
//   }
// }
