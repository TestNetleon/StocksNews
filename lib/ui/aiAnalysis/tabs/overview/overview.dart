import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/ui/aiAnalysis/tabs/overview/fundamental.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../models/ai_analysis.dart';
import 'financial/index.dart';
import 'performance.dart';

class AIOverview extends StatefulWidget {
  const AIOverview({super.key});

  @override
  State<AIOverview> createState() => _AIOverviewState();
}

class _AIOverviewState extends State<AIOverview> {
  bool _apiCalled = false;

  void _callApi() async {
    AIManager manager = context.read<AIManager>();
    manager.onChangeFinancial(periodIndex: 0, typeIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();

    AIPerformanceRes? performance = manager.data?.performance;
    AIFundamentalsRes? fundamentals = manager.data?.fundamentals;

    return Column(
      children: [
        AIOverviewPerformance(performance: performance),
        VisibilityDetector(
          key: Key('unique-key'),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0 && !_apiCalled) {
              _apiCalled = true;
              _callApi();
            }
          },
          child: AIOverviewFundamentals(data: fundamentals),
        ),
        AIFinancial(),
      ],
    );
  }
}
