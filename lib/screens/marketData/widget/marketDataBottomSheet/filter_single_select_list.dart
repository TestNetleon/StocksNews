import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FilterSingleSelectListing extends StatefulWidget {
  final List<FiltersDataItem> items;
  final String? selectedData;
  final String? label;
  final Function(FiltersDataItem?) onSelected;
  final double paddingLeft;
  final ScrollController? scrollController;

  const FilterSingleSelectListing({
    required this.onSelected,
    required this.items,
    this.label,
    this.selectedData,
    this.scrollController,
    this.paddingLeft = 0,
    super.key,
  });

  @override
  State<FilterSingleSelectListing> createState() =>
      _FilterSingleSelectListingState();
}

class _FilterSingleSelectListingState extends State<FilterSingleSelectListing> {
  FiltersDataItem? _selected;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedData != null) {
        for (var item in widget.items) {
          if (widget.selectedData == item.value) {
            setState(() {
              _selected = item;
            });
          }
        }
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
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              FiltersDataItem item = widget.items[index];
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    if (_selected == item) {
                      widget.onSelected(null);

                      // _selected = null;
                    } else {
                      widget.onSelected(item);
                      // _selected = item;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(
                    children: [
                      Text(
                        item.value,
                        style: stylePTSansRegular(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 3,
                  color: ThemeColors.greyBorder.withOpacity(0.9),
                ),
              );
            },
            itemCount: widget.items.length,
          ),
        ),
        // ThemeButton(
        //   color: ThemeColors.accent,
        //   onPressed: () {
        //     Navigator.pop(context);
        //     widget.onSelected(_selected);
        //   },
        //   text: "DONE",
        //   textColor: Colors.white,
        // ),
        SpacerVertical(height: ScreenUtil().bottomBarHeight),
      ],
    );
  }
}
