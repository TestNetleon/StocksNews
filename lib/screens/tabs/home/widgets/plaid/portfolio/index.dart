// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/plaid_data_res.dart';
// import 'package:stocks_news_new/modals/user_res.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/plaid.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/portfolio/usernot_present.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
// import 'package:stocks_news_new/widgets/custom_tab_container.dart';
// import 'package:stocks_news_new/widgets/error_display_common.dart';
// import 'package:stocks_news_new/widgets/progress_dialog.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import 'item.dart';

// class HomePlaidAdded extends StatelessWidget {
//   static const path = "HomePlaidAdded";

//   const HomePlaidAdded({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const BaseContainer(
//       appBar: AppBarHome(
//         isPopback: true,
//         canSearch: true,
//         showTrailing: true,
//       ),
//       body: HomePlaidAddedContainer(),
//     );
//   }
// }

// class HomePlaidAddedContainer extends StatefulWidget {
//   const HomePlaidAddedContainer({super.key});

//   @override
//   State<HomePlaidAddedContainer> createState() =>
//       _HomePlaidAddedContainerState();
// }

// class _HomePlaidAddedContainerState extends State<HomePlaidAddedContainer> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _getData();
//     });
//   }

//   _getData() {
//     PlaidProvider provider = context.read<PlaidProvider>();
//     HomeProvider homeProvider = context.read<HomeProvider>();

//     UserRes? user = context.read<UserProvider>().user;
//     if (user != null && homeProvider.homePortfolio?.bottom != null) {
//       log("${homeProvider.homePortfolio?.bottom}");
//       provider.getTabData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     PlaidProvider provider = context.watch<PlaidProvider>();
//     UserRes? user = context.watch<UserProvider>().user;
//     HomeProvider homeProvider = context.watch<HomeProvider>();
//     if (provider.isLoadingT || homeProvider.isLoadingPortfolio) {
//       return const ProgressDialog();
//     }
//     if (user == null || homeProvider.homePortfolio?.bottom == null) {
//       return PortfolioUserNotLoggedIn();
//     }

//     if (!provider.isLoadingT && provider.tabs.isEmpty) {
//       return ErrorDisplayWidget(
//         error: provider.errorT,
//         onRefresh: () {
//           provider.getTabData();
//         },
//       );
//     }
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//           Dimen.padding, Dimen.padding, Dimen.padding, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ScreenTitle(
//             title: "Portfolio",
//             optionalWidget: Row(
//               children: [
//                 Text(
//                   "Current Balance:",
//                   style: stylePTSansBold(),
//                 ),
//                 const SpacerHorizontal(width: 5),
//                 Text(
//                   provider.extra?.currentBalance ?? "",
//                   style: stylePTSansRegular(),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: CustomTabContainerNEW(
//               onChange: (index) {
//                 provider.tabChange(index, provider.tabs[index]);
//               },
//               scrollable: true,
//               physics: const NeverScrollableScrollPhysics(),
//               tabs: List.generate(
//                   provider.tabs.length, (index) => provider.tabs[index]),
//               tabsPadding: const EdgeInsets.only(bottom: 10),
//               widgets: List.generate(
//                 provider.tabs.length,
//                 (index) => CommonRefreshIndicator(
//                   onRefresh: () async {
//                     provider.onRefresh();
//                   },
//                   child: HomePlaidBase(
//                     name: provider.tabs[index],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomePlaidBase extends StatelessWidget {
//   final String name;
//   const HomePlaidBase({super.key, required this.name});

//   @override
//   Widget build(BuildContext context) {
//     PlaidProvider provider = context.watch<PlaidProvider>();
//     PlaidTabHolder? plaidTabHolder = provider.tabsData[name];

//     return BaseUiContainer(
//       error: plaidTabHolder?.error,
//       hasData: !(plaidTabHolder?.loading == true) &&
//           (plaidTabHolder?.data != null &&
//               (plaidTabHolder?.data?.isNotEmpty ?? false)),
//       isLoading: plaidTabHolder?.loading ?? true,
//       errorDispCommon: true,
//       showPreparingText: true,
//       onRefresh: provider.onRefresh,
//       child: ListView.separated(
//         padding: const EdgeInsets.only(bottom: Dimen.padding),
//         itemBuilder: (context, index) {
//           PlaidDataRes? data = plaidTabHolder?.data?[index];

//           return Stack(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5)),
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color.fromARGB(255, 23, 23, 23),
//                       Color.fromARGB(255, 48, 48, 48),
//                     ],
//                   ),
//                 ),
//                 child: HomePlaidItem(data: data),
//               ),
//             ],
//           );
//         },
//         separatorBuilder: (context, index) {
//           return const SpacerVertical(height: 15);
//         },
//         itemCount: plaidTabHolder?.data?.length ?? 0,
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/plaid_data_res.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../../stockDetail/index.dart';
import 'item.dart';
import 'usernot_present.dart';

class HomePlaidAdded extends StatelessWidget {
  static const path = "HomePlaidAdded";

  const HomePlaidAdded({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
        showTrailing: true,
      ),
      body: HomePlaidAddedContainer(),
    );
  }
}

class HomePlaidAddedContainer extends StatefulWidget {
  const HomePlaidAddedContainer({super.key});

  @override
  State<HomePlaidAddedContainer> createState() =>
      _HomePlaidAddedContainerState();
}

class _HomePlaidAddedContainerState extends State<HomePlaidAddedContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  _getData() {
    PlaidProvider provider = context.read<PlaidProvider>();
    HomeProvider homeProvider = context.read<HomeProvider>();

    UserRes? user = context.read<UserProvider>().user;
    if (user != null || homeProvider.homePortfolio?.bottom != null) {
      log("${homeProvider.homePortfolio?.bottom}");
      provider.getPlaidPortfolioDataNew();
    }
  }

  _sureDisconnect() {
    popUpAlert(
      message: "Are you sure you want to disconnect your broker account?",
      title: "Alert",
      icon: Images.alertPopGIF,
      cancel: true,
      okText: "Confirm",
      onTap: () {
        Navigator.pop(context);
        context.read<PlaidProvider>().disconnectPlaidAccount();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PlaidProvider provider = context.watch<PlaidProvider>();
    UserRes? user = context.watch<UserProvider>().user;
    if (provider.isLoadingG) {
      return const Loading();
    }

    if ((user == null || provider.extra?.currentBalance == null) &&
        !provider.isLoadingG) {
      return const PortfolioUserNotLoggedIn();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimen.padding, Dimen.padding, Dimen.padding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitle(
            title: "Portfolio",
            optionalWidget: Visibility(
              visible: !provider.isLoadingG,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "Current Balance:",
                        style: stylePTSansBold(),
                      ),
                      const SpacerHorizontal(width: 5),
                      Text(
                        provider.extra?.currentBalance ?? "",
                        style: stylePTSansRegular(),
                      ),
                    ],
                  ),
                  const SpacerVertical(height: 5),
                  GestureDetector(
                    onTap: _sureDisconnect,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 1, 10, 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ThemeColors.sos,
                      ),
                      child: Text(
                        "Disconnect Broker",
                        style: styleGeorgiaBold(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CommonRefreshIndicator(
              onRefresh: () async {
                provider.onRefresh();
              },
              child: const HomePlaidBase(),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePlaidBase extends StatelessWidget {
  const HomePlaidBase({super.key});

  @override
  Widget build(BuildContext context) {
    PlaidProvider provider = context.watch<PlaidProvider>();

    List<PlaidDataRes>? plaidData = provider.data;
    return BaseUiContainer(
      error: provider.errorG,
      hasData:
          !provider.isLoadingG && (plaidData != null && plaidData.isNotEmpty),
      isLoading: provider.isLoadingG,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: provider.onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: Dimen.padding),
        itemBuilder: (context, index) {
          PlaidDataRes? data = plaidData?[index];

          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (data?.validTicker == 1) {
                    Navigator.pushNamed(
                      context,
                      StockDetail.path,
                      arguments: {"slug": data?.tickerSymbol},
                    );
                  } else {
                    popUpAlert(
                        message: "No information available for this ticker.",
                        title: "Alert",
                        icon: Images.alertPopGIF);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 23, 23, 23),
                        Color.fromARGB(255, 48, 48, 48),
                      ],
                    ),
                  ),
                  child: HomePlaidItem(data: data),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const SpacerVertical(height: 15);
        },
        itemCount: plaidData?.length ?? 0,
      ),
    );
  }
}
