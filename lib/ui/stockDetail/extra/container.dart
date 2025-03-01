import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_horizontal.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../base/border_container.dart';

//MARK: Column
class SDColumnContainer extends StatelessWidget {
  final String label;
  final String? value;
  final EdgeInsetsGeometry? padding;
  const SDColumnContainer({
    super.key,
    required this.label,
    this.value,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value == '') return SizedBox();
    return BaseBorderContainer(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: styleBaseRegular(color: ThemeColors.neutral80),
          ),
          SpacerVertical(height: 6),
          Text(
            value ?? '',
            style: styleBaseSemiBold(),
          ),
        ],
      ),
    );
  }
}

//MARK:Row
class SDRowContainer extends StatelessWidget {
  final String label;
  final String? value;
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  final bool showArrow;
  const SDRowContainer({
    super.key,
    required this.label,
    this.value,
    this.padding,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value == '') return SizedBox();
    return BaseBorderContainer(
      onTap: onTap,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: styleBaseRegular(color: ThemeColors.neutral80),
          ),
          SpacerHorizontal(width: 8),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value ?? '',
                    textAlign: TextAlign.end,
                    style: styleBaseSemiBold(),
                  ),
                ),
                Visibility(
                  visible: showArrow,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Image.asset(
                      Images.moreItem,
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
