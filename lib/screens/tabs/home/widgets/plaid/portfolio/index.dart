import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

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
      context.read<PlaidProvider>().getPlaidPortfolioData(showProgress: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    PlaidProvider provider = context.watch<PlaidProvider>();
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
        showTrailing: true,
      ),
      body: BaseUiContainer(
        hasData: provider.data != null && provider.data?.isNotEmpty == true,
        isLoading: provider.isLoadingG,
        showPreparingText: true,
        error: provider.errorG,
        onRefresh: () async =>
            provider.getPlaidPortfolioData(showProgress: false),
        child: CommonRefreshIndicator(
            onRefresh: () async =>
                provider.getPlaidPortfolioData(showProgress: false),
            child: const HomePlaidAddedContainer()),
      ),
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
                  "Net Worth",
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
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxWidth / 1.14,
                child: CustomTabContainerNEW(
                  scrollable: true,
                  tabs: List.generate(4, (index) => "Index => $index"),
                  tabsPadding: const EdgeInsets.only(bottom: 20),
                  widgets: List.generate(
                    4,
                    (index) => ListView.separated(
                      padding: const EdgeInsets.only(bottom: Dimen.padding),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        PlaidDataRes? data = provider.data?[index];
                        if (data == null) {
                          return const SizedBox();
                        }
                        return Stack(
                          children: [
                            Container(
                              height: 10,
                              width: constraints.maxWidth / 1.3,
                              color: ThemeColors.accent,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: constraints.maxWidth / 1.3,
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
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
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SpacerHorizontal(width: 10);
                      },
                      itemCount: provider.data?.length ?? 0,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
