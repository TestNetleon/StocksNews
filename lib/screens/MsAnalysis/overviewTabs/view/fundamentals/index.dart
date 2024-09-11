import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/container.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/header.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../../providers/stockAnalysis/provider.dart';
import 'footer.dart';
import 'header.dart';

class MsFundamental extends StatefulWidget {
  const MsFundamental({super.key});

  @override
  State<MsFundamental> createState() => _MsFundamentalState();
}

class _MsFundamentalState extends State<MsFundamental> {
  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return MsOverviewContainer(
      open: provider.openFundamentals,
      baseChild: Padding(
        padding: const EdgeInsets.all(12),
        // child: MsOverviewHeader(
        //   open: provider.openPerformance,
        //   onTap: provider.openFundamentalsStatus,
        //   leadingIcon: Icons.note_add_sharp,
        //   label: 'Fundamentals',
        // ),
        child: MsOverviewHeader(
          leadingIcon: Icons.pie_chart,
          label: "Fundamentals",
          stateKey: MsProviderKeys.fundamentals,
        ),
      ),
      animatedChild: const Column(
        children: [
          SpacerVertical(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: MsFundamentalHeader(),
          ),
          MsFundamentalFooter(),
        ],
      ),
    );
  }
}
