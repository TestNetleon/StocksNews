import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/compareNew/analysis/item.dart';

import '../../../../providers/compare_stocks_provider.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../widgets/box.dart';

class CompareNewAnalysis extends StatefulWidget {
  const CompareNewAnalysis({super.key});

  @override
  State<CompareNewAnalysis> createState() => _CompareNewAnalysisState();
}

class _CompareNewAnalysisState extends State<CompareNewAnalysis> {
  bool overall = false;
  bool fundamental = false;
  bool shortTerm = false;
  bool longTerm = false;
  bool analystRanking = false;
  bool valuation = false;

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          CompareNewBox(
            title: "Overall",
            onTap: () {
              overall = !overall;
              setState(() {});
            },
            open: overall,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    provider.company.length,
                    (index) => CompareNewAnalysisItem(
                      index: index,
                      value: provider.company[index].overallPercent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Fundamental",
            onTap: () {
              fundamental = !fundamental;
              setState(() {});
            },
            open: fundamental,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    provider.company.length,
                    (index) => CompareNewAnalysisItem(
                      index: index,
                      value: provider.company[index].fundamentalPercent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Short-Term Technical",
            onTap: () {
              shortTerm = !shortTerm;
              setState(() {});
            },
            open: shortTerm,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    provider.company.length,
                    (index) => CompareNewAnalysisItem(
                      index: index,
                      value: provider.company[index].shortTermPercent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Long-Term Technical",
            onTap: () {
              longTerm = !longTerm;
              setState(() {});
            },
            open: longTerm,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    provider.company.length,
                    (index) => CompareNewAnalysisItem(
                      index: index,
                      value: provider.company[index].longTermPercent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Analyst Ranking",
            onTap: () {
              analystRanking = !analystRanking;
              setState(() {});
            },
            open: analystRanking,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    provider.company.length,
                    (index) => CompareNewAnalysisItem(
                      index: index,
                      value: provider.company[index].analystRankingPercent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Valuation",
            onTap: () {
              valuation = !valuation;
              setState(() {});
            },
            open: valuation,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    provider.company.length,
                    (index) => CompareNewAnalysisItem(
                      index: index,
                      value: provider.company[index].valuationPercent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
