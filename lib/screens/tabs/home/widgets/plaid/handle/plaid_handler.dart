import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class PlaidLinkHandler {
  PlaidLinkHandler();
  StreamSubscription<LinkEvent>? _streamEvent;
  StreamSubscription<LinkExit>? _streamExit;
  StreamSubscription<LinkSuccess>? _streamSuccess;

  void init() {
    _streamEvent = PlaidLink.onEvent.listen(_onEvent);
    _streamExit = PlaidLink.onExit.listen(_onExit);
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
  }

  void dispose() {
    _streamEvent?.cancel();
    _streamExit?.cancel();
    _streamSuccess?.cancel();
  }

  void _onEvent(LinkEvent event) {
    final name = event.name;
    final metadata = event.metadata.description();
    Utils().showLog("onEvent: $name, metadata: $metadata");
  }

  void _onSuccess(LinkSuccess event) {
    final token = event.publicToken;
    final metadata = event.metadata;
    Utils().showLog(
        "onSuccess: $token, institution name: ${metadata.institution?.name}");

    // popUpAlert(
    //   message: "Please wait while we are fetching your data...",
    //   title: "Fetching data",
    //   icon: Images.updateGIF,
    //   canPop: false,
    //   showButton: false,
    // );
    _exchangeToken(publicToken: token);
  }

  void _onExit(LinkExit event) {
    final metadata = event.metadata.description();
    final error = event.error?.description();
    Utils().showLog("onExit metadata: $metadata, error: $error");
  }

  Future _exchangeToken({String? publicToken}) async {
    HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();
    final Map<String, dynamic> request = {
      "client_id": provider.homePortfolio?.keys?.plaidClient ?? "",
      "secret": provider.homePortfolio?.keys?.plaidSecret ?? "",
      "public_token": publicToken ?? "",
    };

    String url =
        "https://${provider.homePortfolio?.keys?.plaidEnv ?? "sandbox"}.plaid.com/item/public_token/exchange";

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
        // Navigator.pop(navigatorKey.currentContext!);
        navigatorKey.currentContext!.read<PlaidProvider>().sendPlaidPortfolio(
              accessToken: accessToken,
            );
        // _getHoldings(accessToken: accessToken);
      } else {
        debugPrint("Failed to load data: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // void _getHoldings({String? accessToken}) async {
  //   HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();
  //   final Map<String, dynamic> request = {
  //     "client_id": provider.homePortfolio?.keys?.plaidClient ?? "",
  //     "secret": provider.homePortfolio?.keys?.plaidSecret ?? "",
  //     "access_token": accessToken ?? "",
  //   };

  //   String url =
  //       "https://${provider.homePortfolio?.keys?.plaidEnv ?? "sandbox"}.plaid.com/investments/holdings/get";
  //   final Map<String, String> headers = {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //   };

  //   try {
  //     final http.Response response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: jsonEncode(request),
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //       Utils().showLog("Get Holdings Securities Data: $responseData");
  //       Navigator.pop(navigatorKey.currentContext!);
  //       Utils().showLog("data");
  //       navigatorKey.currentContext!.read<PlaidProvider>().sendPlaidPortfolio(
  //             accessToken: accessToken,
  //             fromDrawer: fromDrawer,
  //             data: responseData["securities"],
  //             dataAccounts: responseData["accounts"],
  //             holdings: responseData['holdings'],
  //           );
  //     } else {
  //       debugPrint("Failed to load data: ${response.statusCode}");
  //       debugPrint("Response body: ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("Error: $e");
  //   }
  // }

  Future plaidAPi() async {
    showGlobalProgressDialog();
    HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();

    UserRes? userRes = navigatorKey.currentContext!.read<UserProvider>().user;
    final Map<String, dynamic> request = {
      "client_id": provider.homePortfolio?.keys?.plaidClient ?? "",
      "secret": provider.homePortfolio?.keys?.plaidSecret ?? "",
      "user": {"client_user_id": userRes?.token ?? "N/A", "phone_number": ""},
      "client_name": "Stocks.News",
      "products": ["investments"],
      "transactions": {"days_requested": 730},
      "country_codes": ["US"],
      "language": "en",
      "android_package_name": "com.stocks.news"
    };

    String url =
        "https://${provider.homePortfolio?.keys?.plaidEnv ?? "sandbox"}.plaid.com/link/token/create";

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
      closeGlobalProgressDialog();
    } catch (e) {
      popUpAlert(
        message: Const.errSomethingWrong,
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      debugPrint("Error: $e");
      closeGlobalProgressDialog();
    }
  }
}
