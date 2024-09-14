import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';

class MsShareholdingsTab extends StatelessWidget {
  final void Function(int)? onTap;
  final int selectedIndex;
  final TabController? controller;
  final List<String> tabs;
  const MsShareholdingsTab({
    super.key,
    this.onTap,
    this.controller,
    required this.selectedIndex,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: TabBar(
        onTap: onTap,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        controller: controller,
        labelPadding: EdgeInsets.only(bottom: 10),
        tabs: List.generate(
          tabs.length,
          (index) {
            return Container(
              width: 80,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: selectedIndex == index
                          ? Colors.white54
                          : Colors.white24),
                  borderRadius: BorderRadius.circular(20.0),
                  color: selectedIndex == index
                      ? Color.fromARGB(255, 32, 33, 34)
                      : Color.fromARGB(255, 32, 33, 34)),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  tabs[index],
                  style: stylePTSansRegular(
                    fontSize: 14.0,
                    color: selectedIndex == index ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
