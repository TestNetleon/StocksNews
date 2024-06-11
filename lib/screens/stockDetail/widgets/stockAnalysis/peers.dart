import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'peer_item.dart';

class SdStockPeers extends StatelessWidget {
  const SdStockPeers({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    if (provider.analysis?.peersData?.isEmpty == true ||
        provider.analysis?.peersData == null) {
      return const SizedBox();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ScreenTitle(
          title: "Stock Peers",
        ),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SdPeerItem(
              data: provider.analysis?.peersData?[index],
              index: index,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: ThemeColors.greyBorder,
              height: 15,
            );
          },
          itemCount: provider.analysis?.peersData?.length ?? 0,
        ),
        const SpacerVertical(height: 20),
      ],
    );
  }
}
