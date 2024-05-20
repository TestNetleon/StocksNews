import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/screens/stocks/container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class StocksIndex extends StatefulWidget {
  static const path = "StocksIndex";
  final String? inAppMsgId;
  const StocksIndex({this.inAppMsgId, super.key});

  @override
  State<StocksIndex> createState() => _StocksIndexState();
}

class _StocksIndexState extends State<StocksIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AllStocksProvider>().getData(
            showProgress: true,
            inAppMsgId: widget.inAppMsgId,
          );
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Stocks"},
      );
    });
  }

//
  @override
  Widget build(BuildContext context) {
    return const StocksContainer();
  }
}
