import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../../models/stockDetail/overview.dart';
import '../../../../widgets/linear_bar.dart';

class SDStocksAnalysisBasicData extends StatelessWidget {
  final List<BaseKeyValueRes>? basicData;
  const SDStocksAnalysisBasicData({super.key, this.basicData});

  @override
  Widget build(BuildContext context) {
    if (basicData == null || basicData?.isEmpty == true) {
      return SizedBox();
    }
    return Column(
      children: List.generate(
        basicData?.length ?? 0,
        (index) {
          BaseKeyValueRes? data = basicData?[index];
          if (data == null) {
            return SizedBox();
          }

          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Pad.pad16,
                  vertical: Pad.pad10,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      data.title ?? '',
                      style: styleBaseRegular(
                        color: ThemeColors.neutral40,
                        fontSize: 13,
                      ),
                    )),
                    Expanded(
                      flex: 2,
                      child: LinearBarCommon(
                        value: data.value ?? 0,
                      ),
                    ),
                  ],
                ),
              ),
              BaseListDivider(),
            ],
          );
        },
      ),
    );
  }
}
