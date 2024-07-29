import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';

class StocksList extends StatefulWidget {
  const StocksList({super.key});

  @override
  State<StocksList> createState() => _StocksListState();
}

class _StocksListState extends State<StocksList> {
  List<Map<String, dynamic>> story = [
    // {
    //   "title": "Buy More".toUpperCase(),
    //   "logo": "assets/images/math.png",
    // },
    {
      "title": "MSFT",
      "logo": "assets/images/msft.png",
    },
    {
      "title": "META",
      "logo": "assets/images/fb.png",
    },
    {
      "title": "SPOT",
      "logo": "assets/images/spot.png",
    },
    {
      "title": "AMZN",
      "logo": "assets/images/amzn.png",
    },
    {
      "title": "NFlX",
      "logo": "assets/images/word.png",
    },
    {
      "title": "SPOT",
      "logo": "assets/images/spot.png",
    },
    {
      "title": "AMZN",
      "logo": "assets/images/amzn.png",
    },
    {
      "title": "NFLX",
      "logo": "assets/images/word.png",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: ListView.builder(
          itemCount: story.length,
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(right: 10.0),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Image.asset(story[index]["logo"].toString()),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                      story[index]['title']
                          .toString(), // Display the overall value here
                      style: stylePTSansBold()),
                ],
              ),
            );
          }),
    );
  }
}
