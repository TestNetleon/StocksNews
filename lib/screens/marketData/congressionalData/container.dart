import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/congressional_res.dart';
import 'package:stocks_news_new/providers/congressional_provider.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/congressionalData/item.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_title.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';

class CongressionalContainer extends StatefulWidget {
  const CongressionalContainer({super.key});

  @override
  State<CongressionalContainer> createState() => _CongressionalContainerState();
}

class _CongressionalContainerState extends State<CongressionalContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // AmplitudeService.logUserInteractionEvent(
      //     type: 'Congressional Stock Trades');
      CongressionalProvider provider = context.read<CongressionalProvider>();
      if (provider.data != null) {
        return;
      }
      provider.resetFilter();
      provider.getData();
    });
  }

  void _onFilterClick() async {
    FilterProvider provider = context.read<FilterProvider>();
    CongressionalProvider congressionalProvider =
        context.read<CongressionalProvider>();

    if (provider.data == null) {
      await provider.getFilterData();
    }
    BaseBottomSheets().gradientBottomSheet(
      title: "Filter Congressional Trades",
      child: MarketDataFilterBottomSheet(
        onFiltered: _onFiltered,
        filterParam: congressionalProvider.filterParams,
      ),
    );
  }

  void _onFiltered(FilteredParams? params) {
    context.read<CongressionalProvider>().applyFilter(params);
  }

  @override
  Widget build(BuildContext context) {
    CongressionalProvider provider = context.watch<CongressionalProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
            (element) => (element.key == "congress-stock-trades" &&
                element.status == 0)) ??
        false;

    bool? havePermissions;
    if (purchased && isLocked) {
      havePermissions = userProvider.user?.membership?.permissions?.any(
              (element) => (element.key == "congress-stock-trades" &&
                  element.status == 1)) ??
          false;
      isLocked = !havePermissions;
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimen.padding,
            // Dimen.padding,
            0,
            Dimen.padding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (provider.data != null || provider.filterParams != null)
                MarketDataTitle(
                  htmlTitle: true,
                  // title: provider.extra?.title,
                  subTitleHtml: true,
                  subTitle: provider.extra?.subTitle,
                  provider: provider,
                  // onDeleteExchange: (exchange) => provider.exchangeFilter(exchange),
                  // onFilterClick: _onFilterClick,
                ),
              // if (!(provider.data == null &&
              //     provider.filterParams == null &&
              //     provider.isLoading))
              //   HtmlTitle(
              //     title: provider.title ?? "",
              //     style: stylePTSansBold(fontSize: 17),
              //     subTitle: provider.subTitle ?? "",
              //     onFilterClick: _onFilterClick,
              //     hasFilter: provider.filterParams != null,
              //   ),
              // if (!(provider.data == null &&
              //     provider.filterParams == null &&
              //     provider.isLoading))
              //   const Padding(
              //     padding: EdgeInsets.symmetric(vertical: 10),
              //     child: Divider(
              //       color: ThemeColors.accent,
              //       height: 2,
              //       thickness: 2,
              //     ),
              //   ),
              // if (provider.filterParams != null)
              //   FilterUiValues(
              //     params: provider.filterParams,
              //     onDeleteExchange: (exchange) {
              //       provider.exchangeFilter(exchange);
              //     },
              //   ),

              Expanded(
                child: BaseUiContainer(
                  onRefresh: provider.getData,
                  error: provider.error,
                  isLoading: provider.isLoading,
                  showPreparingText: true,
                  hasData: !provider.isLoading && provider.data != null ||
                      provider.data?.isNotEmpty == true,
                  child: RefreshControl(
                    onLoadMore: () async => provider.getData(loadMore: true),
                    onRefresh: () async => provider.getData(),
                    canLoadMore: provider.canLoadMore,
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimen.padding,
                        ),
                        itemBuilder: (context, index) {
                          CongressionalRes? data = provider.data?[index];
                          return CongressionalItem(
                            index: index,
                            data: data,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: ThemeColors.greyBorder,
                            height: 15,
                          );
                        },
                        itemCount: provider.data?.length ?? 0),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: MdBottomSheet(
        //     onTapFilter: _onFilterClick,
        //     onTapSorting: () => onSortingClick(
        //         selected:
        //             context.read<CongressionalProvider>().filterParams?.sorting,
        //         onTap: (sortingKey) {
        //           Navigator.pop(navigatorKey.currentContext!);
        //           context
        //               .read<CongressionalProvider>()
        //               .applySorting(sortingKey);
        //         }),
        //   ),
        // )
        if (isLocked)
          CommonLock(
            showLogin: true,
            isLocked: isLocked,
            showUpgradeBtn: havePermissions == false,
          ),
      ],
    );
  }
}
