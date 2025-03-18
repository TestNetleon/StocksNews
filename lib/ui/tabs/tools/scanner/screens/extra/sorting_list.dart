import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../manager/scanner.dart';

class SortByClass {
  final SortByEnums type;
  final bool ascending;
  SortByClass({
    required this.type,
    required this.ascending,
  });
}

class ScannerSortingList extends StatefulWidget {
  final Function(SortByClass) sortByCallBack;
  final bool? sortBy;
  final String? header;
  final bool showPreMarket;
  final bool showSector;
  final String? text;
  const ScannerSortingList({
    this.text,
    super.key,
    this.showSector = true,
    required this.sortByCallBack,
    this.sortBy,
    this.header,
    this.showPreMarket = false,
  });

  @override
  State<ScannerSortingList> createState() => _ScannerSortingListState();
}

class _ScannerSortingListState extends State<ScannerSortingList> {
  //
  Widget _buildSortOption(
    String label,
    SortByEnums type, {
    bool? sortBy,
    bool textBold = false,
  }) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textBold
                      ? styleBaseBold(
                          color: ThemeColors.black,
                          fontSize: 15,
                        )
                      : styleBaseRegular(
                          color: ThemeColors.black,
                          fontSize: 15,
                        ),
                ),
              ),
              SpacerHorizontal(width: 5),
              GestureDetector(
                onTap: () {
                  widget.sortByCallBack(
                    SortByClass(type: type, ascending: true),
                  );
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
                  widget.sortByCallBack(
                    SortByClass(type: type, ascending: false),
                  );
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
        ),
        BaseListDivider(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpacerVertical(height: 5),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Pad.pad16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: BaseHeading(
                    title: 'Sort stocks by',
                    titleStyle: styleBaseBold(fontSize: 25),
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
          ),
          BaseListDivider(color: ThemeColors.neutral80),
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
              textBold: true,
            ),
          ),
          Visibility(
            visible: widget.text != null && widget.text != '',
            child: _buildSortOption(
              '${widget.text} Net Change',
              SortByEnums.postMarketNetChange,
              sortBy: widget.header == SortByEnums.postMarketNetChange.name
                  ? widget.sortBy
                  : null,
              textBold: true,
            ),
          ),
          Visibility(
            visible: widget.text != null && widget.text != '',
            child: _buildSortOption(
              '${widget.text} Percentage Change',
              SortByEnums.postMarketPerChange,
              sortBy: widget.header == SortByEnums.postMarketPerChange.name
                  ? widget.sortBy
                  : null,
              textBold: true,
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
