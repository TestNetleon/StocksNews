import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/sentiment.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/signals/sentiment/most_mentions.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../../../../widgets/custom/base_loader_container.dart';
import '../../../base/lock.dart';
import 'recent_mentions.dart';
import 'sentiment_gauge.dart';

class SignalSentimentIndex extends StatefulWidget {
  const SignalSentimentIndex({super.key});

  @override
  State<SignalSentimentIndex> createState() => _SignalSentimentState();
}

class _SignalSentimentState extends State<SignalSentimentIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    SignalsSentimentManager manager = context.read<SignalsSentimentManager>();
    manager.getData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentContext!
          .read<SignalsSentimentManager>()
          .clearAllData();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignalsSentimentManager manager = context.watch<SignalsSentimentManager>();

    return Stack(
      children: [
        BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.data != null,
          showPreparingText: true,
          error: manager.error,
          child: BaseScroll(
            margin: EdgeInsets.zero,
            onRefresh: manager.getData,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                child: SignalsSentimentGauge(),
              ),
              SignalMostMentions(),
              SignalRecentMentions(),
            ],
          ),
        ),
        BaseLockItem(manager: manager, callAPI: manager.getData),
      ],
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
