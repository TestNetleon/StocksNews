import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/container.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/header.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../../../providers/stockAnalysis/provider.dart';
import 'widget/tabs.dart';

class MsShareholdings extends StatefulWidget {
  const MsShareholdings({super.key});

  @override
  State<MsShareholdings> createState() => _MsShareholdingsState();
}

class _MsShareholdingsState extends State<MsShareholdings>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: month.length, vsync: this);
  }

  List<String> month = [
    'Mar 24',
    'Dec 23',
    'Sep 23',
    'Jun 23',
    'Mar 23',
    'Dec 22',
  ];

  int _selectedIndex = 0;
  onChange(int value) {
    _selectedIndex = value;
    setState(() {});
  }

  final List<HoldingData> _holdingsData = [
    HoldingData(
      title: "Promoter",
      percent: 59.91,
      subPercent: '0%',
      color: Colors.pink,
    ),
    HoldingData(
      title: "FII",
      percent: 25.8,
      subPercent: '0%',
      color: Colors.green,
    ),
    HoldingData(
      title: "Domestic Institution",
      percent: 0.02,
      subPercent: '0%',
      color: Colors.yellow,
    ),
    HoldingData(
      title: "Retails And Others",
      percent: 40.05,
      subPercent: '0%',
      color: Colors.orange,
    ),
  ];

  final progress = [Colors.accents, Colors.green, Colors.yellow, Colors.orange];

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return MsOverviewContainer(
      open: provider.openShareholdings,
      baseChild: Padding(
        padding: const EdgeInsets.all(12.0),
        child: MsOverviewHeader(
          leadingIcon: Icons.pie_chart,
          label: "Shareholdings",
          onTap: provider.openShareholdingsStatus,
        ),
      ),
      animatedChild: Column(
        children: [
          MsShareholdingsTab(
            selectedIndex: _selectedIndex,
            tabs: month,
            controller: controller,
            onTap: (index) {
              _selectedIndex = index;
              setState(() {});
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _holdingsData.length,
            itemBuilder: (context, index) {
              final holding = _holdingsData[index];
              double percentage =
                  double.parse(holding.percent.toString()) / 100;
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: index == 0
                      ? null
                      : Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(holding.title.toString(),
                            style: stylePTSansRegular(
                                fontSize: 14.0, color: Colors.grey)),
                        Row(
                          children: [
                            Text(holding.subPercent.toString(),
                                style: stylePTSansRegular(
                                    fontSize: 12.0, color: Colors.green)),
                            SpacerHorizontal(
                              width: 10.0,
                            ),
                            Text(holding.percent.toString(),
                                style: stylePTSansRegular(
                                    fontSize: 12.0, color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearPercentIndicator(
                              animation: true,
                              barRadius: Radius.circular(20.0),
                              animationDuration: 1000,
                              lineHeight: 15.0,
                              percent: percentage,
                              center: Text(
                                holding.percent.toString(),
                                style: stylePTSansBold(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                              progressColor: holding.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class HoldingData {
  String? title;
  double? percent;
  String? subPercent;
  final Color color;

  HoldingData(
      {required this.title,
      required this.percent,
      required this.subPercent,
      required this.color});
}
