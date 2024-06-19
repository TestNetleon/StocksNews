import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';

//
class ThemeCheckbox extends StatelessWidget {
  const ThemeCheckbox({
    required this.value,
    required this.onChanged,
    this.color,
    super.key,
  });
  final bool value;
  final Color? color;
  final Function(bool newValue) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: Checkbox(
        value: value,
        onChanged: (value) => onChanged(value ?? false),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        activeColor: ThemeColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: color ?? ThemeColors.primary, width: 1.sp),
        ),
      ),
    );
  }

  BorderSide getBorder(Set<WidgetState> states) {
    return BorderSide(
      color: color ?? Colors.black,
      width: 1.sp,
      style: BorderStyle.solid,
    );
  }
}
