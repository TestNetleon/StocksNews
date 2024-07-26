import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stocks_news_new/utils/theme.dart';

class PastVolumne extends StatelessWidget {
  const PastVolumne({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    List<Map<String, dynamic>> patVolumne = [
      {
        "title": "Prev Day",
        "amount": "10.0%",
      },
      {
        "title": "1 week avg",
        "amount": "41.4%",
      },
      {"title": "1 month avg", "amount": "39.7%"},
      {"title": "3 months avg", "amount": "26.4%"},
      {"title": "1 year avg", "amount": "50.67%"},
    ];

    double _parsePercentage(String percentage) {
      final cleanedPercentage = percentage.replaceAll('%', '');
      return double.tryParse(cleanedPercentage)! / 100;
    }

    return Column(
      children: [
        ListView.builder(
            itemCount: patVolumne.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var item = patVolumne[index];
              double percentage =
                  double.parse(item['amount'].replaceAll('%', '')) / 100;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        textAlign: TextAlign.center,
                        "${patVolumne[index]['title']}",
                        style: stylePTSansRegular(
                          // color: Colors.black,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // SpacerHorizontal(
                  //   width: 10.0,
                  // ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: LinearPercentIndicator(
                        width: 220.0,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 10.0,
                        percent: percentage,
                        center: Text(
                          "${patVolumne[index]['amount']}",
                          style: stylePTSansBold(
                            // color: Colors.black,
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                        linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Color.fromARGB(255, 240, 132, 9),
                      ),
                    ),
                  ),
                ],
              );
            })
      ],
    );
  }
}
