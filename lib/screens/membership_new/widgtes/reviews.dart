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
    'It’s legit I wanted to make sure the alerts were good before I started putting real money into it, so I have just been watching the companies they send the alerts out for. Since I have started paying attention, every company they have alerted has increased by a significant amount.Not only are the alerts good, but the actual news information they provide is helpful as well. I fully suggest this app.',
    'Becoming a believer I signed up to receive the stock alerts just to see If any other suggestions were good. After receiving some of their alerts decided to take a trade and made a 20% profit by the end of the week, I wish I’d stayed in the trade that would still be making money right now. I’d be up 100%. I really like receiving the alerts',
    'So far so good!I just found out about this so I’ve only received 1 tip. That 1 was a good one though! I was able to double my investment and honestly this was my first attempt at swing/day trading. I am excited for the future and am digging this app and the info it’s putting out.'
  ];
  // double _currentHeight = 100.0;

  @override
  void initState() {
    super.initState();
    // _currentHeight = calculateHeight(items[0]);
  }

  // double calculateHeight(String item) {
  //   return 120 + item.length * 0.50;
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Trusted Views',
              style: stylePTSansBold(fontSize: 18, color: Colors.white),
            ),
          ),
          const SpacerVertical(
            height: 10,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: index % 2 == 0
                    ? ThemeColors.greyText.withOpacity(0.4)
                    : ThemeColors.greyBorder.withOpacity(0.9),
                // color: ThemeColors.sos,

                child: Column(
                  children: [
                    SpacerVertical(height: 15),
                    RatingBar.builder(
                      initialRating: 4,
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
                        color: ThemeColors.sos,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    const SpacerVertical(height: 10),
                    Text(
                      "So far so good",
                      textAlign: TextAlign.center,
                      style:
                          styleSansBold(color: ThemeColors.white, fontSize: 25),
                    ),
                    const SpacerVertical(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      "I wanted to make sure the alerts were good before I started putting real money into it, so I have just been watching the companies they send the alerts out for. Since I have started paying attention, every company they have alerted has increased by a significant amount.Not only are the alerts good, but the actual news information they provide is helpful as well. I fully suggest this app.",
                      style: stylePTSansRegular(
                          color: ThemeColors.white, fontSize: 17),
                    ),
                    const SpacerVertical(height: 20),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SpacerVertical(height: 0);
            },
            itemCount: 3,
          ),

          // CarouselSlider.builder(
          //   options: CarouselOptions(
          //     // height: _currentHeight,
          //     enlargeCenterPage: true,
          //     autoPlay: true,
          //     aspectRatio: 12 / 8,
          //     onPageChanged: (index, reason) {
          //       setState(() {
          //         _currentHeight = calculateHeight(items[index]);
          //       });
          //     },
          //     autoPlayCurve: Curves.fastOutSlowIn,
          //     enableInfiniteScroll: true,
          //     autoPlayAnimationDuration: const Duration(milliseconds: 200),
          //     viewportFraction: 1,
          //   ),
          //   itemCount: items.length,
          //   itemBuilder: (BuildContext context, int index, int realIndex) {
          //     return Container(
          //       width: MediaQuery.of(context).size.width,
          //       decoration: BoxDecoration(
          //           // color: Colors.grey,
          //           gradient: const LinearGradient(
          //             begin: Alignment.bottomCenter,
          //             end: Alignment.topCenter,
          //             stops: [0.2, 0.65],
          //             colors: [
          //               Color.fromARGB(255, 32, 128, 65),
          //               // ThemeColors.greyBorder,
          //               Color.fromARGB(255, 0, 0, 0),
          //             ],
          //           ),
          //           border: Border.all(color: Colors.green),
          //           borderRadius: BorderRadius.circular(10.0)),
          //       padding: const EdgeInsets.all(20.0),
          //       margin: const EdgeInsets.only(right: 10),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           RatingBar.builder(
          //             initialRating: 5,
          //             minRating: 5,
          //             direction: Axis.horizontal,
          //             allowHalfRating: true,
          //             itemCount: 5,
          //             ignoreGestures: true,
          //             itemSize: 20,
          //             unratedColor: ThemeColors.greyBorder,
          //             itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          //             itemBuilder: (context, _) => const Icon(
          //               Icons.star,
          //               color: ThemeColors.white,
          //             ),
          //             onRatingUpdate: (rating) {
          //               print(rating);
          //             },
          //           ),
          //           const SpacerVertical(
          //             height: 10,
          //           ),
          //           Text(items[index].toString(),
          //               textAlign: TextAlign.start,
          //               softWrap: true,
          //               // maxLines: 3,
          //               overflow: TextOverflow.fade,
          //               style: stylePTSansRegular(
          //                   fontSize: 16, color: Colors.white)),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
