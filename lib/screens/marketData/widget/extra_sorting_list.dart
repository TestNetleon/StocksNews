import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class ExtraSortingList extends StatefulWidget {
  const ExtraSortingList({
    super.key,
    this.selected,
    this.list,
    required this.onTap,
  });

  final void Function(String)? onTap;
  final String? selected;
  final List<FiltersDataItem>? list;

  @override
  State<ExtraSortingList> createState() => _ExtraSortingListState();
}

class _ExtraSortingListState extends State<ExtraSortingList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListView.separated(
          shrinkWrap: true,
          itemCount: widget.list?.length ?? 0,
          itemBuilder: (context, index) {
            FiltersData? data = context.watch<FilterProvider>().data;
            if (data == null) {
              return const SizedBox();
            }
            return GestureDetector(
              onTap: () {
                if (widget.onTap == null) {
                  return;
                }
                widget.onTap!(widget.list?[index].key ?? "");
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10.sp),
                child: Text(
                  widget.list?[index].value ?? "",
                  style: stylePTSansBold(
                    color: widget.selected == widget.list?[index].key
                        ? ThemeColors.accent
                        : Colors.white,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ],
    );
  }
}
