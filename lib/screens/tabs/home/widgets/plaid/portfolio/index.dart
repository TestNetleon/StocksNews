import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/plaid_data_res.dart';
import 'package:stocks_news_new/providers/plaid.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimen.padding, Dimen.padding, Dimen.padding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitle(
            title: "Investments",
            optionalWidget: Row(
              children: [
                Text(
                  "Net Worth:",
                  style: stylePTSansBold(),
                ),
                const SpacerHorizontal(width: 5),
                Text(
                  "\$0.00",
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
                  provider.tabs.length, (index) => provider.tabs[index]),
              tabsPadding: const EdgeInsets.only(bottom: 10),
              widgets: List.generate(
                provider.tabs.length,
                (index) => CommonRefreshIndicator(
                  onRefresh: () async {
                    provider.onRefresh();
                  },
                  child: BaseUiContainer(
                    error: provider
                        .tabsData[provider.tabs[provider.selectedTab]]?.error,
                    hasData: provider
                                .tabsData[provider.tabs[provider.selectedTab]]
                                ?.data !=
                            null &&
                        (provider.tabsData[provider.tabs[provider.selectedTab]]
                                ?.data?.isNotEmpty ??
                            false),
                    isLoading: provider
                            .tabsData[provider.tabs[provider.selectedTab]]
                            ?.loading ??
                        true,
                    errorDispCommon: true,
                    showPreparingText: true,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: Dimen.padding),
                      // scrollDirection: Axis.horizontal,
                      // physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        PlaidDataRes? data = provider
                            .tabsData[provider.tabs[provider.selectedTab]]
                            ?.data?[index];
                        if (data == null) {
                          return const SizedBox();
                        }
                        return Stack(
                          children: [
                            Positioned(
                              left: 6,
                              right: 6,
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    color: ThemeColors.greyBorder),
                                height: 30,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 4),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      child: Icon(
                                        Icons.trending_up_rounded,
                                        size: 10,
                                      ),
                                    ),
                                    Flexible(
                                      child: RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            text: "2K ",
                                            style:
                                                stylePTSansBold(fontSize: 12),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "users bought this in last 30 days.",
                                                  style: stylePTSansRegular(
                                                      fontSize: 12))
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              // width: constraints.maxWidth / 1.2,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                        return const SpacerVertical(height: 20);
                      },
                      itemCount: provider
                              .tabsData[provider.tabs[provider.selectedTab]]
                              ?.data
                              ?.length ??
                          0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
