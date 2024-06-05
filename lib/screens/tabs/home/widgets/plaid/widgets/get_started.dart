import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../../../auth/bottomSheets/login_sheet.dart';
import '../../../../../auth/bottomSheets/login_sheet_tablet.dart';

class PlaidHomeGetStarted extends StatefulWidget {
  const PlaidHomeGetStarted({super.key});

  @override
  State<PlaidHomeGetStarted> createState() => _PlaidHomeGetStartedState();
}

class _PlaidHomeGetStartedState extends State<PlaidHomeGetStarted> {
  // String clientId = "665336b8bff5c6001ce3aafc";
  // String secret = "7181521c1dd4c3353ea995024697ef";

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

  void getPlaidKeys() {}

  void _onEvent(LinkEvent event) {
    final name = event.name;
    final metadata = event.metadata.description();
    Utils().showLog("onEvent: $name, metadata: $metadata");
  }

  void _onSuccess(LinkSuccess event) {
    final token = event.publicToken;
    final metadata = event.metadata;
    Utils().showLog("onSuccess: $token, metadata: $metadata");

    popUpAlert(
      message: "Please wait while we are fetching your data...",
      title: "Alert",
      icon: Images.alertPopGIF,
      canPop: false,
      showButton: false,
    );
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
    HomeProvider provider = context.read<HomeProvider>();
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
    HomeProvider provider = context.read<HomeProvider>();
    final Map<String, dynamic> request = {
      "client_id": provider.homePortfolio?.keys?.plaidClient ?? "",
      "secret": provider.homePortfolio?.keys?.plaidSecret ?? "",
      "access_token": accessToken ?? "",
    };

    String url =
        "https://${provider.homePortfolio?.keys?.plaidEnv ?? "sandbox"}.plaid.com/investments/holdings/get";
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
        Utils().showLog("Get Holdings Securities Data: $responseData");
        Navigator.pop(navigatorKey.currentContext!);
        navigatorKey.currentContext!.read<PlaidProvider>().sendPlaidPortfolio(
              data: responseData["securities"],
              dataAccounts: responseData["accounts"],
            );
      } else {
        debugPrint("Failed to load data: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future _plaidAPi() async {
    // Utils().showLog("Client ID => $clientId");
    // Utils().showLog("Secret => $secret");
    // Utils().showLog("Create API => $createAPI");
    // Utils().showLog("Exchange API => $exchangeAPI");
    // Utils().showLog("Holdings API => $holdingsAPI");

    HomeProvider provider = context.read<HomeProvider>();

    UserRes? userRes = navigatorKey.currentContext!.read<UserProvider>().user;
    final Map<String, dynamic> request = {
      "client_id": provider.homePortfolio?.keys?.plaidClient ?? "",
      "secret": provider.homePortfolio?.keys?.plaidSecret ?? "",
      "user": {"client_user_id": userRes?.token ?? "N/A", "phone_number": ""},
      "client_name": "Personal Finance App",
      // "products": ["auth", "investments"],
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
    } catch (e) {
      popUpAlert(
        message: Const.errSomethingWrong,
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: provider.user == null
          ? () async {
              isPhone ? await loginSheet() : await loginSheetTablet();
              if (navigatorKey.currentContext!.read<UserProvider>().user ==
                  null) {
                return;
              }
              try {
                ApiResponse res = await homeProvider.getHomePortfolio();
                if (res.status && res.data['bottom'] == null) {
                  Timer(const Duration(seconds: 1), () async {
                    await _plaidAPi();
                  });
                } else {
                  log("${res.status}, ${res.data['bottom'] == null}");
                }
              } catch (e) {
                //
              }
            }
          : () {
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
                    homeProvider.homePortfolio?.top?.title ?? "",
                    style: stylePTSansBold(),
                  ),
                  HtmlWidget(
                    customStylesBuilder: (element) {
                      if (element.localName == 'span') {
                        return {'color': '#1bb449', 'text-decoration': 'none'};
                      }
                      return null;
                    },
                    homeProvider.homePortfolio?.top?.subTitle ?? "",
                    textStyle: stylePTSansRegular(
                      fontSize: 12,
                      color: ThemeColors.greyText,
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
