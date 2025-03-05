import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import '../../../managers/stockDetail/stock.detail.dart';
import '../../../models/stockDetail/ownership.dart';
import '../../../utils/constants.dart';
import '../../base/base_list_divider.dart';
import '../extra/list_heading.dart';
import 'item.dart';

class OwnershipHistory extends StatelessWidget {
  final OwnershipListRes? ownershipList;
  const OwnershipHistory({super.key, this.ownershipList});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    List<OwnershipDataRes>? list = ownershipList?.data;
    if (list == null || list.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: ownershipList?.title,
          margin: EdgeInsets.only(
            top: Pad.pad24,
            left: Pad.pad16,
            right: Pad.pad16,
          ),
        ),
        SDListHeading(
          data: [
            'Share Holder Name\nReporting Date',
            'Shares Held\nChange in Shares %'
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            OwnershipDataRes? data = list[index];

            bool isOpen = manager.openOwnership == index;

            return OwnershipHistoryItem(
              data: data,
              isOpen: isOpen,
              onTap: () => manager.openOwnershipIndex(isOpen ? -1 : index),
            );
          },
          itemCount: list.length,
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
        ),
      ],
    );
  }
}
