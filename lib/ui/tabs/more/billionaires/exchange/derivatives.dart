import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/exchange/widget/crypto_tables.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class DerivativesIndex extends StatefulWidget {
  const DerivativesIndex({super.key});

  @override
  State<DerivativesIndex> createState() => _DerivativesIndexState();
}

class _DerivativesIndexState extends State<DerivativesIndex> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    BillionairesManager manager = context.read<BillionairesManager>();
    manager.getCryptoExchange(type: "derivatives");
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
