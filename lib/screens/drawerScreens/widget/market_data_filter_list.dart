import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class MarketDataFilterListing extends StatelessWidget {
  final dynamic items;
  final String? label;
  final Function(int) onSelected;
  final double paddingLeft;
  const MarketDataFilterListing({
    super.key,
    required this.items,
    this.label,
    required this.onSelected,
    this.paddingLeft = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    label ?? "",
                    style: index == 0
                        ? stylePTSansBold(fontSize: 16)
                        : stylePTSansRegular(fontSize: 15),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  onSelected(index);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      items[index].value ?? "",
                      style: index == 0
                          ? stylePTSansBold(fontSize: 16)
                          : stylePTSansRegular(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 20,
            color: ThemeColors.greyBorder.withOpacity(0.4),
          );
        },
        itemCount: items.length);
  }
}
