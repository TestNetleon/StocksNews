import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/ui/aiAnalysis/tabs/overview/fundamental.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../models/ai_analysis.dart';
import '../../../../models/stockDetail/financial.dart';
import '../../../../models/stockDetail/price_volume.dart';
import 'financial/index.dart';
import 'performance/index.dart';
import 'priceVolume/index.dart';

class AIOverview extends StatefulWidget {
  const AIOverview({super.key});

  @override
  State<AIOverview> createState() => _AIOverviewState();
}

class _AIOverviewState extends State<AIOverview> {
  bool _financialAPI = false;
  bool _pvAPI = false;

  void _callApiFinancial() async {
    AIManager manager = context.read<AIManager>();
    manager.onChangeFinancial(periodIndex: 0, typeIndex: 0);
  }

  void _callApiPV() async {
    AIManager manager = context.read<AIManager>();
    manager.getAiPvData(selectedIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();

    AIFundamentalsRes? fundamentals = manager.data?.fundamentals;

    AiFinancialRes? financialsData = manager.financialsData;
    AIPriceVolumeRes? dataPV = manager.dataPV;

    return Column(
      children: [
        AIPerformance(),
        VisibilityDetector(
          key: Key('p-v'),
          onVisibilityChanged: (info) {
            if (info.visibleFraction > 0 && !_pvAPI && dataPV == null) {
              _pvAPI = true;
              _callApiPV();
            }
          },
          child: AIOverviewFundamentals(data: fundamentals),
        ),
        VisibilityDetector(
            key: Key('call-financial'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0 &&
                  !_financialAPI &&
                  financialsData == null) {
                _financialAPI = true;
                _callApiFinancial();
              }
            },
            child: AIPriceVolume()),
        AIFinancial(),
      ],
    );
  }
}
