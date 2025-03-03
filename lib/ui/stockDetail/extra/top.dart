import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';

class SDTopCards extends StatelessWidget {
  final BaseKeyValueRes top;
  final Color? valueColor;

  const SDTopCards({
    super.key,
    required this.top,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBorderContainer(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: top.title != null && top.title != '',
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                top.title?.toUpperCase() ?? "N/A",
                textAlign: TextAlign.center,
                style: styleBaseRegular(
                    fontSize: 13, color: ThemeColors.neutral80),
              ),
            ),
          ),
          Visibility(
            visible: top.value != null && top.value != '',
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                "${top.value ?? "N/A"}",
                style: styleBaseBold(
                  fontSize: 16,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ),
          ),
          Visibility(
            visible: top.subTitle != null && top.subTitle != '',
            child: Text(
              top.subTitle ?? "N/A",
              style:
                  styleBaseRegular(fontSize: 13, color: ThemeColors.neutral40),
            ),
          ),
        ],
      ),
    );
  }
}
