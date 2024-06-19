import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class MdBottomSheet extends StatelessWidget {
  const MdBottomSheet({
    required this.onTapSorting,
    required this.onTapFilter,
    this.isFilter = false,
    this.isSort = false,
    super.key,
  });

  final void Function()? onTapSorting;
  final void Function()? onTapFilter;
  final bool isFilter;
  final bool isSort;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: ThemeColors.greyBorder,
          height: 0.sp,
          thickness: 1,
        ),
        Container(
          width: double.infinity,
          color: ThemeColors.background,
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTapSorting,
                  child: Row(
                    // alignment: Alignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            Images.sorting,
                            height: 18,
                            width: 18,
                            color: Colors.white,
                          ),
                          const SpacerHorizontal(width: 10),
                          Text(
                            "SORT",
                            style: stylePTSansBold(color: Colors.white),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Visibility(
                          visible: isSort,
                          child: const Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                Images.line,
                height: 18,
                width: 18,
                color: Colors.white,
              ),
              Expanded(
                child: InkWell(
                  onTap: onTapFilter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.filter_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SpacerHorizontal(width: 10),
                          Text(
                            "FILTER",
                            style: stylePTSansBold(color: Colors.white),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Visibility(
                          visible: isFilter,
                          child: const Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
