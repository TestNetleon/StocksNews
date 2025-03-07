import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/base_faq.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../models/stockDetail/ownership.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_gridview.dart';
import '../extra/top.dart';
import 'history.dart';

class SDOwnership extends StatelessWidget {
  const SDOwnership({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();

    List<BaseKeyValueRes>? top = manager.dataOwnership?.top;

    OwnershipListRes? ownershipList = manager.dataOwnership?.ownershipList;
    BaseFaqRes? faqs = manager.dataOwnership?.faq;

    return BaseLoaderContainer(
      hasData: manager.dataOwnership != null,
      isLoading: manager.isLoadingOwnership,
      error: manager.errorOwnership,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: manager.onSelectedTabRefresh,
        margin: EdgeInsets.zero,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
            child: CustomGridView(
              length: top?.length ?? 0,
              paddingHorizontal: 0,
              paddingVertical: Pad.pad16,
              itemSpace: Pad.pad16,
              getChild: (index) {
                BaseKeyValueRes? data = top?[index];
                if (data == null) {
                  return SizedBox();
                }
                String subTitle = data.subTitle ?? '';

                return SDTopCards(
                  top: data,
                  subTitleColor: subTitle.contains('-')
                      ? ThemeColors.error120
                      : ThemeColors.success120,
                );
              },
            ),
          ),
          OwnershipHistory(ownershipList: ownershipList),
          BaseFaq(faqs:faqs),
        ],
      ),
    );
  }
}
