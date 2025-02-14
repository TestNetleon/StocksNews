import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../../../models/tools.dart';
import '../../../../widgets/custom/alert_popup.dart';

class PlaidService {
  PlaidService._privateConstructor();
  static final PlaidService instance = PlaidService._privateConstructor();

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
    Utils().showLog(
        "Plaid Event: ${event.name}, Metadata: ${event.metadata.description()}");
  }

  void _onSuccess(LinkSuccess event) {
    Utils().showLog(
        "Plaid Success: Token ${event.publicToken}, Institution: ${event.metadata.institution?.name}");
    _exchangeToken(event.publicToken);
  }

  void _onExit(LinkExit event) {
    Utils().showLog(
        "Plaid Exit: Metadata: ${event.metadata.description()}, Error: ${event.error?.description()}");
  }

  // void _getHoldings({String? accessToken}) async {
  //   final context = navigatorKey.currentContext;
  //   if (context == null) return;
  //   PlaidConfigRes? config = context.read<ToolsManager>().data?.plaidConfig;
  //   final clientID = config?.clientId ?? "";
  //   final secret = config?.secret ?? "";

  //   final Map<String, dynamic> request = {
  //     "client_id": clientID,
  //     "secret": secret,
  //     "access_token": accessToken ?? "",
  //   };

  //   String url = "https://sandbox.plaid.com/investments/holdings/get";
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
  //       Utils().showLog("data");
  //     } else {}
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  Future<void> _exchangeToken(String publicToken) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    PlaidConfigRes? config = context.read<ToolsManager>().data?.plaidConfig;
    final clientID = config?.clientId ?? "";
    final secret = config?.secret ?? "";

    final url = config?.exchangeUrl;
    if (url == null || url == '') return;
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    final body = jsonEncode({
      "client_id": clientID,
      "secret": secret,
      "public_token": publicToken,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Utils().showLog("Plaid Access Token: ${data['access_token']}");
        if (data.containsKey('access_token') &&
            data['access_token'] != null &&
            data['access_token'].toString().isNotEmpty) {
          context.read<ToolsManager>().savePlaidPortfolio(data['access_token']);
          // _getHoldings(accessToken: data['access_token']);
        }
      } else {
        Utils().showLog("Plaid Token Exchange Failed: ${response.body}");
      }
    } catch (e) {
      Utils().showLog("Plaid Token Exchange Error: $e");
    }
  }

  Future<void> initiatePlaid() async {
    showGlobalProgressDialog();
    final context = navigatorKey.currentContext;
    if (context == null) return;
    PlaidConfigRes? config = context.read<ToolsManager>().data?.plaidConfig;
    UserManager manager = context.read<UserManager>();
    final clientID = config?.clientId ?? "";
    final secret = config?.secret ?? "";
    final userToken = manager.user?.token ?? "N/A";

    final url = config?.createUrl;
    if (url == null || url == '') return;

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    final body = jsonEncode({
      "client_id": clientID,
      "secret": secret,
      "user": {"client_user_id": userToken, "phone_number": "9950393329"},
      "client_name": config?.clientName ?? "Stocks.News",
      "products": config?.products ?? ["investments"],
      "country_codes": config?.countryCodes ?? ["US"],
      "language": config?.language ?? "en",
      "android_package_name": config?.androidPackageName ?? "com.stocks.news"
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Utils().showLog("Plaid Link Token: ${data['link_token']}");
        PlaidLink.create(
          configuration: LinkTokenConfiguration(
            token: data['link_token'],
          ),
        );
        PlaidLink.open();
      } else {
        Utils().showLog("Plaid Link Token Creation Failed: ${response.body}");
      }
    } catch (e) {
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      Utils().showLog("Plaid API Error: $e");
    } finally {
      closeGlobalProgressDialog();
    }
  }
}
