import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter_textfiled.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class MarketDataFilterBottomSheet extends StatefulWidget {
  const MarketDataFilterBottomSheet({
    required this.onFiltered,
    this.filterParam,
    this.showExchange = true,
    super.key,
  });
  final FilteredParams? filterParam;
  final Function(FilteredParams?) onFiltered;
  final bool showExchange;

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

    BaseBottomSheets().gradientBottomSheetDraggable(
      title: "Select Exchange",
      items: provider.data!.exchange!,
      selected: filterParams?.exchange_name,
      onSelected: (List<FiltersDataItem> selected) {
        String selectedValues = selected.map((item) => item.value).join(',');

        if (filterParams == null) {
          filterParams = FilteredParams(
            exchange_name:
                selectedValues.isEmpty ? null : selectedValues.split(","),
          );
        } else {
          filterParams?.exchange_name =
              selectedValues.isEmpty ? null : selectedValues.split(",");
        }
        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null) {
          filterParams = null;
        }

        setState(() {});
      },
    );

    // BaseBottomSheets().gradientBottomSheet(
    //   child: FilterMultiSelectListing(
    //     label: "Select Exchange",
    //     items: provider.data!.exchange!,
    //     selectedData: filterParams?.exchange_name,
    //     onSelected: (List<FiltersDataItem> selected) {
    //       String selectedValues = selected.map((item) => item.value).join(',');
    //       if (filterParams == null) {
    //         filterParams = FilteredParams(
    //           exchange_name:
    //               selectedValues.isEmpty ? null : selectedValues.split(","),
    //         );
    //       } else {
    //         filterParams?.exchange_name =
    //             selectedValues.isEmpty ? null : selectedValues.split(",");
    //       }
    //       setState(() {});
    //     },
    //   ),
    // );
  }

  void _showSectorPicker(BuildContext context) {
    FilterProvider provider = context.read<FilterProvider>();
    if (provider.data == null || provider.data?.sectors == null) {
      popUpAlert(
        message: "Sectors data not available.",
        title: "Data Empty",
        icon: Images.alertPopGIF,
      );
      return;
    }

    BaseBottomSheets().gradientBottomSheetDraggable(
      title: "Select Sector",
      items: provider.data!.sectors!,
      selected: filterParams?.sector,
      onSelected: (List<FiltersDataItem> selected) {
        String selectedValues = selected.map((item) => item.value).join(',');

        if (filterParams == null) {
          filterParams = FilteredParams(
            sector: selectedValues.isEmpty ? null : selectedValues.split(","),
          );
        } else {
          filterParams?.sector =
              selectedValues.isEmpty ? null : selectedValues.split(",");
        }

        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null) {
          filterParams = null;
        }
        setState(() {});
      },
    );
  }

  void _showIndustryPicker(BuildContext context) {
    FilterProvider provider = context.read<FilterProvider>();
    if (provider.data == null || provider.data?.industries == null) {
      popUpAlert(
        message: "Industry data not available.",
        title: "Data Empty",
        icon: Images.alertPopGIF,
      );
      return;
    }

    BaseBottomSheets().gradientBottomSheetDraggable(
      title: "Select Industry",
      items: provider.data!.industries!,
      selected: filterParams?.industry,
      onSelected: (List<FiltersDataItem> selected) {
        String selectedValues = selected.map((item) => item.value).join(',');
        if (filterParams == null) {
          filterParams = FilteredParams(
            industry: selectedValues.isEmpty ? null : selectedValues.split(","),
          );
        } else {
          filterParams?.industry =
              selectedValues.isEmpty ? null : selectedValues.split(",");
        }
        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null) {
          filterParams = null;
        }
        setState(() {});
      },
    );

    // isScrollable: false,
    // child: FilterMultiSelectListing(
    //   label: "Select Industry",
    //   items: provider.data!.industries!,
    //   selectedData: filterParams?.industry,
    //   onSelected: (List<FiltersDataItem> selected) {
    //     String selectedValues = selected.map((item) => item.value).join(',');
    //     if (filterParams == null) {
    //       filterParams = FilteredParams(
    //         industry:
    //             selectedValues.isEmpty ? null : selectedValues.split(","),
    //       );
    //     } else {
    //       filterParams?.industry =
    //           selectedValues.isEmpty ? null : selectedValues.split(",");
    //     }
    //     setState(() {});
    //   },
    // ),
    // );

    // showModalBottomSheet(
    //   isScrollControlled: true,
    //   useSafeArea: true,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(10),
    //       topRight: Radius.circular(10),
    //     ),
    //   ),
    //   // enableDrag: true,
    //   context: context,
    //   builder: (context) => BottomSheetContent(
    //     onFiltered: widget.onFiltered,
    //     filterParam: widget.filterParam,
    //   ),
    // );
  }

  // void _showMarketCapPicker(BuildContext context) {
  //   BaseBottomSheets().gradientBottomSheet(
  //     child: MarketDataFilterListing(
  //       label: "All Market Cap",
  //       items: provider.dataFilterBottomSheet.marketCap,
  //       onSelected: (index) {
  //         context.read<StockScreenerProvider>().onChangeMarketcap(
  //               provider.dataFilterBottomSheet.marketCap[index].key.toString(),
  //               provider.dataFilterBottomSheet.marketCap[index].value
  //                   .toString(),
  //             );
  //       },
  //     ),
  //   );
  // }

  // void _showPricePicker(BuildContext context) {
  //   BaseBottomSheets().gradientBottomSheet(
  //     child: MarketDataFilterListing(
  //       label: "All Price",
  //       items: provider.dataFilterBottomSheet.price,
  //       onSelected: (index) {
  //         context.read<StockScreenerProvider>().onChangePrice(
  //               provider.dataFilterBottomSheet.price[index].key.toString(),
  //               provider.dataFilterBottomSheet.price[index].value.toString(),
  //             );
  //       },
  //     ),
  //   );
  // }

  // void _showBetaPicker(BuildContext context) {
  //   BaseBottomSheets().gradientBottomSheet(
  //     child: MarketDataFilterListing(
  //       label: "All Beta",
  //       items: provider.dataFilterBottomSheet.beta,
  //       onSelected: (index) {
  //         context.read<StockScreenerProvider>().onChangeBeta(
  //               provider.dataFilterBottomSheet.beta[index].key.toString(),
  //               provider.dataFilterBottomSheet.beta[index].value.toString(),
  //             );
  //       },
  //     ),
  //   );
  // }

  // void _showDividendPicker(BuildContext context) {
  //   BaseBottomSheets().gradientBottomSheet(
  //     child: MarketDataFilterListing(
  //       label: "All Dividend",
  //       items: provider.dataFilterBottomSheet.dividend,
  //       onSelected: (index) {
  //         context.read<StockScreenerProvider>().onChangeDividend(
  //               provider.dataFilterBottomSheet.dividend[index].key.toString(),
  //               provider.dataFilterBottomSheet.dividend[index].value.toString(),
  //             );
  //       },
  //     ),
  //   );
  // }

  // void _showETFPicker(BuildContext context) {
  //   BaseBottomSheets().gradientBottomSheet(
  //     child: MarketDataFilterListing(
  //       label: "All ETF",
  //       items: provider.dataFilterBottomSheet.isEtf,
  //       onSelected: (index) {
  //         context.read<StockScreenerProvider>().onChangeIsEtf(
  //               provider.dataFilterBottomSheet.isEtf[index].key.toString(),
  //               provider.dataFilterBottomSheet.isEtf[index].value.toString(),
  //             );
  //       },
  //     ),
  //   );
  // }

  // void _showFundPicker(BuildContext context) {
  //   BaseBottomSheets().gradientBottomSheet(
  //     child: MarketDataFilterListing(
  //       label: "All Fund",
  //       items: provider.dataFilterBottomSheet.isFund,
  //       onSelected: (index) {
  //         context.read<StockScreenerProvider>().onChangeIsFund(
  //               provider.dataFilterBottomSheet.isFund[index].key.toString(),
  //               provider.dataFilterBottomSheet.isFund[index].value.toString(),
  //             );
  //       },
  //     ),
  //   );
  // }

  // void _showActivelyTradingPicker(BuildContext context) {
  //   BaseBottomSheets().gradientBottomSheet(
  //     child: MarketDataFilterListing(
  //       label: "All ActivelyTrading",
  //       items: provider.dataFilterBottomSheet.isActivelyTrading,
  //       onSelected: (index) {
  //         context.read<StockScreenerProvider>().onChangeIsActivelyTrading(
  //               provider.dataFilterBottomSheet.isActivelyTrading[index].key
  //                   .toString(),
  //               provider.dataFilterBottomSheet.isActivelyTrading[index].value
  //                   .toString(),
  //             );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isPhone ? 0 : 0),
      // ScreenUtil().screenWidth * .15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpacerVertical(height: 10),
          IntrinsicHeight(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showExchange)
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
                if (widget.showExchange) const SpacerHorizontal(width: 12),
                Expanded(
                  child: MarketDataTextFiledClickable(
                    hintText: filterParams?.sector != null
                        ? filterParams?.sector?.join(", ") ?? ""
                        : "All Sectors",
                    label: "Sector",
                    onTap: () => _showSectorPicker(context),
                    // controller: provider.sectorController,
                    controller: TextEditingController(),
                  ),
                ),
              ],
            ),
          ),
          const SpacerVertical(height: 12),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: MarketDataTextFiledClickable(
                    hintText: filterParams?.industry != null
                        ? filterParams?.industry?.join(", ") ?? ""
                        : "All Industry",
                    label: "Industry",
                    onTap: () => _showIndustryPicker(context),
                    // controller: provider.industryController,
                    controller: TextEditingController(),
                  ),
                ),
                // const SpacerHorizontal(width: 10),
                // Expanded(
                //   child: MarketDataTextFiledClickable(
                //       hintText: "All Market Cap",
                //       label: "Market Cap",
                //       onTap: () => _showMarketCapPicker(context),
                //       controller: provider.marketCapController),
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
          Row(
            children: [
              Expanded(
                child: ThemeButton(
                  color: filterParams != null
                      ? ThemeColors.accent
                      : ThemeColors.greyText,
                  onPressed: () {
                    if (filterParams == null) return;
                    Navigator.pop(context);
                    filterParams = null;
                    widget.onFiltered(filterParams);
                  },
                  text: "RESET FILTER",
                  textColor: Colors.white,
                ),
              ),
              const SpacerHorizontal(width: 12),
              Expanded(
                child: ThemeButton(
                  color: ThemeColors.accent,
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onFiltered(filterParams);
                  },
                  text: "APPLY FILTER",
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
          SpacerVertical(height: ScreenUtil().bottomBarHeight),
        ],
      ),
    );
  }
}
