import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';

class SDTopCards extends StatelessWidget {
  final BaseKeyValueRes top;
  final Color? valueColor;
  final Color? subTitleColor;

  const SDTopCards({
    super.key,
    required this.top,
    this.valueColor,
    this.subTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBorderContainer(
      padding: EdgeInsets.zero,
      child: Consumer<ThemeManager>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: top.title != null && top.title != '',
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    top.title ?? "N/A",
                    textAlign: TextAlign.center,
                    style: styleBaseRegular(
                      fontSize: 13,
                      color: ThemeColors.neutral80,
                    ),
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
                      color: valueColor ??
                          (value.isDarkMode ? ThemeColors.white : Colors.black),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: top.subTitle != null && top.subTitle != '',
                child: Text(
                  top.subTitle ?? "N/A",
                  style: styleBaseRegular(
                    fontSize: 13,
                    color: subTitleColor ?? ThemeColors.neutral40,
                  ),
                ),
              ),
              Visibility(
                visible: top.other != null && top.other != '',
                child: Text(
                  top.other ?? "N/A",
                  style: styleBaseRegular(
                    fontSize: 13,
                    color: subTitleColor ?? ThemeColors.neutral40,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
