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
    this.filled = false,
    this.placeholder,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction,
    this.onChanged,
    this.contentPadding,
    this.focusNode,
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
  final BorderRadius? borderRadiusOnly;
  final double borderRadius;
  final String? placeholder;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = OutlineInputBorder(
      borderRadius: borderRadiusOnly ?? BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: ThemeColors.neutral80,
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
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters ?? [allSpecialSymbolsRemove],
      style: stylePTSansRegular(fontSize: 16),
      decoration: InputDecoration(
        labelText: placeholder,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: stylePTSansRegular(),
        contentPadding:
            contentPadding ?? EdgeInsets.symmetric(horizontal: Pad.pad16),
        filled: true,
        fillColor: ThemeColors.white,
        enabledBorder: outlineInputBorder,
        border: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        counterText: '',
      ),
    );
  }
}
