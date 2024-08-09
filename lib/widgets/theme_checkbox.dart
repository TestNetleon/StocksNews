import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';

//
class ThemeCheckbox extends StatelessWidget {
  const ThemeCheckbox({
    required this.value,
    required this.onChanged,
    this.color,
    this.label,
    super.key,
  });
  final bool value;
  final Color? color;
  final String? label;
  final Function(bool newValue) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.black, // Color when not checked
              checkboxTheme: CheckboxThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                  side: BorderSide(color: Colors.red, width: 2.0),
                ),
                checkColor: WidgetStateProperty.all<Color>(Colors.white),
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.green; // Fill color when checked
                    }
                    return Colors.black; // Fill color when unchecked
                  },
                ),
              ),
            ),
            child: Checkbox(
              value: value,
              onChanged: (value) => onChanged(value ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        Visibility(
          visible: label != null,
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(label ?? "", style: styleGeorgiaRegular()),
            ),
          ),
        )
      ],
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
