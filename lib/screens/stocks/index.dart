import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/screens/stocks/container.dart';

class StocksIndex extends StatefulWidget {
  static const path = "StocksIndex";
  const StocksIndex({super.key});

  @override
  State<StocksIndex> createState() => _StocksIndexState();
}

class _StocksIndexState extends State<StocksIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AllStocksProvider>().getData(showProgress: true);
    });
  }

//
  @override
  Widget build(BuildContext context) {
    return const StocksContainer();
  }
}
