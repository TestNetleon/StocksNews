import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';

import '../../../managers/stockDetail/stock.detail.dart';
import '../../../models/stockDetail/earning.dart';
import '../../../utils/constants.dart';
import '../../base/base_list_divider.dart';
import 'estimate_item.dart';

class SDEarningsEstimates extends StatelessWidget {
  final SDEpsEstimatesRes? epsEstimates;
  const SDEarningsEstimates({super.key, this.epsEstimates});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    List<SDEpsEstimatesDataRes>? list = epsEstimates?.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: epsEstimates?.title,
          margin: EdgeInsets.only(
            top: Pad.pad10,
            left: Pad.pad16,
            right: Pad.pad16,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            SDEpsEstimatesDataRes? data = list?[index];
            if (data == null) {
              return SizedBox();
            }
            bool isOpen = manager.openEarnings == index;

            return EarningsEstimatesItem(
              data: data,
              isOpen: isOpen,
              onTap: () => manager.openEarningsIndex(isOpen ? -1 : index),
            );
          },
          itemCount: list?.length ?? 0,
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
        ),
      ],
    );
  }
}
