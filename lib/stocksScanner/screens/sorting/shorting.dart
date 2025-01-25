import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../routes/my_app.dart';

enum SortByEnums {
  symbol,
  company,
  sector,
  lastTrade,
  netChange,
  perChange,
  volume,
  dollarVolume
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
}) {
  showModalBottomSheet(
    enableDrag: true,
    isDismissible: true,
    context: navigatorKey.currentContext!,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return MarketScannerSorting(sortByCallBack: sortByCallBack);
    },
  );
}

class MarketScannerSorting extends StatefulWidget {
  final Function(SortByClass)? sortByCallBack;
  final bool? sortBy;
  const MarketScannerSorting({
    super.key,
    this.sortByCallBack,
    this.sortBy,
  });

  @override
  State<MarketScannerSorting> createState() => _MarketScannerSortingState();
}

class _MarketScannerSortingState extends State<MarketScannerSorting> {
  // This method will handle the sorting callback for all enums.
  Widget _buildSortOption(String label, SortByEnums type, {bool? sortBy}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Sort by $label',
            style:
                styleGeorgiaBold(color: ThemeColors.background, fontSize: 20),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (widget.sortByCallBack != null) {
              widget.sortByCallBack!(
                SortByClass(type: type, ascending: true),
              );
            }
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: 50,
              child: Icon(
                Icons.arrow_upward,
                size: 25,
                color: sortBy == false ? ThemeColors.accent : Colors.black,
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
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: 50,
              child: Icon(
                Icons.arrow_downward,
                size: 25,
                color: sortBy == true ? ThemeColors.accent : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          // Sort by Symbol
          _buildSortOption(
            'Symbol',
            SortByEnums.symbol,
            sortBy: widget.sortBy,
          ),

          // Sort by Company
          _buildSortOption(
            'Company',
            SortByEnums.company,
            sortBy: widget.sortBy,
          ),

          // Sort by Sector
          _buildSortOption(
            'Sector',
            SortByEnums.sector,
            sortBy: widget.sortBy,
          ),

          // Sort by Last Trade
          _buildSortOption(
            'Last Trade',
            SortByEnums.lastTrade,
            sortBy: widget.sortBy,
          ),

          // Sort by Net Change
          _buildSortOption(
            'Net Change',
            SortByEnums.netChange,
            sortBy: widget.sortBy,
          ),

          // Sort by Percentage Change
          _buildSortOption(
            'Percentage Change',
            SortByEnums.perChange,
            sortBy: widget.sortBy,
          ),

          // Sort by Volume
          _buildSortOption(
            'Volume',
            SortByEnums.volume,
            sortBy: widget.sortBy,
          ),

          // Sort by Dollar Volume
          _buildSortOption(
            '\$ Volume',
            SortByEnums.dollarVolume,
            sortBy: widget.sortBy,
          ),
        ],
      ),
    );
  }
}
