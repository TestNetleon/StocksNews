import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NewMembershipReviews extends StatelessWidget {
  const NewMembershipReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trusted Views',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const SpacerVertical(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) {
                return Container(
                  width: MediaQuery.of(context).size.width / 1.10,
                  // height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // gradient: const LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   stops: [0.2, 0.65],
                      //   colors: [
                      //     Color.fromARGB(255, 50, 51, 45),
                      //     Color.fromARGB(255, 59, 54, 54),
                      //   ],
                      // ),
                      borderRadius: BorderRadius.circular(10.0)),
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                        initialRating: 2,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemSize: 20,
                        unratedColor: ThemeColors.greyBorder,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: ThemeColors.ratingIconColor,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      const SpacerVertical(
                        height: 20,
                      ),
                      const Text(
                        'Free Down Arrow SVG Vectors and Icons. Down Arrow icons and vector packs for Sketch, Figma, websites or apps. Browse 50 vector icons about Down Arrow term, Browse 50 vector icons about Down Arrow term.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        // maxLines: 3,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
