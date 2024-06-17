import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';

//
class ThemeInputField extends StatelessWidget {
  const ThemeInputField({
    this.controller,
    this.keyboardType = TextInputType.name,
    this.maxLength = 40,
    this.borderRadius = 4,
    this.borderRadiusOnly,
    this.minLines = 1,
    this.editable = true,
    this.shadow = true,
    this.filled = false,
    this.fillColor = Colors.white,
    this.isUnderline = true,
    this.borderColor,
    this.placeholder,
    this.label,
    this.style,
    this.child,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLength;
  final int minLines;
  final bool editable;
  final bool shadow;
  final bool filled;
  final bool isUnderline;
  final BorderRadius? borderRadiusOnly;
  final TextStyle? style;
  final Color? borderColor;
  final double borderRadius;
  final Color fillColor;
  final String? placeholder;
  final String? label;
  final Widget? child;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = isUnderline
        ? UnderlineInputBorder(
            borderRadius:
                borderRadiusOnly ?? BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor ?? Colors.grey[300]!,
              width: 1,
            ),
          )
        : InputBorder.none;
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
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
          child ??
              TextField(
                onChanged: onChanged,
                textInputAction: textInputAction,
                controller: controller,
                keyboardType: keyboardType,
                maxLength: maxLength,
                minLines: minLines,
                maxLines: minLines,
                enabled: editable,
                textCapitalization: textCapitalization,
                inputFormatters: inputFormatters ?? [allSpecialSymbolsRemove],
                style: style ?? stylePTSansRegular(color: Colors.black),
                decoration: InputDecoration(
                  hintText: placeholder ?? '',
                  hintStyle: stylePTSansRegular(color: ThemeColors.dividerDark),
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: minLines > 1 ? 150.sp : 50.sp,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(
                    10.sp,
                    10.sp,
                    12.sp,
                    10.sp,
                  ),
                  filled: true,
                  fillColor: fillColor,
                  enabledBorder: outlineInputBorder,
                  border: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  counterText: '',
                ),
              ),
        ],
      ),
    );
  }
}
