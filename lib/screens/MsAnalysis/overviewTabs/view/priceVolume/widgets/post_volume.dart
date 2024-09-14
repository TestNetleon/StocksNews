import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stocks_news_new/utils/theme.dart';

class MsPricePostVolume extends StatelessWidget {
  const MsPricePostVolume({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    List<Map<String, dynamic>> postVolume = [
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

    // double _parsePercentage(String percentage) {
    //   final cleanedPercentage = percentage.replaceAll('%', '');
    //   return double.tryParse(cleanedPercentage)! / 100;
    // }

    return Column(
      children: [
        ListView.builder(
          itemCount: postVolume.length,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            var item = postVolume[index];

            return MsPricePostVolumeItem(data: item);
          },
        ),
      ],
    );
  }
}

class MsPricePostVolumeItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const MsPricePostVolumeItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double percentage = double.parse(data['amount'].replaceAll('%', '')) / 100;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            textAlign: TextAlign.start,
            "${data['title']}",
            style: stylePTSansRegular(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: LinearPercentIndicator(
              width: 220.0,
              animation: true,
              animationDuration: 1000,
              lineHeight: 10.0,
              percent: percentage,
              center: Text(
                "${data['amount']}",
                style: stylePTSansBold(
                  // color: Colors.black,
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
              progressColor: Color.fromARGB(255, 240, 132, 9),
            ),
          ),
        ),
      ],
    );
  }
}
