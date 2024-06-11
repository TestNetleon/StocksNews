import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/filter_multi_select_list.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter_textfiled.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class MarketDataFilterBottomSheet extends StatefulWidget {
  const MarketDataFilterBottomSheet({
    required this.onFiltered,
    this.filterParam,
    super.key,
  });
  final FilteredParams? filterParam;
  final Function(FilteredParams?) onFiltered;

  @override
  State<MarketDataFilterBottomSheet> createState() =>
      _MarketDataFilterBottomSheetState();
}

class _MarketDataFilterBottomSheetState
    extends State<MarketDataFilterBottomSheet> {
  FilteredParams? filterParams;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filterParams = widget.filterParam;
      });
    });
  }

  @override
  void dispose() {
    filterParams = null;
    super.dispose();
  }

  // final dynamic provider;
  void _showExchangePicker(BuildContext context) {
    FilterProvider provider = context.read<FilterProvider>();
    if (provider.data == null || provider.data?.exchange == null) {
      popUpAlert(
        message: "Exchange data not available.",
        title: "Data Empty",
        icon: Images.alertPopGIF,
      );
      return;
    }

    BaseBottomSheets().gradientBottomSheet(
      child: FilterMultiSelectListing(
        label: "Select Exchange",
        items: provider.data!.exchange!,
        selectedData: filterParams?.exchange_name,
        onSelected: (List<FiltersDataItem> selected) {
          String selectedValues = selected.map((item) => item.value).join(',');
          if (filterParams == null) {
            filterParams = FilteredParams(
              exchange_name: selectedValues.split(","),
            );
          } else {
            filterParams?.exchange_name = selectedValues.split(",");
          }
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isPhone ? 0 : 0),
      // ScreenUtil().screenWidth * .15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: MarketDataTextFiledClickable(
                    hintText: filterParams?.exchange_name != null
                        ? filterParams?.exchange_name?.join(", ") ?? ""
                        : "All Exchange",
                    label: "Exchange Type",
                    onTap: () => _showExchangePicker(context),
                    // controller: provider.exchangeController,
                    controller: TextEditingController(),
                  ),
                ),
                // const SpacerHorizontal(width: 10),
                // Expanded(
                //   child: MarketDataTextFiledClickable(
                //       hintText: "All Sector",
                //       label: "Sector",
                //       onTap: () => _showSectorPicker(context),
                //       controller: provider.sectorController),
                // ),
              ],
            ),
          ),
          // const SpacerVertical(height: 20),
          // IntrinsicHeight(
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Expanded(
          //         child: MarketDataTextFiledClickable(
          //             hintText: "All Industry",
          //             label: "Industry",
          //             onTap: () => _showIndustryPicker(context),
          //             controller: provider.industryController),
          //       ),
          //       const SpacerHorizontal(width: 10),
          //       Expanded(
          //         child: MarketDataTextFiledClickable(
          //             hintText: "All Market Cap",
          //             label: "Market Cap",
          //             onTap: () => _showMarketCapPicker(context),
          //             controller: provider.marketCapController),
          //       ),
          //     ],
          //   ),
          // ),
          // const SpacerVertical(height: 20),
          // IntrinsicHeight(
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Expanded(
          //         child: MarketDataTextFiledClickable(
          //             hintText: "All Price",
          //             label: "Price",
          //             onTap: () => _showPricePicker(context),
          //             controller: provider.priceController),
          //       ),
          //       const SpacerHorizontal(width: 10),
          //       Expanded(
          //         child: MarketDataTextFiledClickable(
          //             hintText: "All Beta",
          //             label: "Beta",
          //             onTap: () => _showBetaPicker(context),
          //             controller: provider.betaController),
          //       ),
          //     ],
          //   ),
          // ),
          // const SpacerVertical(height: 20),
          // IntrinsicHeight(
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Expanded(
          //         child: MarketDataTextFiledClickable(
          //             hintText: "All Dividend",
          //             label: "Dividend",
          //             onTap: () => _showDividendPicker(context),
          //             controller: provider.dividendController),
          //       ),
          //       const SpacerHorizontal(width: 10),
          //       Expanded(
          //         child: MarketDataTextFiledClickable(
          //             hintText: "All",
          //             label: "Is ETF",
          //             onTap: () => _showETFPicker(context),
          //             controller: provider.isEtfController),
          //       ),
          //     ],
          //   ),
          // ),
          // const SpacerVertical(height: 20),
          // IntrinsicHeight(
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Expanded(
          //         child: MarketDataTextFiledClickable(
          //             hintText: "All",
          //             label: "Is Fund",
          //             onTap: () => _showFundPicker(context),
          //             controller: provider.isFundController),
          //       ),
          //       const SpacerHorizontal(width: 10),
          //       Expanded(
          //         child: MarketDataTextFiledClickable(
          //             hintText: "All",
          //             label: "Is ActivelyTrading",
          //             onTap: () => _showActivelyTradingPicker(context),
          //             controller: provider.isActivelyTradingController),
          //       ),
          //     ],
          //   ),
          // ),
          const SpacerVertical(height: 20),
          ThemeButton(
            color: ThemeColors.accent,
            onPressed: () {
              Navigator.pop(context);
              // context.read<StockScreenerProvider>().getStockScreenerStocks();
              widget.onFiltered(filterParams);
            },
            text: "APPLY FILTER",
            textColor: Colors.white,
          ),
          SpacerVertical(height: ScreenUtil().bottomBarHeight),
        ],
      ),
    );
  }
}
