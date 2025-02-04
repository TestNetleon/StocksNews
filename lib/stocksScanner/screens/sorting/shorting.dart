import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../routes/my_app.dart';

enum SortByEnums {
  symbol,
  company,
  sector,
  lastTrade,
  netChange,
  perChange,
  volume,
  dollarVolume,
  bid,
  ask,
  postMarket,
}

class SortByClass {
  final SortByEnums type;
  final bool ascending;
  SortByClass({
    required this.type,
    required this.ascending,
  });
}

scannerSorting({
  Function(SortByClass)? sortByCallBack,
  bool? sortBy,
  String? header,
  bool showPreMarket = false,
  bool showSector = true,
  String? text,
}) {
  showModalBottomSheet(
    context: navigatorKey.currentContext!,
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return MarketScannerSorting(
        sortByCallBack: sortByCallBack,
        sortBy: sortBy,
        header: header,
        showPreMarket: showPreMarket,
        showSector: showSector,
        text: text,
      );
    },
  );
}

class MarketScannerSorting extends StatefulWidget {
  final Function(SortByClass)? sortByCallBack;
  final bool? sortBy;
  final String? header;
  final bool showPreMarket;
  final bool showSector;
  final String? text;
  const MarketScannerSorting({
    this.text,
    super.key,
    this.showSector = true,
    this.sortByCallBack,
    this.sortBy,
    this.header,
    this.showPreMarket = false,
  });

  @override
  State<MarketScannerSorting> createState() => _MarketScannerSortingState();
}

class _MarketScannerSortingState extends State<MarketScannerSorting> {
  // This method will handle the sorting callback for all enums.
  Widget _buildSortOption(String label, SortByEnums type, {bool? sortBy}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: styleGeorgiaRegular(
                    color: ThemeColors.background, fontSize: 18),
              ),
            ),
            SpacerHorizontal(width: 5),
            GestureDetector(
              onTap: () {
                if (widget.sortByCallBack != null) {
                  widget.sortByCallBack!(
                    SortByClass(type: type, ascending: true),
                  );
                }
              },
              child: Card(
                color: sortBy == true ? ThemeColors.accent : Colors.white,
                child: Container(
                  padding: EdgeInsets.all(8),
                  // width: 50,
                  child: Icon(
                    Icons.arrow_upward,
                    size: 16,
                    color: sortBy == true ? ThemeColors.white : Colors.black,
                  ),
                ),
              ),
            ),
            SpacerHorizontal(width: 10),
            GestureDetector(
              onTap: () {
                if (widget.sortByCallBack != null) {
                  widget.sortByCallBack!(
                    SortByClass(type: type, ascending: false),
                  );
                }
              },
              child: Card(
                color: sortBy == false ? ThemeColors.accent : Colors.white,
                child: Container(
                  padding: EdgeInsets.all(8),
                  // width: 50,
                  child: Icon(
                    Icons.arrow_downward,
                    size: 16,
                    color: sortBy == false ? ThemeColors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: ThemeColors.greyBorder,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: ScreenTitle(
                  title: 'Sort stocks by',
                  style: styleGeorgiaBold(
                      color: ThemeColors.background, fontSize: 23),
                  dividerPadding: EdgeInsets.zero,
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: ThemeColors.blackShade,
                  ))
            ],
          ),
          Divider(
            color: ThemeColors.background,
            thickness: 1,
          ),
          // Sort by Symbol
          _buildSortOption(
            'Symbol Name',
            SortByEnums.symbol,
            sortBy:
                widget.header == SortByEnums.symbol.name ? widget.sortBy : null,
          ),

          // Sort by Company
          _buildSortOption(
            'Company Name',
            SortByEnums.company,
            sortBy: widget.header == SortByEnums.company.name
                ? widget.sortBy
                : null,
          ),

          Visibility(
            visible: widget.text != null && widget.text != '',
            child: _buildSortOption(
              '${widget.text} Price',
              SortByEnums.postMarket,
              sortBy: widget.header == SortByEnums.postMarket.name
                  ? widget.sortBy
                  : null,
            ),
          ),

          // Sort by Last Trade
          _buildSortOption(
            'Last Trade Price',
            SortByEnums.lastTrade,
            sortBy: widget.header == SortByEnums.lastTrade.name
                ? widget.sortBy
                : null,
          ),

          // Sort by Net Change
          _buildSortOption(
            'Net Change',
            SortByEnums.netChange,
            sortBy: widget.header == SortByEnums.netChange.name
                ? widget.sortBy
                : null,
          ),

          // Sort by Percentage Change
          _buildSortOption(
            'Percentage Change',
            SortByEnums.perChange,
            sortBy: widget.header == SortByEnums.perChange.name
                ? widget.sortBy
                : null,
          ),

          // Sort by Volume
          _buildSortOption(
            'Volume',
            SortByEnums.volume,
            sortBy:
                widget.header == SortByEnums.volume.name ? widget.sortBy : null,
          ),

          // Sort by Dollar Volume
          _buildSortOption(
            '\$Volume',
            SortByEnums.dollarVolume,
            sortBy: widget.header == SortByEnums.dollarVolume.name
                ? widget.sortBy
                : null,
          ),

          _buildSortOption(
            'Bid Price',
            SortByEnums.bid,
            sortBy:
                widget.header == SortByEnums.bid.name ? widget.sortBy : null,
          ),
          _buildSortOption(
            'Ask Price',
            SortByEnums.ask,
            sortBy:
                widget.header == SortByEnums.ask.name ? widget.sortBy : null,
          ),

          // Sort by Sector
          Visibility(
            visible: widget.showSector,
            child: _buildSortOption(
              'Sector-wise',
              SortByEnums.sector,
              sortBy: widget.header == SortByEnums.sector.name
                  ? widget.sortBy
                  : null,
            ),
          ),

          SpacerVertical(height: 20),
        ],
      ),
    );
  }
}
