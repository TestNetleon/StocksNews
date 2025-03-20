import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MarketTabs extends StatefulWidget {
  const MarketTabs({
    super.key,
    required this.data,
    required this.onTap,
    required this.selectedIndex,
  });

  final List<MarketResData> data;
  final Function(int index) onTap;
  final int? selectedIndex;

  @override
  State<MarketTabs> createState() => _MarketTabsState();
}

class _MarketTabsState extends State<MarketTabs>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex ?? 0;
    }
    // _tabController = TabController(length: widget.data.length, vsync: this);
    _initializeTabController();
  }

  // Reinitialize the TabController when the data changes
  @override
  void didUpdateWidget(MarketTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.length != oldWidget.data.length) {
      _initializeTabController();
    }
  }

  void _initializeTabController() {
    if (_tabController != null) {
      _tabController!.dispose();
    }
    _tabController = TabController(
      length: widget.data.length,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: (widget.data.asMap().entries.map(
            (entry) {
              int index = entry.key; // This is the index
              var data = entry.value; // This is the data
              return TabItem(
                data: data,
                selected: _selectedIndex == index,
              );
            },
          )).toList(),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          indicator: BoxDecoration(),
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
            widget.onTap(index);
          },
        ),
        BaseListDivider(),
      ],
    );
  }
}

class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.data,
    this.selected = false,
  });

  final MarketResData data;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? ThemeColors.secondary120 : ThemeColors.white,
                width: 2,
              ),
            ),
            width: 64,
            height: 64,
            padding: EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? ThemeColors.selectedBG : ThemeColors.neutral5,
              ),
              width: 56,
              height: 56,
              child: Center(
                child: CachedNetworkImagesWidget(
                  data.icon ?? "",
                  fit: BoxFit.contain,
                  width: 18,
                  height: 18,
                  color: selected ? Colors.white : ThemeColors.neutral60,
                ),
              ),
            ),
          ),
          const SpacerVertical(height: 8),
          Text(
            data.title ?? "",
            style: selected
                // ? styleBaseBold(fontSize: 12)
                ? styleBaseBold(fontSize: 12, color: ThemeColors.selectedBG)
                : styleBaseRegular(fontSize: 12, color: ThemeColors.neutral40),
          ),
        ],
      ),
    );
  }
}
