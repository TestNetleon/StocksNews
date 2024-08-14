import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ShareholdingWidget extends StatefulWidget {
  const ShareholdingWidget({super.key});

  @override
  State<ShareholdingWidget> createState() => _ShareholdingWidgetState();
}

class _ShareholdingWidgetState extends State<ShareholdingWidget> {
  List<String> month = [
    'Mar 24',
    'Dec 23',
    'Sep 23',
    'Jun 23',
    'Mar 23',
    'Dec 22',
  ];

  Map<String, List<holdingData>> childListMap = {
    "Mar 24": [
      holdingData(
          title: "Promoter",
          percent: 59.91,
          subPrecent: '0%',
          color: Colors.pink),
      holdingData(
          title: "FII", percent: 25.8, subPrecent: '0%', color: Colors.green),
      holdingData(
          title: "Demestic Instittution",
          percent: 0.02,
          subPrecent: '0%',
          color: Colors.yellow),
      holdingData(
          title: "Retails And Others",
          percent: 40.05,
          subPrecent: '0%',
          color: Colors.orange),
    ],
    "Dec 23": [
      holdingData(
          title: "Promoter",
          percent: 59.91,
          subPrecent: '0%',
          color: Colors.pink),
      holdingData(
          title: "FII", percent: 0, subPrecent: '0%', color: Colors.green),
      holdingData(
          title: "Demestic Instittution",
          percent: 0.02,
          subPrecent: '0%',
          color: Colors.yellow),
      holdingData(
          title: "Retails And Others",
          percent: 40.05,
          subPrecent: '0%',
          color: Colors.orange),
    ],
    "Sep 23": [
      holdingData(
          title: "Promoter",
          percent: 59.91,
          subPrecent: '0.03%',
          color: Colors.pink),
      holdingData(
          title: "FII", percent: 0, subPrecent: '0%', color: Colors.green),
      holdingData(
          title: "Demestic Instittution",
          percent: 0.02,
          subPrecent: '0.01%',
          color: Colors.yellow),
      holdingData(
          title: "Retails And Others",
          percent: 40.05,
          subPrecent: '0%',
          color: Colors.orange),
    ],
    "Jun 23": [
      holdingData(
          title: "Promoter",
          percent: 59.91,
          subPrecent: '0.08%',
          color: Colors.pink),
      holdingData(
          title: "FII", percent: 0, subPrecent: '0%', color: Colors.yellow),
      holdingData(
          title: "Demestic Instittution",
          percent: 0.02,
          subPrecent: '0%',
          color: Colors.orange),
      holdingData(
          title: "Retails And Others",
          percent: 40.05,
          subPrecent: '0.05%',
          color: Colors.green),
    ],
    "Mar 23": [
      holdingData(
          title: "Promoter",
          percent: 59.91,
          subPrecent: '0%',
          color: Colors.pink),
      holdingData(
          title: "FII", percent: 0, subPrecent: '0%', color: Colors.orange),
      holdingData(
          title: "Demestic Instittution",
          percent: 0.02,
          subPrecent: '0%',
          color: Colors.yellow),
      holdingData(
          title: "Retails And Others",
          percent: 40.05,
          subPrecent: '0%',
          color: Colors.green),
    ],
    "Dec 22": [
      holdingData(
          title: "Promoter",
          percent: 59.91,
          subPrecent: '0%',
          color: Colors.green),
      holdingData(
          title: "FII", percent: 0, subPrecent: '0%', color: Colors.pink),
      holdingData(
          title: "Demestic Instittution",
          percent: 0.02,
          subPrecent: '0%',
          color: Colors.orange),
      holdingData(
          title: "Retails And Others",
          percent: 40.05,
          subPrecent: '0%',
          color: Colors.yellow),
    ],
  };

  final progress = [Colors.accents, Colors.green, Colors.yellow, Colors.orange];

  int _selectedParentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpacerVertical(
          height: 8.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 53, 53, 53),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pie_chart,
                        color: Colors.orange,
                        size: 20,
                      ),
                      SpacerHorizontal(
                        width: 8.0,
                      ),
                      Text('Shareholding',
                          style: stylePTSansRegular(
                              fontSize: 20.0, color: Colors.white)),
                      SpacerHorizontal(
                        width: 8.0,
                      ),
                      Icon(
                        Icons.ac_unit_outlined,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.orange,
                    size: 30,
                  ),
                ],
              ),
              SpacerVertical(
                height: 10,
              ),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: month.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedParentIndex = index;
                            });
                          },
                          child: Container(
                            // height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: _selectedParentIndex == index
                                        ? Colors.white54
                                        : Colors.white24),
                                borderRadius: BorderRadius.circular(20.0),
                                color: _selectedParentIndex == index
                                    ? Color.fromARGB(255, 32, 33, 34)
                                    : Color.fromARGB(255, 32, 33, 34)),
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(month[index],
                                  style: stylePTSansRegular(
                                      fontSize: 14.0,
                                      color: _selectedParentIndex == index
                                          ? Colors.white
                                          : Colors.grey)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: ListView.builder(
                      itemCount:
                          childListMap[month[_selectedParentIndex]]?.length ??
                              0,
                      itemBuilder: (context, index) {
                        List<holdingData> childItem =
                            childListMap[month[_selectedParentIndex]]!;
                        final holding = childItem[index];
                        double percentage =
                            double.parse(holding.percent.toString()) / 100;
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(holding.title.toString(),
                                        style: stylePTSansRegular(
                                            fontSize: 14.0,
                                            color: Colors.grey)),
                                    Row(
                                      children: [
                                        Text(holding.subPrecent.toString(),
                                            style: stylePTSansRegular(
                                                fontSize: 12.0,
                                                color: Colors.green)),
                                        SpacerHorizontal(
                                          width: 10.0,
                                        ),
                                        Text(holding.percent.toString(),
                                            style: stylePTSansRegular(
                                                fontSize: 12.0,
                                                color: Colors.white)),
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
                                            // width: 260.0,
                                            animation: true,
                                            barRadius: Radius.circular(20.0),
                                            animationDuration: 1000,
                                            lineHeight: 15.0,
                                            // percent: holding.percent!.toDouble(),
                                            percent: percentage,
                                            center: Text(
                                              holding.percent.toString(),
                                              style: stylePTSansBold(
                                                // color: Colors.black,
                                                color: Colors.black,
                                                fontSize: 10,
                                              ),
                                            ),
                                            linearStrokeCap:
                                                // ignore: deprecated_member_use
                                                LinearStrokeCap.butt,
                                            progressColor: holding.color),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class holdingData {
  String? title;
  double? percent;
  String? subPrecent;
  final Color color;

  holdingData(
      {required this.title,
      required this.percent,
      required this.subPrecent,
      required this.color});
}
