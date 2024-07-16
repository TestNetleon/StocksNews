import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StoreEarnMore extends StatefulWidget {
  const StoreEarnMore({super.key});

  @override
  State<StoreEarnMore> createState() => _StoreEarnMoreState();
}

class _StoreEarnMoreState extends State<StoreEarnMore> {
  // final List<String> items =
  // [
  //   'You can earn points by daily activities on app',
  //   'You can earn points by refer you friends.',
  //   'You can earn points by daily activities on app',
  // ];
  List items = [
    {
      "icon": Images.advisor,
      "title": "Refer a Friend to Stocks.News",
      "text":
          "Refer a friend to Stocks.news and earn 5 points for each verified referral!",
    },
    {
      "icon": Images.advisor,
      "title": "Sync portfolio and earn",
      "text":
          "Connect your broker and sync your portfolio to earn 10 points instantly!",
    },
    {
      "icon": Images.advisor,
      "title": "Daily Sign-In Rewards",
      "text":
          "Sign in daily on the app and earn 2 points each day to boost your rewards!",
    },
    {
      "icon": Images.advisor,
      "title": "Complete Your Profile and Earn",
      "text":
          "Complete your profile to earn 2 points and enhance your experience!",
    },
  ];
  double _currentHeight = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _currentHeight = calculateItemHeight(items[0]);
      },
    );
  }

  // double calculateHeight(Map<String, String> item) {
  //   return 125.0 + item.length * 0.50;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More ways to earn points',
          style: stylePTSansBold(fontSize: 26, color: Colors.black),
        ),
        const SpacerVertical(
          height: 10,
        ),
        CarouselSlider.builder(
          options: CarouselOptions(
            // height: 100, //_currentHeight
            height: _currentHeight,
            enlargeCenterPage: true,
            autoPlay: true,
            // aspectRatio: 12 / 9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentHeight = calculateItemHeight(items[index]);
                log("CALCULATED HEIGHT => $_currentHeight");
              });
              // setState(() {
              //   _currentHeight = calculateHeight(items[index]);
              //   print('mylist');
              // });
            },
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeFactor: .1,
            pauseAutoPlayOnTouch: true,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 1,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 200, 250, 203),
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index]["title"],
                          textAlign: TextAlign.start,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: stylePTSansBold(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Text(
                          items[index]["text"],
                          textAlign: TextAlign.start,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: stylePTSansRegular(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    items[index]["icon"],
                    width: 60,
                    height: 60,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  double calculateItemHeight(Map<String, String> item) {
    // Adjust padding and other factors as needed
    double titleHeight =
        calculateTextHeight(item["title"]!, 18, FontWeight.bold);
    double textHeight =
        calculateTextHeight(item["text"]!, 16, FontWeight.normal);
    return titleHeight + textHeight + 24.0 + 10; // Add padding and margins
  }

  double calculateTextHeight(
      String text, double fontSize, FontWeight fontWeight) {
    TextSpan span = TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width - (60 + 32 + 24));
    return tp.height;
  }
}
