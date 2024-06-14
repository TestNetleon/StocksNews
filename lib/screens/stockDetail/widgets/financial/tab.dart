import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';

class SdFinancialTabs extends StatelessWidget {
  final List<SdTopRes>? tabs;
  final Function(int index) onChange;
  final int selectedIndex;
  const SdFinancialTabs({
    super.key,
    this.tabs,
    required this.onChange,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(tabs?.length ?? 0, (index) {
                    final isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        onChange(index);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: isSelected
                                ? ThemeColors.accent
                                : ThemeColors.greyBorder.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Text(
                          tabs?[index].key ?? "N/A",
                          style: styleGeorgiaBold(),
                        ),
                      ),
                    );
                  }),
                ),
                // Adding a SizedBox to force the Row to start from the left
                SizedBox(width: MediaQuery.of(context).size.width),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: ThemeColors.accent,
          )
        ],
      ),
    );
  }
}
