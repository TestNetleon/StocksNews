import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MarketTabs extends StatefulWidget {
  const MarketTabs({
    super.key,
    required this.data,
    required this.onTap,
  });

  final List<MarketResData> data;
  final Function(int index) onTap;
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
    _tabController = TabController(length: widget.data.length, vsync: this);
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
        Divider(
          color: ThemeColors.neutral5,
          height: 1,
          thickness: 1,
        ),
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
                color: selected ? ThemeColors.secondary120 : Colors.white,
                width: 2,
              ),
            ),
            width: 64,
            height: 64,
            padding: EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? ThemeColors.black : ThemeColors.neutral5,
              ),
              width: 56,
              height: 56,
              child: Center(
                child: CachedNetworkImagesWidget(
                  data.icon ?? "",
                  fit: BoxFit.contain,
                  width: 18,
                  height: 18,
                  color: selected ? Colors.white : null,
                ),
              ),
            ),
          ),
          const SpacerVertical(height: 8),
          Text(
            data.title ?? "",
            style: styleBaseSemiBold(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
