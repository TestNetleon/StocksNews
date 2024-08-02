import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NewMembershipReviews extends StatefulWidget {
  const NewMembershipReviews({super.key});

  @override
  State<NewMembershipReviews> createState() => _NewMembershipReviewsState();
}

class _NewMembershipReviewsState extends State<NewMembershipReviews> {
  final List<String> items = [
    'adjust CarouselSlider height dynamic based on api data in flutter',
    'I want a container',
    'I want a container CarouselSlider with some static user views slide with container in flutter. '
  ];
  double _currentHeight = 100.0;

  @override
  void initState() {
    super.initState();
    _currentHeight = calculateHeight(items[0]);
  }

  double calculateHeight(String item) {
    return 125.0 + item.length * 0.50;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Trusted Views',
              style: stylePTSansBold(fontSize: 26, color: Colors.white),
            ),
          ),
          const SpacerVertical(
            height: 10,
          ),
          CarouselSlider.builder(
            options: CarouselOptions(
              height: _currentHeight,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 12 / 9,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentHeight = calculateHeight(items[index]);
                });
              },
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 1,
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    // color: Colors.grey,
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.2, 0.65],
                      colors: [
                        Color.fromARGB(255, 32, 128, 65),
                        // ThemeColors.greyBorder,
                        Color.fromARGB(255, 0, 0, 0),
                      ],
                    ),
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBar.builder(
                      initialRating: 5,
                      minRating: 5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemSize: 20,
                      unratedColor: ThemeColors.greyBorder,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: ThemeColors.white,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    const SpacerVertical(
                      height: 10,
                    ),
                    Text(items[index].toString(),
                        textAlign: TextAlign.start,
                        softWrap: true,
                        // maxLines: 3,
                        overflow: TextOverflow.fade,
                        style: stylePTSansRegular(
                            fontSize: 16, color: Colors.white)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
