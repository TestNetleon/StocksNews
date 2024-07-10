import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/auth/verifyIdentity/verify_identity.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../../../utils/utils.dart';
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

  void _handleClick() async {
    UserProvider provider = context.read<UserProvider>();
    if (provider.user == null) {
      fromDrawer = widget.fromDrawer;
      _onTap();
    } else if (provider.user != null &&
        (provider.user?.phone == null || provider.user?.phone == "")) {
      fromDrawer = widget.fromDrawer;
      await verifyIdentitySheet();
      if (provider.user != null &&
          (provider.user?.phone == null || provider.user?.phone == "")) {
        return;
      }
      Timer(const Duration(seconds: 1), () async {
        await _plaidLinkHandler?.plaidAPi();
      });
    } else {
      fromDrawer = widget.fromDrawer;
      _plaidLinkHandler?.plaidAPi();
    }
  }

  Future _onTap() async {
    UserProvider provider = context.read<UserProvider>();
    HomeProvider homeProvider = context.read<HomeProvider>();
    Utils().showLog("---------FROM DRAWER ON TAP  $fromDrawer");
    PlaidProvider plaidProvider = context.read<PlaidProvider>();

    if (provider.user == null) {
      isPhone ? await loginSheet() : await loginSheetTablet();
    }
    if (provider.user == null) {
      return;
    }
    if (provider.user != null &&
        (provider.user?.phone == null || provider.user?.phone == "")) {
      await verifyIdentitySheet();
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

  // Future _onTap(UserProvider provider, HomeProvider homeProvider) async {
  //   Utils().showLog("---------FROM DRAWER ON TAP  $fromDrawer");
  //   PlaidProvider plaidProvider = context.read<PlaidProvider>();
  //   isPhone ? await loginSheet() : await loginSheetTablet();
  //   if (navigatorKey.currentContext!.read<UserProvider>().user == null) {
  //     return;
  //   }

  //   try {
  //     ApiResponse res = await homeProvider.getHomePortfolio();
  //     if (res.status && res.data['bottom'] == null) {
  //       Timer(const Duration(seconds: 1), () async {
  //         await _plaidLinkHandler?.plaidAPi();
  //       });
  //     } else {
  //       if (fromDrawer) {
  //         log("we are calling tab API");
  //         // await plaidProvider.getTabData();

  //         await plaidProvider.getPlaidPortfolioDataNew();
  //       }
  //       // log("${res.status}, ${res.data['bottom'] == null}");
  //     }
  //   } catch (e) {
  //     //
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // UserProvider provider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    return Column(
      children: [
        Stack(
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
              onTap: _handleClick,
              // onTap: provider.user == null
              //     ? () {
              //         fromDrawer = widget.fromDrawer;
              //         _onTap();
              //       }
              //     : () {
              //         fromDrawer = widget.fromDrawer;
              //         _plaidLinkHandler?.plaidAPi();
              //       },
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                    const SpacerHorizontal(width: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ThemeColors.accent,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Sync",
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
        ),
        Visibility(
          visible: homeProvider.homePortfolio?.top?.portfolioEarnPoint != null,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(
              // color: ThemeColors.accent,
              gradient: LinearGradient(
                colors: [
                  ThemeColors.bottomsheetGradient,
                  ThemeColors.accent,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.starAffiliate,
                  height: 20,
                  width: 20,
                ),
                const SpacerHorizontal(width: 5),
                Flexible(
                  child: Text(
                    homeProvider.homePortfolio?.top?.portfolioEarnPoint ?? "",
                    style: stylePTSansBold(),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
