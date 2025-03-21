import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/exchange/widget/crypto_tables.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class SpotIndex extends StatefulWidget {
  const SpotIndex({super.key});

  @override
  State<SpotIndex> createState() => _SpotIndexState();
}

class _SpotIndexState extends State<SpotIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    BillionairesManager manager = context.read<BillionairesManager>();
    manager.getCryptoExchange(type: "spot");
  }

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return BaseLoaderContainer(
      hasData: manager.cryptoExchangeRes != null,
      isLoading: manager.isLoadingExchange,
      error: manager.error,
      showPreparingText: true,
      onRefresh: manager.getCryptoExchange,
      child: BaseLoadMore(
        onRefresh: manager.getCryptoExchange,
        onLoadMore: () async => manager.getCryptoExchange(loadMore: true),
        canLoadMore: manager.canLoadMore,
        child: CryptoTables(exchanges:manager.cryptoExchangeRes?.data),
      ),
    );
  }
}
