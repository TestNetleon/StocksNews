import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';

class ThemeInputFieldClickable extends StatelessWidget {
  const ThemeInputFieldClickable({
    required this.controller,
    required this.onTap,
    this.keyboardType = TextInputType.name,
    this.maxLength = 40,
    this.minLines = 1,
    this.editable = true,
    this.shadow = true,
    this.filled = false,
    this.isUnderline = true,
    this.borderColor,
    this.placeholder,
    this.label,
    this.style,
    this.child,
    this.textCapitalization = TextCapitalization.sentences,
    super.key,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLength;
  final int minLines;
  final bool editable;
  final bool shadow;
  final bool filled;
  final bool isUnderline;
  final TextStyle? style;
  final Color? borderColor;
  final String? placeholder;
  final String? label;
  final Widget? child;
  final Function() onTap;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = isUnderline
        ? UnderlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? Colors.grey[300]!,
              width: 1,
            ),
          )
        : InputBorder.none;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: label != null,
            child: Text(
              label ?? '',
              style: stylePTSansBold(),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: child ??
                    TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      maxLength: maxLength,
                      minLines: minLines,
                      maxLines: minLines,
                      enabled: false,
                      textCapitalization: textCapitalization,
                      style: style ?? stylePTSansRegular(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: placeholder ?? '',
                        hintStyle: stylePTSansRegular(
                            color: Colors.grey, fontSize: 16),
                        constraints: BoxConstraints(
                          minHeight: 0,
                          maxHeight: minLines > 1 ? 150 : 50,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(
                          0.sp,
                          0.sp,
                          0.sp,
                          0.sp,
                          // horizontal: 8.sp,
                          // vertical: 5.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: outlineInputBorder,
                        border: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                        counterText: '',
                      ),
                    ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey,
              )
            ],
          ),
          Visibility(
            visible: isUnderline,
            child: Divider(
              color: borderColor ?? Colors.grey[300]!,
              height: 1,
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
