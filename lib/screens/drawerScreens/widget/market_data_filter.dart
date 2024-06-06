import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_screener_provider.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter_list.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter_textfiled.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class MarketDataFilterBottomSheet extends StatelessWidget {
  const MarketDataFilterBottomSheet({required this.provider, super.key});
  final dynamic provider;

  void _showExchangePicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All Exchange",
        items: provider.dataFilterBottomSheet.exchange,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangeExchange(
                provider.dataFilterBottomSheet.exchange[index].key.toString(),
                provider.dataFilterBottomSheet.exchange[index].value.toString(),
              );
        },
      ),
    );
  }

  void _showSectorPicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All Sector",
        items: provider.dataFilterBottomSheet.sectors,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangeSector(
                provider.dataFilterBottomSheet.sectors[index].key.toString(),
                provider.dataFilterBottomSheet.sectors[index].value.toString(),
              );
        },
      ),
    );
  }

  void _showIndustryPicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All Industry",
        items: provider.dataFilterBottomSheet.industries,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangeIndustries(
                provider.dataFilterBottomSheet.industries[index].key.toString(),
                provider.dataFilterBottomSheet.industries[index].value
                    .toString(),
              );
        },
      ),
    );
  }

  void _showMarketCapPicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All Market Cap",
        items: provider.dataFilterBottomSheet.marketCap,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangeMarketcap(
                provider.dataFilterBottomSheet.marketCap[index].key.toString(),
                provider.dataFilterBottomSheet.marketCap[index].value
                    .toString(),
              );
        },
      ),
    );
  }

  void _showPricePicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All Price",
        items: provider.dataFilterBottomSheet.price,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangePrice(
                provider.dataFilterBottomSheet.price[index].key.toString(),
                provider.dataFilterBottomSheet.price[index].value.toString(),
              );
        },
      ),
    );
  }

  void _showBetaPicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All Beta",
        items: provider.dataFilterBottomSheet.beta,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangeBeta(
                provider.dataFilterBottomSheet.beta[index].key.toString(),
                provider.dataFilterBottomSheet.beta[index].value.toString(),
              );
        },
      ),
    );
  }

  void _showDividendPicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All Dividend",
        items: provider.dataFilterBottomSheet.dividend,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangeDividend(
                provider.dataFilterBottomSheet.dividend[index].key.toString(),
                provider.dataFilterBottomSheet.dividend[index].value.toString(),
              );
        },
      ),
    );
  }

  void _showETFPicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All ETF",
        items: provider.dataFilterBottomSheet.isEtf,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangeIsEtf(
                provider.dataFilterBottomSheet.isEtf[index].key.toString(),
                provider.dataFilterBottomSheet.isEtf[index].value.toString(),
              );
        },
      ),
    );
  }

  void _showFundPicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All Fund",
        items: provider.dataFilterBottomSheet.isFund,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangeIsFund(
                provider.dataFilterBottomSheet.isFund[index].key.toString(),
                provider.dataFilterBottomSheet.isFund[index].value.toString(),
              );
        },
      ),
    );
  }

  void _showActivelyTradingPicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: MarketDataFilterListing(
        label: "All ActivelyTrading",
        items: provider.dataFilterBottomSheet.isActivelyTrading,
        onSelected: (index) {
          context.read<StockScreenerProvider>().onChangeIsActivelyTrading(
                provider.dataFilterBottomSheet.isActivelyTrading[index].key
                    .toString(),
                provider.dataFilterBottomSheet.isActivelyTrading[index].value
                    .toString(),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isPhone ? 0 : 0 // ScreenUtil().screenWidth * .15,
          ),
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
                    hintText: "All Exchange",
                    label: "Exchange Type",
                    onTap: () => _showExchangePicker(context),
                    controller: provider.exchangeController,
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  child: MarketDataTextFiledClickable(
                      hintText: "All Sector",
                      label: "Sector",
                      onTap: () => _showSectorPicker(context),
                      controller: provider.sectorController),
                ),
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
              context.read<StockScreenerProvider>().getStockScreenerStocks();
            },
            text: "FILTER",
            textColor: Colors.white,
          ),
          SpacerVertical(height: ScreenUtil().bottomBarHeight),
        ],
      ),
    );
  }
}
