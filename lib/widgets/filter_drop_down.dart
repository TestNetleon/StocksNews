import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FilterDropDownTextField extends StatelessWidget {
  final KeyValueElement? value;
  final String heading;
  final List<DropdownMenuItem<KeyValueElement>>? items;
  final void Function(KeyValueElement?)? onChanged;
  const FilterDropDownTextField({
    super.key,
    this.value,
    this.items,
    this.onChanged,
    this.heading = "No Heading",
  });
//
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: stylePTSansRegular(),
        ),
        const SpacerVertical(height: 5),
        DropdownButtonFormField<KeyValueElement>(
          style: stylePTSansRegular(color: ThemeColors.background),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.sp, vertical: 13.sp),
            fillColor: ThemeColors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.sp),
              borderSide: const BorderSide(color: ThemeColors.greyBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.sp),
              borderSide: const BorderSide(color: ThemeColors.accent),
            ),
          ),
          value: value,
          items: items?.toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
