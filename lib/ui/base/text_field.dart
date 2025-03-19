import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';

//
class BaseTextField extends StatelessWidget {
  const BaseTextField({
    this.controller,
    this.keyboardType = TextInputType.name,
    this.maxLength = 40,
    this.borderRadius = 8,
    this.borderRadiusOnly,
    this.minLines = 1,
    this.maxLines,
    this.editable = true,
    this.shadow = true,
    this.filled = true,
    this.placeholder,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction,
    this.onChanged,
    this.contentPadding,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    super.key,
    this.hintText,
    this.fillColor,
  });

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLength;
  final int minLines;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool editable;
  final bool shadow;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final BorderRadius? borderRadiusOnly;
  final double borderRadius;
  final String? placeholder;
  final String? hintText;

  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: borderRadiusOnly ?? BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: ThemeColors.neutral80, width: 1),
    );
    var enabledBorder = OutlineInputBorder(
      borderRadius: borderRadiusOnly ?? BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: ThemeColors.neutral10,
        width: 1,
      ),
    );

    return TextField(
      focusNode: focusNode,
      onChanged: onChanged,
      textInputAction: textInputAction,
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      enabled: editable,
      cursorColor: ThemeColors.black,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters ?? [allSpecialSymbolsRemove],
      style: styleBaseRegular(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: placeholder,
        hintText: hintText,
        hintStyle: styleBaseRegular(color: ThemeColors.neutral40),
        // floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: styleBaseRegular(color: ThemeColors.neutral60),
        contentPadding:
            contentPadding ?? EdgeInsets.symmetric(horizontal: Pad.pad16),
        filled: filled,
        fillColor: fillColor ?? (ThemeColors.white),
        enabledBorder: enabledBorder,
        border: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        counterText: '',
        alignLabelWithHint: true,
      ),
    );
  }
}
