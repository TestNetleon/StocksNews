import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/marketData/widget/market_data_filter_textfiled.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class MarketDataFilterBottomSheet extends StatefulWidget {
  const MarketDataFilterBottomSheet({
    required this.onFiltered,
    this.filterParam,
    this.showExchange = true,
    this.showTimePeriod = false,
    super.key,
  });
  final FilteredParams? filterParam;
  final Function(FilteredParams?) onFiltered;
  final bool showExchange, showTimePeriod;

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
      selected: filterParams?.exchange_name?.value
          ?.split(',')
          .map((item) => item.trim())
          .toList(),
      onSelected: (List<FiltersDataItem> selected) {
        if (selected.isNotEmpty) {
          FiltersDataItem item = FiltersDataItem(
              key: selected.map((item) => item.key).join(','),
              value: selected.map((item) => item.value).join(','));

          if (filterParams == null) {
            filterParams = FilteredParams(exchange_name: item);
          } else {
            filterParams?.exchange_name = item;
          }
        } else {
          filterParams?.exchange_name = null;
        }

        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null &&
            filterParams?.market_cap == null &&
            filterParams?.analystConsensusParams == null &&
            filterParams?.marketRanks == null) {
          filterParams = null;
        }

        Utils().showLog('selected ===== ${filterParams?.exchange_name?.key}');
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
      selected: filterParams?.sector?.value
          ?.split(',')
          .map((item) => item.trim())
          .toList(),
      onSelected: (List<FiltersDataItem> selected) {
        if (selected.isNotEmpty) {
          FiltersDataItem item = FiltersDataItem(
              key: selected.map((item) => item.key).join(','),
              value: selected.map((item) => item.value).join(','));

          if (filterParams == null) {
            filterParams = FilteredParams(sector: item);
          } else {
            filterParams?.sector = item;
          }
        } else {
          filterParams?.sector = null;
        }

        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null &&
            filterParams?.market_cap == null &&
            filterParams?.analystConsensusParams == null &&
            filterParams?.marketRanks == null) {
          filterParams = null;
        }

        Utils().showLog('selected ===== ${filterParams?.sector?.key}');
        setState(() {});
      },
    );

    // BaseBottomSheets().gradientBottomSheetDraggable(
    //   title: "Select Sector",
    //   items: provider.data!.sectors!,
    //   selected: filterParams?.sector,
    //   onSelected: (List<FiltersDataItem> selected) {
    //     String selectedValues = selected.map((item) => item.value).join(',');

    //     if (filterParams == null) {
    //       filterParams = FilteredParams(
    //         sector: selectedValues.isEmpty ? null : selectedValues.split(","),
    //       );
    //     } else {
    //       filterParams?.sector =
    //           selectedValues.isEmpty ? null : selectedValues.split(",");
    //     }

    //     if (filterParams?.exchange_name == null &&
    //         filterParams?.sector == null &&
    //         filterParams?.industry == null) {
    //       filterParams = null;
    //     }
    //     setState(() {});
    //   },
    // );
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
      selected: filterParams?.industry?.value
          ?.split(',')
          .map((item) => item.trim())
          .toList(),
      onSelected: (List<FiltersDataItem> selected) {
        if (selected.isNotEmpty) {
          FiltersDataItem item = FiltersDataItem(
              key: selected.map((item) => item.key).join(','),
              value: selected.map((item) => item.value).join(','));

          if (filterParams == null) {
            filterParams = FilteredParams(industry: item);
          } else {
            filterParams?.industry = item;
          }
        } else {
          filterParams?.industry = null;
        }

        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null &&
            filterParams?.market_cap == null &&
            filterParams?.analystConsensusParams == null &&
            filterParams?.marketRanks == null) {
          filterParams = null;
        }

        Utils().showLog('selected ===== ${filterParams?.industry?.key}');
        setState(() {});
      },
    );

    // BaseBottomSheets().gradientBottomSheetDraggable(
    //   title: "Select Industry",
    //   items: provider.data!.industries!,
    //   selected: filterParams?.industry,
    //   onSelected: (List<FiltersDataItem> selected) {
    //     String selectedValues = selected.map((item) => item.value).join(',');
    //     if (filterParams == null) {
    //       filterParams = FilteredParams(
    //         industry: selectedValues.isEmpty ? null : selectedValues.split(","),
    //       );
    //     } else {
    //       filterParams?.industry =
    //           selectedValues.isEmpty ? null : selectedValues.split(",");
    //     }
    //     if (filterParams?.exchange_name == null &&
    //         filterParams?.sector == null &&
    //         filterParams?.industry == null) {
    //       filterParams = null;
    //     }
    //     setState(() {});
    //   },
    // );

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

  void _showMarketCapPicker(BuildContext context) {
    FilterProvider provider = context.read<FilterProvider>();
    if (provider.data == null || provider.data?.marketCap == null) {
      popUpAlert(
        message: "MarketCap data not available.",
        title: "Data Empty",
        icon: Images.alertPopGIF,
      );
      return;
    }
    BaseBottomSheets().gradientBottomSheetDraggableSingleSelected(
      title: "Select Market Cap",
      items: provider.data!.marketCap!,
      selected: filterParams?.market_cap?.value,
      onSelected: (selected) {
        Utils().showLog('selected ===== ${selected?.value}, ${selected?.key} ');

        if (filterParams == null) {
          filterParams = FilteredParams(market_cap: selected);
        } else {
          filterParams?.market_cap = selected;
        }

        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null &&
            filterParams?.market_cap == null &&
            filterParams?.analystConsensusParams == null &&
            filterParams?.marketRanks == null) {
          filterParams = null;
        }

        Utils().showLog('selected ===== ${filterParams?.market_cap?.key}');
        setState(() {});
      },
    );

    // BaseBottomSheets().gradientBottomSheetDraggableSingleSelected(
    //   title: "Select Market Cap",
    //   items: provider.data!.marketCap!,
    //   selected: filterParams?.market_cap?.value,
    //   onSelected: (selected) {
    //     Utils().showLog('selected ===== ${selected?.value}');
    //     FiltersDataItem? selectedValues = selected;
    //     if (filterParams == null) {
    //       // filterParams?.market_cap = selectedValues;
    //       // filterParams?.market_cap = FiltersDataItem(key: key, value: value)(
    //       //   market_cap: selectedValues,
    //       // ) as FiltersDataItem?;
    //       filterParams?.market_cap = FiltersDataItem(
    //           key: selectedValues?.key, value: selectedValues?.value);
    //     } else {
    //       filterParams?.market_cap = FiltersDataItem(
    //           key: selectedValues?.key, value: selectedValues?.value);
    //     }
    //     if (filterParams?.exchange_name == null &&
    //         filterParams?.sector == null &&
    //         filterParams?.industry == null &&
    //         filterParams?.market_cap == null) {
    //       filterParams = null;
    //     }
    //     Utils().showLog('selected ===== ${filterParams?.market_cap?.key}');

    //     setState(() {});
    //   },
    // );
    // BaseBottomSheets().gradientBottomSheet(
    //   child: MarketDataFilterListing(
    //     label: "All Market Cap",
    //     items: provider.dataFilterBottomSheet.marketCap,
    //     onSelected: (index) {
    //       context.read<StockScreenerProvider>().onChangeMarketcap(
    //             provider.dataFilterBottomSheet.marketCap[index].key.toString(),
    //             provider.dataFilterBottomSheet.marketCap[index].value
    //                 .toString(),
    //           );
    //     },
    //   ),
    // );
  }

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
  void _showTimePeriodPiker(BuildContext context) {
    FilterProvider provider = context.read<FilterProvider>();
    if (provider.data == null || provider.data?.timePeriod == null) {
      popUpAlert(
        message: "Time Period data not available.",
        title: "Data Empty",
        icon: Images.alertPopGIF,
      );
      return;
    }
    BaseBottomSheets().gradientBottomSheetDraggableSingleSelected(
      title: "Select Time Period",
      items: provider.data!.timePeriod!,
      selected: filterParams?.timePeriod?.value,
      onSelected: (selected) {
        Utils().showLog('selected ===== ${selected?.value}, ${selected?.key} ');

        if (filterParams == null) {
          filterParams = FilteredParams(timePeriod: selected);
        } else {
          filterParams?.timePeriod = selected;
        }

        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null &&
            filterParams?.market_cap == null &&
            filterParams?.analystConsensusParams == null &&
            filterParams?.marketRanks == null &&
            filterParams?.timePeriod == null) {
          filterParams = null;
        }

        Utils().showLog('selected ===== ${filterParams?.timePeriod?.key}');
        setState(() {});
      },
    );
  }

  void _showAnalystConsensusPicker(BuildContext context) {
    FilterProvider provider = context.read<FilterProvider>();
    if (provider.data == null || provider.data?.analystConsensus == null) {
      popUpAlert(
        message: "Analyst Consensus not available.",
        title: "Data Empty",
        icon: Images.alertPopGIF,
      );
      return;
    }
    BaseBottomSheets().gradientBottomSheetDraggable(
      title: "Select Analyst Consensus",
      items: provider.data!.analystConsensus!,
      selected: filterParams?.analystConsensusParams?.value
          ?.split(',')
          .map((item) => item.trim())
          .toList(),
      onSelected: (List<FiltersDataItem> selected) {
        if (selected.isNotEmpty) {
          FiltersDataItem item = FiltersDataItem(
              key: selected.map((item) => item.key).join(','),
              value: selected.map((item) => item.value).join(','));

          if (filterParams == null) {
            filterParams = FilteredParams(analystConsensusParams: item);
          } else {
            filterParams?.analystConsensusParams = item;
          }
        } else {
          filterParams?.analystConsensusParams = null;
        }

        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null &&
            filterParams?.market_cap == null &&
            filterParams?.analystConsensusParams == null) {
          filterParams = null;
        }

        Utils().showLog(
            'selected ===== ${filterParams?.analystConsensusParams?.key}');
        setState(() {});
      },
    );
  }

  void _showMarketRankPicker(BuildContext context) {
    FilterProvider provider = context.read<FilterProvider>();
    if (provider.data == null || provider.data?.marketRank == null) {
      popUpAlert(
        message: "Market Rank not available.",
        title: "Data Empty",
        icon: Images.alertPopGIF,
      );
      return;
    }
    BaseBottomSheets().gradientBottomSheetDraggable(
      title: "Select Market Rank",
      items: provider.data!.marketRank!,
      selected: filterParams?.marketRanks?.value
          ?.split(',')
          .map((item) => item.trim())
          .toList(),
      onSelected: (List<FiltersDataItem> selected) {
        if (selected.isNotEmpty) {
          FiltersDataItem item = FiltersDataItem(
              key: selected.map((item) => item.key).join(','),
              value: selected.map((item) => item.value).join(','));

          if (filterParams == null) {
            filterParams = FilteredParams(marketRanks: item);
          } else {
            filterParams?.marketRanks = item;
          }
        } else {
          filterParams?.marketRanks = null;
        }

        if (filterParams?.exchange_name == null &&
            filterParams?.sector == null &&
            filterParams?.industry == null &&
            filterParams?.market_cap == null &&
            filterParams?.analystConsensusParams == null &&
            filterParams?.marketRanks == null) {
          filterParams = null;
        }

        Utils().showLog('selected ===== ${filterParams?.marketRanks?.key}');
        setState(() {});
      },
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
                          ? filterParams?.exchange_name?.value ?? ""
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
                        ? filterParams?.sector?.value ?? ""
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
                        ? filterParams?.industry?.value ?? ""
                        : "All Industry",
                    label: "Industry",
                    onTap: () => _showIndustryPicker(context),
                    // controller: provider.industryController,
                    controller: TextEditingController(),
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  child: MarketDataTextFiledClickable(
                    hintText: filterParams?.market_cap?.value != null
                        ? filterParams?.market_cap?.value ?? ""
                        : "All Market Cap",
                    label: "Market Cap",
                    onTap: () => _showMarketCapPicker(context),
                    controller: TextEditingController(),

                    // controller: provider.marketCapController,
                  ),
                ),
              ],
            ),
          ),
          // new filter
          const SpacerVertical(height: 12),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: MarketDataTextFiledClickable(
                    hintText: filterParams?.marketRanks != null
                        ? filterParams?.marketRanks?.value ?? ""
                        : "All Market Ranks",
                    label: "Market Ranks",
                    onTap: () => _showMarketRankPicker(context),
                    controller: TextEditingController(),
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  child: MarketDataTextFiledClickable(
                    hintText:
                        filterParams?.analystConsensusParams?.value != null
                            ? filterParams?.analystConsensusParams?.value ?? ""
                            : "All Analyst Consensus",
                    label: "Analyst Consensus",
                    onTap: () => _showAnalystConsensusPicker(context),
                    controller: TextEditingController(),
                  ),
                ),
              ],
            ),
          ),
          // new filter

          Visibility(
              visible: widget.showTimePeriod,
              child: const SpacerVertical(height: 12)),
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: widget.showTimePeriod,
                  child: Expanded(
                    child: MarketDataTextFiledClickable(
                      hintText: filterParams?.timePeriod?.value != null
                          ? filterParams?.timePeriod?.value ?? ""
                          : navigatorKey.currentContext!
                                  .watch<FilterProvider>()
                                  .data
                                  ?.timePeriod?[0]
                                  .value ??
                              "Time Period",
                      label: "Time Period",
                      onTap: () => _showTimePeriodPiker(context),
                      controller: TextEditingController(),
                    ),
                  ),
                ),
                // const SpacerHorizontal(width: 10),
                // Expanded(
                //   child: MarketDataTextFiledClickable(
                //       hintText: "All Beta",
                //       label: "Beta",
                //       onTap: () => _showBetaPicker(context),
                //       controller: provider.betaController),
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
