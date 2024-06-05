// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:plaid_flutter/plaid_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/plaid.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// class PlaidIntegrationUI extends StatefulWidget {
//   const PlaidIntegrationUI({super.key});

//   @override
//   State<PlaidIntegrationUI> createState() => _PlaidIntegrationUIState();
// }

// class _PlaidIntegrationUIState extends State<PlaidIntegrationUI> {
//   StreamSubscription<LinkEvent>? _streamEvent;
//   StreamSubscription<LinkExit>? _streamExit;
//   StreamSubscription<LinkSuccess>? _streamSuccess;

//   @override
//   void initState() {
//     super.initState();

//     _streamEvent = PlaidLink.onEvent.listen(_onEvent);
//     _streamExit = PlaidLink.onExit.listen(_onExit);
//     _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
//   }

//   void _onEvent(LinkEvent event) {
//     final name = event.name;
//     final metadata = event.metadata.description();
//     Utils().showLog("onEvent: $name, metadata: $metadata");
//   }

//   void _onSuccess(LinkSuccess event) {
//     final token = event.publicToken;
//     final metadata = event.metadata.description();
//     Utils().showLog("onSuccess: $token, metadata: $metadata");
//     _exchangeToken(publicToken: token);
//   }

//   void _onExit(LinkExit event) {
//     final metadata = event.metadata.description();
//     final error = event.error?.description();
//     Utils().showLog("onExit metadata: $metadata, error: $error");
//   }

//   @override
//   void dispose() {
//     _streamEvent?.cancel();
//     _streamExit?.cancel();
//     _streamSuccess?.cancel();
//     super.dispose();
//   }

//   void _exchangeToken({String? publicToken}) async {
//     final Map<String, dynamic> request = {
//       "client_id": "665336b8bff5c6001ce3aafc",
//       "secret": "7181521c1dd4c3353ea995024697ef",
//       "public_token": publicToken ?? "",
//     };

//     const String url = "https://sandbox.plaid.com/item/public_token/exchange";

//     final Map<String, String> headers = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };

//     try {
//       final http.Response response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(request),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         Utils().showLog("ACCESS TOKEN ${responseData['access_token']}");
//         Utils().showLog("Exchange Token Data: $responseData");
//         String accessToken = '${responseData['access_token']}';

//         _getHoldings(accessToken: accessToken);
//       } else {
//         debugPrint("Failed to load data: ${response.statusCode}");
//         debugPrint("Response body: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//     }
//   }

//   void _getHoldings({String? accessToken}) async {
//     final Map<String, dynamic> request = {
//       "client_id": "665336b8bff5c6001ce3aafc",
//       "secret": "7181521c1dd4c3353ea995024697ef",
//       "access_token": accessToken ?? "",
//     };

//     const String url = "https://sandbox.plaid.com/investments/holdings/get";

//     final Map<String, String> headers = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };

//     try {
//       final http.Response response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(request),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         // Utils().showLog("Get Holdings Securities Data: $responseData");

//         navigatorKey.currentContext!
//             .read<PlaidProvider>()
//             .sendPlaidPortfolio(data: responseData["securities"]);
//       } else {
//         debugPrint("Failed to load data: ${response.statusCode}");
//         debugPrint("Response body: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//     }
//   }

//   void plaidAPi() async {
//     final Map<String, dynamic> request = {
//       "client_id": "665336b8bff5c6001ce3aafc",
//       "secret": "7181521c1dd4c3353ea995024697ef",
//       "user": {"client_user_id": "1", "phone_number": "+1 415 5550123"},
//       "client_name": "Personal Finance App",
//       "products": ["auth", "investments"],
//       "transactions": {"days_requested": 730},
//       "country_codes": ["US"],
//       "language": "en",
//       "android_package_name": "com.stocks.news"
//     };

//     const String url = "https://sandbox.plaid.com/link/token/create";

//     final Map<String, String> headers = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };

//     try {
//       final http.Response response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonEncode(request),
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         Utils().showLog("PLAID TOKEN ${responseData['link_token']}");
//         debugPrint("Success: $responseData");
//         String token = '${responseData['link_token']}';
//         LinkConfiguration configuration = LinkTokenConfiguration(
//           token: token,
//         );

//         PlaidLink.open(configuration: configuration);
//       } else {
//         debugPrint("Failed to load data: ${response.statusCode}");
//         debugPrint("Response body: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ThemeColors.white,
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   plaidAPi();
//                 },
//                 child: const Text("Click Plaid Yuhu."))
//           ],
//         ),
//       ),
//     );
//   }
// }
