import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/most_purchased.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/common_stock_item.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TopPlaidIndexView extends StatefulWidget {
  const TopPlaidIndexView({super.key});

  @override
  State<TopPlaidIndexView> createState() => _TopPlaidIndexViewState();
}

class _TopPlaidIndexViewState extends State<TopPlaidIndexView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getMostPurchased();
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    return BaseContainer(
      appBar: const AppBarHome(
        canSearch: true,
        showTrailing: true,
        isPopback: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenTitle(
              title: provider.extraMostPopular?.title ?? "",
            ),
            Expanded(
              child: BaseUiContainer(
                hasData: !provider.isLoadingMostPurchased &&
                    (provider.mostPurchasedView?.isNotEmpty == true &&
                        provider.mostPurchasedView != null),
                isLoading: provider.isLoadingMostPurchased,
                error: provider.errorMostPurchased,
                isFull: true,
                showPreparingText: true,
                onRefresh: () {
                  provider.getMostPurchased();
                },
                child: CommonRefreshIndicator(
                  onRefresh: () async {
                    provider.getMostPurchased();
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: Dimen.padding),
                    itemBuilder: (context, index) {
                      MostPurchasedRes? data =
                          provider.mostPurchasedView?[index];
                      if (data == null) {
                        return const SizedBox();
                      }
                      // return TopPlaidItemView(data: data);
                      return CommonStockItem(
                        change: data.change,
                        changesPercentage: data.changesPercentage,
                        image: data.image,
                        name: data.name,
                        price: data.price,
                        symbol: data.symbol,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SpacerVertical(height: 12);
                    },
                    itemCount: provider.mostPurchasedView?.length ?? 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
