import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
import 'package:stocks_news_new/providers/blackFriday/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BlackFridayReviews extends StatelessWidget {
  const BlackFridayReviews({super.key});

  @override
  Widget build(BuildContext context) {
    BlackFridayProvider provider = context.watch<BlackFridayProvider>();
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
              style: styleSansBold(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          const SpacerVertical(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                color: index % 2 == 0
                    ? Colors.black
                    : const Color.fromARGB(255, 22, 22, 22),
                child: Column(
                  children: [
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
                      onRatingUpdate: (rating) {},
                    ),
                    const SpacerVertical(height: 10),
                    Text(
                      "${data?.testimonials[index].title}",
                      textAlign: TextAlign.center,
                      style: styleSansBold(
                        // color: Colors.black,
                        color: ThemeColors.accent,
                        fontSize: 20,
                      ),
                    ),
                    const SpacerVertical(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      "${data?.testimonials[index].text}",
                      style: stylePTSansRegular(
                        // color: Colors.black,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SpacerVertical(height: 20),
                    Text(
                      textAlign: TextAlign.center,
                      "${data?.testimonials[index].name}",
                      style: stylePTSansBold(
                        // color: Colors.black,
                        // color: Colors.white,
                        color: ThemeColors.accent,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SpacerVertical(height: 0);
            },
            itemCount: data?.testimonials.length ?? 0,
          ),
        ],
      ),
    );
  }
}
