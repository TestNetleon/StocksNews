import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/base/base_faq.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import '../../../models/stockDetail/overview.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_gridview.dart';
import '../../base/base_scroll.dart';
import '../extra/top.dart';
import 'insider_history.dart';

class SDInsiderTrades extends StatelessWidget {
  const SDInsiderTrades({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();

    List<BaseKeyValueRes>? top = manager.dataInsiderTrade?.top;

    InsiderTradeListRes? insiderData = manager.dataInsiderTrade?.insiderData;
    BaseFaqRes? faqs = manager.dataInsiderTrade?.faq;

    return BaseLoaderContainer(
      hasData: manager.dataInsiderTrade != null,
      isLoading: manager.isLoadingInsiderTrade,
      error: manager.errorInsiderTrade,
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
                return SDTopCards(top: data);
              },
            ),
          ),
          InsiderHistory(insiderData: insiderData),
          BaseFaq(faqs: faqs),
          // SDDividendsHistory(dividendHistory: dividendHistory),
          // SDDividendsHistory(earningHistory: earningHistory),
          // SDDividendsEstimates(epsEstimates: epsEstimates),
        ],
      ),
    );
  }
}
