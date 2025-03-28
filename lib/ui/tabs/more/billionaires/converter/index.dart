import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/crypto_detail_res.dart';
import 'package:stocks_news_new/models/crypto_models/crypto_fiat_res.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/crypto_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/search_tiles.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';


class ConverterIndex extends StatefulWidget {
  const ConverterIndex({super.key});

  @override
  State<ConverterIndex> createState() => _ConverterIndexState();
}

class _ConverterIndexState extends State<ConverterIndex> {
  Timer? _timer;
  final TextEditingController symbolController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    ExchangeRates? exchangeRates = manager.cryptoFiatRes?.exchangeRates;
    CryptoData? cryptoRates = manager.cryptoFiatRes?.cryptoData;

    if (manager.isLoadingFiat) {
      return Loading();
    }
    return BaseLoaderContainer(
      hasData: manager.cryptoFiatRes != null && !manager.isLoadingFiat,
      isLoading: manager.isLoadingFiat,
      error: manager.error,
      showPreparingText: true,
      child: BaseScroll(
          onRefresh: manager.getCryptoFiat,
          margin: EdgeInsets.zero,
          children: [
            Visibility(
              visible:
              cryptoRates?.title != null && cryptoRates?.title != '',
              child: BaseHeading(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                title: cryptoRates?.title ?? "",
                titleStyle: styleBaseBold(),
              ),
            ),
            SpacerVertical(height: 10),
            manager.isSwapped ? currencySection() : symbolSection(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon:
                  Icon(Icons.swap_horizontal_circle_rounded, size: 24),
                  onPressed: () {
                    manager.swapUI();
                  },
                ),
                Text(
                  "1 ${manager.selectedSymbol?.symbol ?? ""} = ${manager.selectedItem?.symbol ?? ""} ${((manager.selectedSymbol?.price ?? 0) * (manager.selectedItem?.price ?? 0))} ${manager.selectedItem?.currency ?? ""}",
                  style:
                  styleBaseBold(fontSize: 14, fontFamily: "Roboto"),
                )
              ],
            ),
            manager.isSwapped ? symbolSection() : currencySection(),
            SpacerVertical(height: Pad.pad20),
            BaseButton(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              onPressed: () {
                Navigator.pushNamed(context, CryptoIndex.path,
                    arguments: {
                      'symbol': manager.selectedSymbol?.symbol ?? "",
                      'currency': manager.selectedItem?.currency??""
                    }).whenComplete(()=>manager.getCryptoFiat());
              },
              text: "Converter",
              textSize: 16,
              fontBold: true,
              fullWidth: false,
            ),
            SpacerVertical(height: Pad.pad20),
            Visibility(
                visible: exchangeRates?.title != null &&
                    exchangeRates?.title != '',
                child: BaseHeading(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: exchangeRates?.title ?? "",
                  titleStyle: styleBaseBold(),
                )),
            SpacerVertical(height: Pad.pad10),
            Visibility(
              visible: exchangeRates?.data != null &&
                  exchangeRates?.data?.isNotEmpty == true,
              child: Row(
                children: [
                  DataTable(
                    horizontalMargin: 10,
                    dataRowColor: WidgetStatePropertyAll(
                      ThemeColors.black.withValues(alpha: 0.4),
                    ),
                    headingRowColor: WidgetStatePropertyAll(
                      ThemeColors.black.withValues(alpha: 0.4),
                    ),
                    border: TableBorder.all(
                      color: ThemeColors.black,
                      width: 0.9,
                    ),
                    columns: [
                      DataColumn(
                        label: Text(
                          'Name',
                          style: styleBaseBold(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    rows: exchangeRates?.data?.map((header) {
                      return DataRow(
                        cells: [
                          DataCell(InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  CachedNetworkImagesWidget(
                                    header.info?.image ?? '',
                                    height: 22,
                                    width: 22,
                                    placeHolder: Images.placeholder,
                                    showLoading: true,
                                    fit: BoxFit.contain,
                                  ),
                                  SpacerHorizontal(width: Pad.pad10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          header.info?.name ?? "",
                                          style: styleBaseBold(
                                            fontSize: 12,
                                           ),
                                        ),
                                        Text(
                                          header.info?.symbol ?? "",
                                          style: styleBaseRegular(
                                              fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      );
                    }).toList() ??
                        [],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        horizontalMargin: 10,
                        border: TableBorder(
                          top: BorderSide(
                            color: ThemeColors.black,
                            width: 0.5,
                          ),
                          bottom: BorderSide(
                            color: ThemeColors.black,
                            width: 0.5,
                          ),
                          horizontalInside: BorderSide(
                            color: ThemeColors.black,
                            width: 0.5,
                          ),
                        ),
                        columns: exchangeRates?.header?.map((header) {
                          return DataColumn(
                            label: Text(
                              header,
                              style: styleBaseBold(
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList() ??
                            [],
                        rows: exchangeRates?.data?.map((company) {
                          return DataRow(
                            cells: [
                              for (var values in company.data!)
                                _dataCell(text: values),
                            ],
                          );
                        }).toList() ??
                            [],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

      ),
    );
  }

  DataCell _dataCell({required String text}) {
    return DataCell(
      Text(
        text,
        style: styleBaseBold(fontSize: 12),
      ),
    );
  }


  Widget symbolSection() {
    BillionairesManager manager = context.watch<BillionairesManager>();
    CryptoData? cryptoRates = manager.cryptoFiatRes?.cryptoData;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical:3),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: ThemeColors.neutral5),
      child: Row(
        children: [
          Expanded(
            child: ThemeInputField(
                cursorColor: ThemeColors.black,
                fillColor: ThemeColors.white,
                borderColor: ThemeColors.white,
                controller: manager.btcController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: styleBaseBold(),
                onChanged: (value) {
                  manager.isActiveChange(1);
                  manager.calculateConversion();
                },
                suffix: InkWell(
                    onTap: () {
                      manager.btcController.text = "0.00";
                      manager.usdController.text = "0.00";
                      setState(() {});
                    },
                    child: Image.asset(Images.x, width: 14, height: 14,color: ThemeColors.black))),
          ),
          SpacerHorizontal(width: Pad.pad5),
          Expanded(
            child: InkWell(
              onTap: (){
                manager.searchSymbol=[];
                showSymbol(context);
              },
              child: AbsorbPointer(
                child:
                ThemeInputField(
                  placeholder: cryptoRates?.cryptoSymbol?.contains(manager.selectedSymbol) == true
                      ? manager.selectedSymbol?.symbol
                      :manager.searchSymbol.contains(manager.selectedSymbol) == true?manager.selectedSymbol?.symbol: "",
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    size: 23,
                    color: ThemeColors.black,
                  ),
                  hintStyle: styleBaseRegular(color: ThemeColors.black),
                  editable: false,
                  contentPadding: EdgeInsets.only(left:10,top:12.sp),
                  cursorColor: ThemeColors.black,
                  fillColor: ThemeColors.white,
                  borderColor: ThemeColors.white,
                  controller:symbolController,

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget currencySection() {
    BillionairesManager manager = context.watch<BillionairesManager>();
    CryptoData? cryptoRates = manager.cryptoFiatRes?.cryptoData;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 3, vertical:3),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: ThemeColors.neutral5),
      child: Row(
        children: [
          Expanded(
            child: ThemeInputField(
              cursorColor: ThemeColors.black,
              fillColor: ThemeColors.white,
              borderColor: ThemeColors.white,
              controller: manager.usdController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: styleBaseBold(),
              onChanged: (value) {
                manager.isActiveChange(2);
                manager.calculateWithPriceChange();
              },
              suffix: InkWell(
                  onTap: () {
                    manager.btcController.text = "0.00";
                    manager.usdController.text = "0.00";
                    setState(() {});
                  },
                  child: Image.asset(Images.x, width: 14, height: 14,color: ThemeColors.black)),
            ),
          ),
          SpacerHorizontal(width: Pad.pad5),
          Expanded(
            child: InkWell(
              onTap: (){
                manager.searchCurrency=[];
                showCurrency(context);
              },
              child: AbsorbPointer(
                child:
                ThemeInputField(
                  placeholder: cryptoRates?.rates?.contains(manager.selectedItem) == true
                      ? manager.selectedItem?.currency
                      :manager.searchCurrency.contains(manager.selectedItem) == true?manager.selectedItem?.currency: "",
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    size: 23,
                    color: ThemeColors.black,
                  ),
                  hintStyle: styleBaseRegular(color: ThemeColors.black),
                  editable: false,
                  contentPadding: EdgeInsets.only(left:10,top:12.sp),
                  cursorColor: ThemeColors.black,
                  fillColor: ThemeColors.white,
                  borderColor: ThemeColors.white,
                  controller:searchController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSymbol(BuildContext context) {

    BaseBottomSheet().bottomSheet(
        barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
        child:Builder(
          builder: (context) {
            BillionairesManager manager = context.watch<BillionairesManager>();
            CryptoData? cryptoRates = manager.cryptoFiatRes?.cryptoData;
            TextEditingController searchController = TextEditingController();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseHeading(
                    title: "Select Symbol",
                    titleStyle: styleBaseBold(),
                  ),
                  SpacerVertical(height: 10),
                  BaseTextField(
                    placeholder: "Search",
                    controller: searchController,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    onChanged: (values){
                      if (_timer != null) {
                        _timer!.cancel();
                      }
                      _timer = Timer(
                        const Duration(milliseconds: 1000),
                            () {
                          manager.getSearchOfSymbol(values);

                        },
                      );
                    },
                  ),

                  SpacerVertical(height: Pad.pad10),
                  Expanded(
                    child: manager.searchSymbol.isNotEmpty
                        ? ListView.builder(
                      itemCount: manager.searchSymbol.length,
                      itemBuilder: (context, index) {
                        Rate item = manager.searchSymbol[index];
                        return SearchTiles(
                          item: item,
                          onTap: () {
                            setState(() {
                              manager.selectedSymbol = item;
                            });
                            Navigator.pop(context);
                            if (manager.isActiveField == 1) {
                              manager.calculateConversion();
                            } else {
                              manager.calculateWithPriceChange();
                            }
                          },
                          fromTo: 1,
                        );
                      },
                    ):
                    ListView.builder(
                      itemCount: cryptoRates?.cryptoSymbol?.length,
                      itemBuilder: (context, index) {
                        Rate? item = cryptoRates?.cryptoSymbol?[index];
                        return SearchTiles(
                          item: item,
                          onTap: () {
                            setState(() {
                              manager.selectedSymbol = item;
                            });
                            Navigator.pop(context);
                            if (manager.isActiveField == 1) {
                              manager.calculateConversion();
                            } else {
                              manager.calculateWithPriceChange();
                            }
                          },
                          fromTo: 1,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        )
    );
  }
  void showCurrency(BuildContext context) {
    BaseBottomSheet().bottomSheet(
        barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
        child:Builder(
          builder: (context) {
            BillionairesManager manager = context.watch<BillionairesManager>();
            CryptoData? cryptoRates = manager.cryptoFiatRes?.cryptoData;
            TextEditingController searchController = TextEditingController();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  BaseHeading(
                    title: "Select Currency",
                    titleStyle: styleBaseBold(),
                  ),
                  SpacerVertical(height: 10),
                  BaseTextField(
                    placeholder: "Search",
                    controller: searchController,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    onChanged: (values){
                      if (_timer != null) {
                        _timer!.cancel();
                      }
                      _timer = Timer(
                        const Duration(milliseconds: 1000),
                            () {
                          manager.getSearchOfCurrency(values);

                        },
                      );
                    },
                  ),
                  SpacerVertical(height: Pad.pad10),
                  Expanded(
                    child: manager.searchCurrency.isNotEmpty
                        ? ListView.builder(
                      itemCount: manager.searchCurrency.length,
                      itemBuilder: (context, index) {
                        Rate item = manager.searchCurrency[index];
                        return
                          SearchTiles(
                            item: item,
                            onTap: () {
                              setState(() {
                                manager.selectedItem = item;
                              });
                              Navigator.pop(context);
                              if (manager.isActiveField == 1) {
                                manager.calculateConversion();
                              } else {
                                manager.calculateWithPriceChange();
                              }
                            },
                            fromTo: 2,
                          );
                      },
                    ):
                    ListView.builder(
                      itemCount: cryptoRates?.rates?.length,
                      itemBuilder: (context, index) {
                        Rate? item = cryptoRates?.rates?[index];
                        return
                          SearchTiles(
                            item: item,
                            onTap: () {
                              setState(() {
                                manager.selectedItem = item;
                              });
                              Navigator.pop(context);
                              if (manager.isActiveField == 1) {
                                manager.calculateConversion();
                              } else {
                                manager.calculateWithPriceChange();
                              }
                            },
                            fromTo:2,
                          );

                      },
                    ),
                  ),
                ],
              ),
            );
          }
        )

    );

  }

}
