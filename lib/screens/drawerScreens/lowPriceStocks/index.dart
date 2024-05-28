import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/low_price_stocks_res.dart';
import 'package:stocks_news_new/providers/low_prices_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/lowPriceStocks/item_sale_on_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/html_title.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

import '../../../modals/low_price_stocks_tab.dart';
import 'item.dart';

class LowPriceStocksIndex extends StatefulWidget {
  static const path = "LowPriceStocksIndex";
  const LowPriceStocksIndex({super.key});

  @override
  State<LowPriceStocksIndex> createState() => _LowPriceStocksIndexState();
}

class _LowPriceStocksIndexState extends State<LowPriceStocksIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LowPriceStocksProvider>().selectedIndex = 0;
      context.read<LowPriceStocksProvider>().getTabsData(showProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    LowPriceStocksProvider provider = context.watch<LowPriceStocksProvider>();
    return BaseContainer(
      appBar: const AppBarHome(
        canSearch: true,
        isPopback: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: _getWidget(provider),
      ),
    );
  }
}

Widget _getWidget(LowPriceStocksProvider provider) {
  if (provider.tabLoading) {
    return const SizedBox();
  }
  if (!provider.tabLoading && provider.tabs == null) {
    return ErrorDisplayWidget(
      error: provider.error,
      onRefresh: () => provider.getTabsData(showProgress: true),
    );
  }
  return const LowPriceStocksData();
}

class LowPriceStocksData extends StatelessWidget {
  const LowPriceStocksData({super.key});

  @override
  Widget build(BuildContext context) {
    LowPriceStocksProvider provider = context.watch<LowPriceStocksProvider>();
    List<LowPriceStocksTabRes>? tabs = provider.tabs;

    return CustomTabContainerNEW(
      onChange: (index) {
        provider.tabChange(index);
      },
      scrollable: true,
      tabsPadding: EdgeInsets.only(bottom: 10.sp),
      tabs: List.generate(tabs?.length ?? 0, (index) => "${tabs?[index].name}"),
      widgets: List.generate(
        tabs?.length ?? 0,
        (index) => _getWidgets(provider),
      ),
    );
  }

  Widget _getWidgets(LowPriceStocksProvider provider) {
    return BaseUiContainer(
      error: provider.error,
      hasData: !provider.isLoading && provider.data != null,
      isLoading: provider.isLoading,
      showPreparingText: true,
      onRefresh: () {
        provider.getLowPriceData();
      },
      child: RefreshControl(
        onRefresh: () async => provider.getLowPriceData(),
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => provider.getLowPriceData(loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          itemBuilder: (context, index) {
            LowPriceStocksRes? data = provider.data?[index];
            if (data == null) {
              return const SizedBox();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? HtmlTitle(
                        subTitle: provider.subTitle,
                      )
                    : const SizedBox(),
                provider.typeIndex == 1
                    ? SaleOnStocksItem(
                        data: data,
                      )
                    : LowPriceStocksItem(data: data),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: ThemeColors.greyBorder,
              height: 16,
            );
          },
          itemCount: provider.data?.length ?? 0,
        ),
      ),
    );
  }
}
