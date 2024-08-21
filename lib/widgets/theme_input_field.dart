import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.maxLines,
    this.editable = true,
    this.shadow = true,
    this.filled = false,
    this.fillColor = Colors.white,
    this.isUnderline = true,
    this.borderColor,
    this.placeholder,
    this.label,
    this.style,
    this.hintStyle,
    this.child,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction,
    this.onChanged,
    this.suffix,
    this.prefix,
    this.contentPadding,
    this.cursorColor,
    super.key,
  });

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLength;
  final int minLines;
  final int? maxLines;

  final bool editable;
  final bool shadow;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final bool isUnderline;
  final BorderRadius? borderRadiusOnly;
  final TextStyle? style, hintStyle;
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
  final Widget? suffix;
  final Widget? prefix;
  final Color? cursorColor;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = isUnderline
        ? UnderlineInputBorder(
            borderRadius:
                borderRadiusOnly ?? BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor ?? Colors.grey[300]!,
              width: 0.5,
            ),
          )
        : InputBorder.none;
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: borderRadiusOnly ?? BorderRadius.circular(borderRadius),
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
                cursorColor: cursorColor,
                onChanged: onChanged,
                textInputAction: textInputAction,
                controller: controller,
                keyboardType: keyboardType,
                maxLength: maxLength,
                minLines: minLines,
                maxLines: maxLines,
                enabled: editable,
                textCapitalization: textCapitalization,
                inputFormatters: inputFormatters ?? [allSpecialSymbolsRemove],
                style: style ?? stylePTSansRegular(color: Colors.black),
                decoration: InputDecoration(
                  prefix: prefix,
                  suffix: suffix,
                  hintText: placeholder ?? '',
                  hintStyle: hintStyle ??
                      stylePTSansRegular(color: ThemeColors.dividerDark),
                  // constraints: BoxConstraints(
                  //   minHeight: 0,
                  //   maxHeight: minLines > 1 ? 150.sp : 50.sp,
                  // ),
                  contentPadding: contentPadding ??
                      EdgeInsets.fromLTRB(
                        10,
                        10,
                        12,
                        10,
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
