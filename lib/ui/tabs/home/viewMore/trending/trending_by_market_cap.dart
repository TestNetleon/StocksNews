import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/trending_view_all.dart';
import 'package:stocks_news_new/models/trending_by_cap_res.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class TrendingByMarketCap extends StatefulWidget {
  const TrendingByMarketCap({super.key});

  @override
  State<TrendingByMarketCap> createState() => _TrendingByMarketCapState();
}

class _TrendingByMarketCapState extends State<TrendingByMarketCap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    TrendingViewAllManager manager = context.read<TrendingViewAllManager>();
    manager.getTrendingByMarketCap();
  }

  @override
  Widget build(BuildContext context) {
    TrendingViewAllManager manager = context.watch<TrendingViewAllManager>();
    return BaseLoaderContainer(
      isLoading: manager.isLoadingByMarketCap,
      hasData: manager.dataByMarketCap != null && !manager.isLoadingByMarketCap,
      showPreparingText: true,
      error: manager.errorByMarketCap,
      onRefresh: _callAPI,
      child: BaseLoadMore(
        onLoadMore: () async {},
        onRefresh: _callAPI,
        canLoadMore: false,
        child: (manager.dataByMarketCap == null ||
                manager.dataByMarketCap?.data == null)
            ? const SizedBox()
            : (manager.dataByMarketCap == null ||
                    manager.dataByMarketCap?.data == null)
                ? const SizedBox()
                : ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return MarketCapItem(
                        data: manager.dataByMarketCap!.data[index],
                        onRefresh: _callAPI,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: BaseListDivider(),
                      );
                    },
                    itemCount: manager.dataByMarketCap?.data.length ?? 0,
                  ),
      ),
    );
  }
}

class MarketCapItem extends StatelessWidget {
  const MarketCapItem({
    super.key,
    required this.data,
    required this.onRefresh,
  });

  final MarketCapData data;
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    TrendingViewAllManager manager = context.watch<TrendingViewAllManager>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  data.title ?? "",
                  style: styleBaseBold(fontSize: 14),
                ),
              ),
              Flexible(
                child: Text(
                  data.subtitle ?? "",
                  style: styleBaseBold(fontSize: 14),
                ),
              )
            ],
          ),
        ),
        BaseListDivider(),
        if (data.data != null && (data.data?.length ?? 0) > 0)
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return BaseStockAddItem(
                data: data.data![index],
                index: index,
                onRefresh: onRefresh,
                manager: manager,
              );
            },
            separatorBuilder: (context, index) {
              return BaseListDivider();
            },
            itemCount: data.data?.length ?? 0,
          ),
        if (data.data == null || (data.data?.length ?? 0) == 0)
          Padding(
            padding: const EdgeInsets.all(Pad.pad16),
            child: Text(
              data.noDataMessage ?? "",
              style: styleBaseBold(fontSize: 14),
            ),
          ),
      ],
    );
  }
}
