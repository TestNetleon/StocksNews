import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class FilterMultiSelectListing extends StatefulWidget {
  final List<FiltersDataItem> items;
  final String? label;
  final Function(List<FiltersDataItem>) onSelected;
  final double paddingLeft;

  const FilterMultiSelectListing({
    super.key,
    required this.items,
    this.label,
    required this.onSelected,
    this.paddingLeft = 0,
  });

  @override
  State<FilterMultiSelectListing> createState() =>
      _FilterMultiSelectListingState();
}

class _FilterMultiSelectListingState extends State<FilterMultiSelectListing> {
  List<FiltersDataItem> _selected = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            FiltersDataItem item = widget.items[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      widget.label ?? "",
                      style: index == 0
                          ? stylePTSansBold(fontSize: 16)
                          : stylePTSansRegular(fontSize: 15),
                    ),
                  ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // widget.onSelected(index);
                    // Navigator.pop(context);
                    setState(() {
                      if (_selected.contains(item)) {
                        _selected.remove(item);
                      } else {
                        _selected.add(item);
                      }
                    });
                  },
                  child: Container(
                    // color: Colors.grey,
                    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _selected.contains(item),
                          activeColor: ThemeColors.accent,
                          checkColor: ThemeColors.white,
                          side: const BorderSide(color: ThemeColors.greyText),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                _selected.add(item);
                              } else {
                                _selected.remove(item);
                              }
                            });
                          },
                        ),
                        Text(
                          item.value,
                          style: stylePTSansRegular(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 3,
              color: ThemeColors.greyBorder.withOpacity(0.9),
            );
          },
          itemCount: widget.items.length,
        ),
        // ThemeButton(
        //   onPressed: () => widget.onSelected(_selected),
        //   text: "Done",
        // )
        ThemeButton(
          color: ThemeColors.accent,
          onPressed: () {
            Navigator.pop(context);
            widget.onSelected(_selected);
            //   context.read<StockScreenerProvider>().getStockScreenerStocks();
          },
          text: "DONE",
          textColor: Colors.white,
        ),
      ],
    );
  }
}
