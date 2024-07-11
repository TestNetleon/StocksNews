import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../../modals/home_portfolio.dart';
import '../../../../../../providers/home_provider.dart';
import '../handle/plaid_handler.dart';

class PortfolioUserNotLoggedIn extends StatefulWidget {
  const PortfolioUserNotLoggedIn({super.key});

  @override
  State<PortfolioUserNotLoggedIn> createState() =>
      _PortfolioUserNotLoggedInState();
}

class _PortfolioUserNotLoggedInState extends State<PortfolioUserNotLoggedIn> {
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

  Future _onTap(UserProvider provider, HomeProvider homeProvider) async {
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

          await plaidProvider.getPlaidPortfolioDataNew();
        }
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider homeProvider = context.watch<HomeProvider>();
    UserProvider provider = context.watch<UserProvider>();
    PortfolioTop? top = homeProvider.homePortfolio?.top;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Dimen.padding, Dimen.padding, Dimen.padding, Dimen.padding),
          child: Column(
            children: [
              // Text(
              //   textAlign: TextAlign.center,
              //   "Connect your account",
              //   style: stylePTSansRegular(fontSize: 18),
              // ),
              // const SpacerVertical(height: 30),
              // ThemeButtonSmall(
              //   onPressed: onTap,
              //   text: "Log in",
              //   showArrow: false,
              //   // fullWidth: false,
              // ),

              Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      Images.portfolioCard,
                      color: ThemeColors.greyBorder.withOpacity(0.2),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 40),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: ThemeColors.greyBorder.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(8),
                      color: ThemeColors.greyBorder.withOpacity(0.3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   Images.portfolioGIF,
                        //   height: 70,
                        // ),
                        // const SpacerVertical(height: 15),
                        provider.user != null
                            ? Text(
                                provider.user?.name == null ||
                                        provider.user?.name == ''
                                    ? "Hello Investor"
                                    : "Hello ${provider.user?.name}",
                                style: stylePTSansBold(
                                  color: ThemeColors.accent,
                                ),
                              )
                            : Text(
                                "Hello Investor",
                                style: stylePTSansBold(
                                  color: ThemeColors.accent,
                                ),
                              ),
                        const SpacerVertical(height: 15),
                        Text(
                          homeProvider.homePortfolio?.top?.title
                                  ?.capitalizeWords() ??
                              "",
                          style: stylePTSansBold(fontSize: 25),
                        ),
                        const SpacerVertical(height: 15),
                        Text(
                          textAlign: TextAlign.center,
                          homeProvider.homePortfolio?.top?.subTitle ?? "",
                          style: stylePTSansRegular(
                            fontSize: 14,
                            // color: ThemeColors.greyText,
                          ),
                        ),
                        const SpacerVertical(height: 30),
                        Visibility(
                          visible: top?.p1 != null && top?.p1 != '',
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _points(homeProvider.homePortfolio?.top?.p1),
                          ),
                        ),
                        Visibility(
                          visible: top?.p2 != null && top?.p2 != '',
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child:
                                  _points(homeProvider.homePortfolio?.top?.p2)),
                        ),
                        Visibility(
                            visible: top?.p3 != null && top?.p3 != '',
                            child:
                                _points(homeProvider.homePortfolio?.top?.p3)),
                        const SpacerVertical(height: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              backgroundColor: ThemeColors.accent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: provider.user == null
                              ? () {
                                  fromDrawer = true;
                                  _onTap(provider, homeProvider);
                                }
                              : () {
                                  fromDrawer = true;

                                  _plaidLinkHandler?.plaidAPi();
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "Sync Portfolio",
                                  style: styleGeorgiaBold(fontSize: 20),
                                ),
                              ),
                              const SpacerHorizontal(width: 10),
                              Image.asset(
                                Images.syncGIF,
                                height: 27,
                                width: 27,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // const PlaidHomeGetStarted(fromDrawer: true),
            ],
          ),
        ),
      ),
    );
  }

  Row _points(text) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 3,
          backgroundColor: Colors.white,
        ),
        const SpacerHorizontal(width: 10),
        Flexible(
          child: Text(
            text,
            style: stylePTSansRegular(),
          ),
        ),
      ],
    );
  }
}
