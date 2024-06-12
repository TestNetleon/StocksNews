import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../../../utils/utils.dart';
import '../../../../../auth/bottomSheets/login_sheet.dart';
import '../../../../../auth/bottomSheets/login_sheet_tablet.dart';
import '../handle/plaid_handler.dart';

class PlaidHomeGetStarted extends StatefulWidget {
  final bool fromDrawer;
  const PlaidHomeGetStarted({super.key, this.fromDrawer = false});

  @override
  State<PlaidHomeGetStarted> createState() => _PlaidHomeGetStartedState();
}

class _PlaidHomeGetStartedState extends State<PlaidHomeGetStarted> {
  PlaidLinkHandler? _plaidLinkHandler;

  @override
  void initState() {
    super.initState();

    _plaidLinkHandler = PlaidLinkHandler();
    _plaidLinkHandler?.init();
  }

  @override
  void dispose() {
    _plaidLinkHandler?.dispose();
    super.dispose();
  }

  // StreamSubscription<LinkEvent>? _streamEvent;
  // StreamSubscription<LinkExit>? _streamExit;
  // StreamSubscription<LinkSuccess>? _streamSuccess;

  // @override
  // void initState() {
  //   super.initState();
  //   _streamEvent = PlaidLink.onEvent.listen(_onEvent);
  //   _streamExit = PlaidLink.onExit.listen(_onExit);
  //   _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
  // }

  // void getPlaidKeys() {}

  // void _onEvent(LinkEvent event) {
  //   final name = event.name;
  //   final metadata = event.metadata.description();
  //   Utils().showLog("onEvent: $name, metadata: $metadata");
  // }

  // void _onSuccess(LinkSuccess event) {
  //   final token = event.publicToken;
  //   final metadata = event.metadata;
  //   Utils().showLog(
  //       "onSuccess: $token, institution name: ${metadata.institution?.name}");

  //   popUpAlert(
  //     message: "Please wait while we are fetching your data...",
  //     title: "Alert",
  //     icon: Images.alertPopGIF,
  //     canPop: false,
  //     showButton: false,
  //   );
  //   _exchangeToken(publicToken: token);
  // }

  // void _onExit(LinkExit event) {
  //   final metadata = event.metadata.description();
  //   final error = event.error?.description();
  //   Utils().showLog("onExit metadata: $metadata, error: $error");
  // }

  // @override
  // void dispose() {
  //   _streamEvent?.cancel();
  //   _streamExit?.cancel();
  //   _streamSuccess?.cancel();
  //   super.dispose();
  // }

  // void _exchangeToken({String? publicToken}) async {
  //   HomeProvider provider = context.read<HomeProvider>();
  //   final Map<String, dynamic> request = {
  //     "client_id": provider.homePortfolio?.keys?.plaidClient ?? "",
  //     "secret": provider.homePortfolio?.keys?.plaidSecret ?? "",
  //     "public_token": publicToken ?? "",
  //   };

  //   String url =
  //       "https://${provider.homePortfolio?.keys?.plaidEnv ?? "sandbox"}.plaid.com/item/public_token/exchange";

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
  //       Utils().showLog("ACCESS TOKEN ${responseData['access_token']}");
  //       Utils().showLog("Exchange Token Data: $responseData");
  //       String accessToken = '${responseData['access_token']}';
  //       _getHoldings(accessToken: accessToken);
  //     } else {
  //       debugPrint("Failed to load data: ${response.statusCode}");
  //       debugPrint("Response body: ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("Error: $e");
  //   }
  // }

  // void _getHoldings({String? accessToken}) async {
  //   HomeProvider provider = context.read<HomeProvider>();
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
  //       navigatorKey.currentContext!.read<PlaidProvider>().sendPlaidPortfolio(
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

  // Future _plaidAPi() async {
  //   // Utils().showLog("Client ID => $clientId");
  //   // Utils().showLog("Secret => $secret");
  //   // Utils().showLog("Create API => $createAPI");
  //   // Utils().showLog("Exchange API => $exchangeAPI");
  //   // Utils().showLog("Holdings API => $holdingsAPI");

  //   HomeProvider provider = context.read<HomeProvider>();

  //   UserRes? userRes = navigatorKey.currentContext!.read<UserProvider>().user;
  //   final Map<String, dynamic> request = {
  //     "client_id": provider.homePortfolio?.keys?.plaidClient ?? "",
  //     "secret": provider.homePortfolio?.keys?.plaidSecret ?? "",
  //     "user": {"client_user_id": userRes?.token ?? "N/A", "phone_number": ""},
  //     "client_name": "Personal Finance App",
  //     // "products": ["auth", "investments"],
  //     "products": ["investments"],
  //     "transactions": {"days_requested": 730},
  //     "country_codes": ["US"],
  //     "language": "en",
  //     "android_package_name": "com.stocks.news"
  //   };

  //   String url =
  //       "https://${provider.homePortfolio?.keys?.plaidEnv ?? "sandbox"}.plaid.com/link/token/create";

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
  //       Utils().showLog("PLAID TOKEN ${responseData['link_token']}");
  //       debugPrint("Success: $responseData");
  //       String token = '${responseData['link_token']}';
  //       LinkConfiguration configuration = LinkTokenConfiguration(
  //         token: token,
  //       );

  //       PlaidLink.open(configuration: configuration);
  //     } else {
  //       debugPrint("Failed to load data: ${response.statusCode}");
  //       debugPrint("Response body: ${response.body}");
  //     }
  //   } catch (e) {
  //     popUpAlert(
  //       message: Const.errSomethingWrong,
  //       title: "Alert",
  //       icon: Images.alertPopGIF,
  //     );
  //     debugPrint("Error: $e");
  //   }
  // }

  Future _onTap(UserProvider provider, HomeProvider homeProvider) async {
    Utils().showLog("---------FROM DRAWER ON TAP  $fromDrawer");
    PlaidProvider plaidProvider = context.read<PlaidProvider>();
    isPhone ? await loginSheet() : await loginSheetTablet();
    if (navigatorKey.currentContext!.read<UserProvider>().user == null) {
      return;
    }

    try {
      ApiResponse res = await homeProvider.getHomePortfolio();
      if (res.status && res.data['bottom'] == null) {
        Timer(const Duration(seconds: 1), () async {
          await _plaidLinkHandler?.plaidAPi();
        });
      } else {
        if (fromDrawer) {
          log("we are calling tab API");
          // await plaidProvider.getTabData();

          await plaidProvider.getPlaidPortfolioDataNew();
        }
        // log("${res.status}, ${res.data['bottom'] == null}");
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            Images.portfolioCard,
            color: ThemeColors.greyBorder.withOpacity(0.3),
            fit: BoxFit.cover,
          ),
        ),
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          onTap: provider.user == null
              ? () {
                  fromDrawer = widget.fromDrawer;
                  _onTap(provider, homeProvider);
                }
              : () {
                  fromDrawer = widget.fromDrawer;
                  Utils()
                      .showLog("---------FROM DRAWER ELSE ON TAP  $fromDrawer");

                  _plaidLinkHandler?.plaidAPi();
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
              // color: Colors.black,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        homeProvider.homePortfolio?.top?.title
                                ?.capitalizeWords() ??
                            "",
                        style: stylePTSansBold(fontSize: 18),
                      ),
                      const SpacerVertical(height: 3),
                      HtmlWidget(
                        homeProvider.homePortfolio?.top?.subTitle ?? "",
                        textStyle: stylePTSansRegular(
                          fontSize: 12,
                          color: ThemeColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(11, 4, 11, 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ThemeColors.accent,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Connect",
                        style: stylePTSansBold(fontSize: 15),
                      ),
                      const SpacerHorizontal(width: 5),
                      Image.asset(
                        Images.syncGIF,
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
