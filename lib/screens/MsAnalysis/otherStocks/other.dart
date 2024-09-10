import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/watchlist_res.dart';
import 'package:stocks_news_new/providers/watchlist_provider.dart';
import '../widget/title_tag.dart';
import 'item.dart';

class MsOtherStocks extends StatefulWidget {
  const MsOtherStocks({super.key});

  @override
  State<MsOtherStocks> createState() => _MsOtherStocksState();
}

class _MsOtherStocksState extends State<MsOtherStocks> {
  @override
  Widget build(BuildContext context) {
    WatchlistProvider provider = context.watch<WatchlistProvider>();

    if (provider.data == null || provider.data?.isEmpty == true) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MsTitle(title: "Your Other Stocks"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: List.generate(
              provider.data?.length ?? 0,
              (index) {
                WatchlistData? data = provider.data?[index];
                if (data == null) {
                  return SizedBox();
                }
                return MsOtherStockItem(data: data);
              },
            ),
          ),
        ),
      ],
    );
  }
}
