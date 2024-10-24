import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/msAnalysis/complete.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/container.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/header.dart';
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

    List<String>? header = provider.completeData?.fundamentals?.header;
    List<MsFundamentalsResBody>? body =
        provider.completeData?.fundamentals?.body;

    return MsOverviewContainer(
      open: provider.openFundamentals,
      baseChild: Padding(
        padding: const EdgeInsets.all(12),
        child: MsOverviewHeader(
          leadingIcon: Icons.file_open_sharp,
          label: provider.completeData?.overviewText?.fundamentals?.title ??
              "Fundamentals",
          stateKey: MsProviderKeys.fundamentals,
          showInfo: provider.completeData?.overviewText?.fundamentals?.info,
        ),
      ),
      animatedChild: Column(
        children: [
          Visibility(
            visible: header != null && header.isNotEmpty == true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: MsFundamentalHeader(
                header: header,
              ),
            ),
          ),
          Visibility(
            visible: body != null && body.isNotEmpty == true,
            child: MsFundamentalFooter(body: body),
          ),
        ],
      ),
    );
  }
}
