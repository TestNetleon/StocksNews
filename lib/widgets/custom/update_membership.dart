import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/membership/membership.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../screens/membership_new/membership.dart';
import '../../utils/constants.dart';

class UpdateMembershipCard extends StatelessWidget {
  const UpdateMembershipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewMembership(
              withClickCondition: true,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const RadialGradient(
            center: Alignment.bottomCenter,
            radius: 3,
            stops: [0.0, 0.2, 1.0],
            colors: [
              Color.fromARGB(255, 20, 156, 10),
              Color.fromARGB(255, 0, 93, 12),
              Color.fromARGB(255, 4, 34, 0),
            ],
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              Images.pointIcon2,
              height: 60,
              width: 60,
            ),
            const SpacerHorizontal(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Buy Membership",
                    style: stylePTSansBold(fontSize: 18),
                  ),
                  const SpacerVertical(height: 3),
                  AutoSizeText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    "Purchase membership and explore new features of our app. ",
                    style: stylePTSansRegular(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
