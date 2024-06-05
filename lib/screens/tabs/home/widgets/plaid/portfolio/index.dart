import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/plaid_data_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/progress_dialog.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'item.dart';

class HomePlaidAdded extends StatefulWidget {
  const HomePlaidAdded({super.key});

  @override
  State<HomePlaidAdded> createState() => _HomePlaidAddedState();
}

class _HomePlaidAddedState extends State<HomePlaidAdded> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PlaidProvider>().getTabData();
    });
  }

  @override
  Widget build(BuildContext context) {
    PlaidProvider provider = context.watch<PlaidProvider>();
    if (provider.isLoadingT) {
      return const ProgressDialog();
    }

    if (!provider.isLoadingT && provider.tabs.isEmpty) {
      return ErrorDisplayWidget(
        error: provider.error,
        onRefresh: () {
          provider.getTabData();
        },
      );
    }
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

class HomePlaidAddedContainer extends StatelessWidget {
  const HomePlaidAddedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    PlaidProvider provider = context.watch<PlaidProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimen.padding, Dimen.padding, Dimen.padding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitle(
            title: "Portfolio",
            optionalWidget: Row(
              children: [
                Text(
                  "Current Balance:",
                  style: stylePTSansBold(),
                ),
                const SpacerHorizontal(width: 5),
                Text(
                  homeProvider.homePortfolio?.bottom?.currentBalance ?? "",
                  style: stylePTSansRegular(),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomTabContainerNEW(
              onChange: (index) {
                provider.tabChange(index, provider.tabs[index]);
              },
              scrollable: true,
              physics: const NeverScrollableScrollPhysics(),
              tabs: List.generate(
                  provider.tabs.length,
                  (index) => index == 0
                      ? provider.tabs[index].toUpperCase()
                      : provider.tabs[index].capitalizeWords()),
              tabsPadding: const EdgeInsets.only(bottom: 10),
              widgets: List.generate(
                provider.tabs.length,
                (index) => CommonRefreshIndicator(
                    onRefresh: () async {
                      provider.onRefresh();
                    },
                    child: HomePlaidBase(
                      name: provider.tabs[index],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePlaidBase extends StatelessWidget {
  final String name;
  const HomePlaidBase({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    PlaidProvider provider = context.watch<PlaidProvider>();
    PlaidTabHolder? plaidTabHolder = provider.tabsData[name];

    return BaseUiContainer(
      error: plaidTabHolder?.error,
      hasData: plaidTabHolder?.data != null &&
          (plaidTabHolder?.data?.isNotEmpty ?? false),
      isLoading: plaidTabHolder?.loading ?? true,
      errorDispCommon: true,
      showPreparingText: true,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: Dimen.padding),
        // scrollDirection: Axis.horizontal,
        // physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          PlaidDataRes? data = plaidTabHolder?.data?[index];

          return Stack(
            children: [
              // Positioned(
              //   left: 6,
              //   right: 6,
              //   child: Container(
              //     decoration: const BoxDecoration(
              //         borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(5),
              //             topRight: Radius.circular(5)),
              //         color: ThemeColors.greyBorder),
              //     height: 30,
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              //     child: Row(
              //       children: [
              //         const CircleAvatar(
              //           child: Icon(
              //             Icons.trending_up_rounded,
              //             size: 10,
              //           ),
              //         ),
              //         Flexible(
              //           child: RichText(
              //             maxLines: 1,
              //             overflow: TextOverflow.ellipsis,
              //             text: TextSpan(
              //                 text: "2K ",
              //                 style: stylePTSansBold(fontSize: 12),
              //                 children: [
              //                   TextSpan(
              //                       text: "users bought this in last 30 days.",
              //                       style: stylePTSansRegular(fontSize: 12))
              //                 ]),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              Container(
                // margin: const EdgeInsets.only(top: 30),
                // width: constraints.maxWidth / 1.2,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 23, 23, 23),
                      // ThemeColors.greyBorder,
                      Color.fromARGB(255, 48, 48, 48),
                    ],
                  ),
                ),
                child: HomePlaidItem(data: data),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          // return const Divider(
          //   height: 20,
          //   color: ThemeColors.greyBorder,
          // );
          return const SpacerVertical(height: 15);
        },
        itemCount: plaidTabHolder?.data?.length ?? 0,
      ),
    );
  }
}
