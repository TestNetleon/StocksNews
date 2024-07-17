import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NewMembershipReviews extends StatelessWidget {
  const NewMembershipReviews({super.key});

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();
    MembershipInfoRes? data = provider.membershipInfoRes;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Trusted Ratings and Reviews',
              style: stylePTSansBold(fontSize: 18, color: Colors.white),
            ),
          ),
          const SpacerVertical(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: index % 2 == 0
                    ? ThemeColors.white
                    : const Color.fromARGB(255, 243, 242, 242),
                // ? ThemeColors.greyText.withOpacity(0.4)
                // : ThemeColors.greyBorder.withOpacity(0.9),
                child: Column(
                  children: [
                    // const SpacerVertical(height: 15),
                    RatingBar.builder(
                      initialRating: data?.testimonials[index].rating ?? 5,
                      minRating: 5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemSize: 30,
                      unratedColor: ThemeColors.greyBorder,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 251, 181, 5),
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    const SpacerVertical(height: 10),
                    Text(
                      "${data?.testimonials[index].title}",
                      textAlign: TextAlign.center,
                      style: styleSansBold(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SpacerVertical(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      "${data?.testimonials[index].text}",
                      style: stylePTSansRegular(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SpacerVertical(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      "${data?.testimonials[index].name}",
                      style: stylePTSansBold(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    // const SpacerVertical(height: 20),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SpacerVertical(height: 0);
            },
            itemCount: data?.testimonials.length ?? 0,
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
