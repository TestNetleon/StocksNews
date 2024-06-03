import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class PlaidHomeGetStarted extends StatefulWidget {
  const PlaidHomeGetStarted({super.key});

  @override
  State<PlaidHomeGetStarted> createState() => _PlaidHomeGetStartedState();
}

class _PlaidHomeGetStartedState extends State<PlaidHomeGetStarted> {
  // String clientId = "665336b8bff5c6001ce3aafc";
  // String secret = "7181521c1dd4c3353ea995024697ef";

  String clientId = "665336b8bff5c6001ce3aafc";
  String secret = "d4e4ecf0577bd79bd09576789cbde4";

  StreamSubscription<LinkEvent>? _streamEvent;
  StreamSubscription<LinkExit>? _streamExit;
  StreamSubscription<LinkSuccess>? _streamSuccess;

  @override
  void initState() {
    super.initState();
    _streamEvent = PlaidLink.onEvent.listen(_onEvent);
    _streamExit = PlaidLink.onExit.listen(_onExit);
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
  }

  void _onEvent(LinkEvent event) {
    final name = event.name;
    final metadata = event.metadata.description();
    Utils().showLog("onEvent: $name, metadata: $metadata");
  }

  void _onSuccess(LinkSuccess event) {
    final token = event.publicToken;
    final metadata = event.metadata.description();
    Utils().showLog("onSuccess: $token, metadata: $metadata");
    popUpAlert(
        message: "Please wait while we are fetching your data...",
        title: "Alert",
        icon: Images.alertPopGIF,
        canPop: false,
        showButton: false);
    _exchangeToken(publicToken: token);
  }

  void _onExit(LinkExit event) {
    final metadata = event.metadata.description();
    final error = event.error?.description();
    Utils().showLog("onExit metadata: $metadata, error: $error");
  }

  @override
  void dispose() {
    _streamEvent?.cancel();
    _streamExit?.cancel();
    _streamSuccess?.cancel();
    super.dispose();
  }

  void _exchangeToken({String? publicToken}) async {
    final Map<String, dynamic> request = {
      "client_id": clientId,
      "secret": secret,
      "public_token": publicToken ?? "",
    };

    const String url =
        "https://production.plaid.com/item/public_token/exchange";

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        Utils().showLog("ACCESS TOKEN ${responseData['access_token']}");
        Utils().showLog("Exchange Token Data: $responseData");
        String accessToken = '${responseData['access_token']}';
        _getHoldings(accessToken: accessToken);
      } else {
        debugPrint("Failed to load data: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _getHoldings({String? accessToken}) async {
    final Map<String, dynamic> request = {
      "client_id": clientId,
      "secret": secret,
      "access_token": accessToken ?? "",
    };

    const String url = "https://production.plaid.com/investments/holdings/get";
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // Utils().showLog("Get Holdings Securities Data: $responseData");
        Navigator.pop(navigatorKey.currentContext!);
        navigatorKey.currentContext!
            .read<PlaidProvider>()
            .sendPlaidPortfolio(data: responseData["securities"]);
      } else {
        debugPrint("Failed to load data: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _plaidAPi() async {
    Utils().showLog("Client ID => $clientId");
    Utils().showLog("Secret => $secret");

    UserRes? userRes = context.read<UserProvider>().user;
    final Map<String, dynamic> request = {
      "client_id": clientId,
      "secret": secret,
      "user": {"client_user_id": userRes?.token ?? "N/A", "phone_number": ""},
      "client_name": "Personal Finance App",
      // "products": ["auth", "investments"],
      "products": ["investments"],

      "transactions": {"days_requested": 730},
      "country_codes": ["US"],
      "language": "en",
      "android_package_name": "com.stocks.news"
    };

    const String url = "https://production.plaid.com/link/token/create";

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        Utils().showLog("PLAID TOKEN ${responseData['link_token']}");
        debugPrint("Success: $responseData");
        String token = '${responseData['link_token']}';
        LinkConfiguration configuration = LinkTokenConfiguration(
          token: token,
        );

        PlaidLink.open(configuration: configuration);
      } else {
        debugPrint("Failed to load data: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: () {
        _plaidAPi();
      },
      child: Ink(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 23, 23, 23),
              Color.fromARGB(255, 48, 48, 48),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(Images.stockIcon)),
            ),
            const SpacerHorizontal(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What are smallcases?",
                    style: stylePTSansBold(),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Understand in 60 seconds. ",
                      style: stylePTSansRegular(fontSize: 13),
                      children: [
                        TextSpan(
                          text: "Get started",
                          style: stylePTSansBold(
                            decoration: TextDecoration.underline,
                            color: ThemeColors.accent,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
