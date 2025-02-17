import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/signals/sentiment/most_mentions.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../../../../widgets/custom/base_loader_container.dart';
import 'recent_mentions.dart';
import 'sentiment_gauge.dart';

class SignalSentimentIndex extends StatefulWidget {
  const SignalSentimentIndex({super.key});

  @override
  State<SignalSentimentIndex> createState() => _SignalSentimentState();
}

class _SignalSentimentState extends State<SignalSentimentIndex> {
  @override
  Widget build(BuildContext context) {
    SignalsManager manager = context.watch<SignalsManager>();

    return BaseLoaderContainer(
      isLoading: manager.isLoadingSentiment,
      hasData: manager.signalSentimentData != null,
      showPreparingText: true,
      error: manager.errorSentiment,
      child: BaseScroll(
        margin: EdgeInsets.zero,
        onRefresh: manager.getSignalSentimentData,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
            child: SignalsSentimentGauge(),
          ),
          SignalMostMentions(),
          SignalRecentMentions(),
        ],
      ),
    );
  }
}

class SignalMentionStockRes {
  String label;
  num value;
  SignalMentionStockRes({
    required this.label,
    required this.value,
  });
}
