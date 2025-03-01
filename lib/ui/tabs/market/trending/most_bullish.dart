import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/most_bullish.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/stock/slidable_add.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class MostBullish extends StatefulWidget {
  const MostBullish({super.key});

  @override
  State<MostBullish> createState() => _MostBullishState();
}

class _MostBullishState extends State<MostBullish> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    MostBullishManager provider = context.read<MostBullishManager>();
    provider.getData();
  }

  @override
  Widget build(BuildContext context) {
    MostBullishManager provider = context.watch<MostBullishManager>();
    return BaseLoaderContainer(
      isLoading: provider.isLoading,
      hasData: provider.data != null && !provider.isLoading,
      showPreparingText: true,
      error: provider.error,
      onRefresh: () {},
      child: (provider.data == null || provider.data?.mostBullish == null)
          ? const SizedBox()
          : ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SlidableStockAddItem(
                  data: provider.data!.mostBullish![index],
                  index: index,
                );
              },
              separatorBuilder: (context, index) {
                return BaseListDivider();
              },
              itemCount: provider.data!.mostBullish?.length ?? 0,
            ),
    );
  }
}
