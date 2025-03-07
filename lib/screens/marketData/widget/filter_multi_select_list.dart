import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class FilterMultiSelectListing extends StatefulWidget {
  final List<FiltersDataItem> items;
  final List<String>? selectedData;
  final String? label;
  final Function(List<FiltersDataItem>) onSelected;
  final double paddingLeft;
  final ScrollController? scrollController;

  const FilterMultiSelectListing({
    required this.onSelected,
    required this.items,
    this.label,
    this.selectedData,
    this.scrollController,
    this.paddingLeft = 0,
    super.key,
  });

  @override
  State<FilterMultiSelectListing> createState() =>
      _FilterMultiSelectListingState();
}

class _FilterMultiSelectListingState extends State<FilterMultiSelectListing> {
  final List<FiltersDataItem> _selected = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedData != null) {
        for (var item in widget.items) {
          if (widget.selectedData!.contains(item.value)) _selected.add(item);
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.separated(
            controller: widget.scrollController,
            // shrinkWrap: true,
            padding: EdgeInsets.zero,
            // physics: const NeverScrollableScrollPhysics(),
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              FiltersDataItem item = widget.items[index];
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    if (_selected.contains(item)) {
                      _selected.remove(item);
                    } else {
                      _selected.add(item);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 0,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _selected.contains(item),
                        activeColor: ThemeColors.accent,
                        checkColor: ThemeColors.white,
                        side: const BorderSide(color: ThemeColors.greyText),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.items !=
                              context.read<FilterProvider>().data!.marketRank!)
                            Text(
                              item.value ?? "",
                              style: stylePTSansRegular(fontSize: 15),
                            ),
                          if (widget.items ==
                              context.read<FilterProvider>().data!.marketRank!)
                            RatingBarIndicator(
                              rating: double.parse("${item.value ?? 0}"),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 18,
                              direction: Axis.horizontal,
                              unratedColor: ThemeColors.greyBorder,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     if (index == 0 && widget.label != null)
              //       Padding(
              //         padding: const EdgeInsets.only(
              //           bottom: 20,
              //           top: 20,
              //           left: 0,
              //         ),
              //         child: Text(
              //           widget.label ?? "",
              //           style: index == 0
              //               ? stylePTSansBold(fontSize: 16)
              //               : stylePTSansRegular(fontSize: 15),
              //         ),
              //       ),
              //     GestureDetector(
              //       behavior: HitTestBehavior.translucent,
              //       onTap: () {
              //         setState(() {
              //           if (_selected.contains(item)) {
              //             _selected.remove(item);
              //           } else {
              //             _selected.add(item);
              //           }
              //         });
              //       },
              //       child: Container(
              //         padding: const EdgeInsets.only(
              //           left: 0,
              //           top: 5,
              //           bottom: 5,
              //         ),
              //         child: Row(
              //           children: [
              //             Checkbox(
              //               value: _selected.contains(item),
              //               activeColor: ThemeColors.accent,
              //               checkColor: ThemeColors.white,
              //               side: const BorderSide(color: ThemeColors.greyText),
              //               materialTapTargetSize:
              //                   MaterialTapTargetSize.shrinkWrap,
              //               onChanged: (value) {
              //                 setState(() {
              //                   if (value != null && value) {
              //                     _selected.add(item);
              //                   } else {
              //                     _selected.remove(item);
              //                   }
              //                 });
              //               },
              //             ),
              //             Text(
              //               item.value,
              //               style: stylePTSansRegular(fontSize: 15),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 3,
                color: ThemeColors.greyBorder.withOpacity(0.9),
              );
            },
            itemCount: widget.items.length,
          ),
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
        SpacerVertical(height: ScreenUtil().bottomBarHeight),
      ],
    );
  }
}
