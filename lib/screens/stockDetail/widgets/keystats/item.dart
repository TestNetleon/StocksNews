import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StateItemNEW extends StatelessWidget {
  final String label;
  final String? value;
  final bool clickable;
  final bool divider;
  final void Function()? onTap;
  const StateItemNEW({
    required this.label,
    this.value,
    this.clickable = false,
    this.divider = true,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value == "") {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: stylePTSansRegular(
            fontSize: 12,
            color: ThemeColors.greyText,
          ),
        ),
        const SpacerVertical(height: 5),
        InkWell(
          onTap: onTap,
          child: Text(
            textAlign: TextAlign.start,
            value ?? "",
            style: stylePTSansRegular(
                fontSize: 13,
                color: clickable ? ThemeColors.accent : Colors.white),
          ),
        ),
      ],
    );
  }
}
