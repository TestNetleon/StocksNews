import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class LeaderShipNewTop extends StatelessWidget {
  const LeaderShipNewTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          Images.congratsGIF,
        ),
        Text(
          textAlign: TextAlign.center,
          "The Ultimate Spot Trading Competition!",
          style: stylePTSansBold(fontSize: 24),
        ),
        const SpacerVertical(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textAlign: TextAlign.center,
              "Reward Pool: ",
              style: stylePTSansBold(),
            ),
            Text(
              textAlign: TextAlign.center,
              "\$1.3 Crore",
              style:
                  stylePTSansBold(color: ThemeColors.progressbackgroundColor),
            )
          ],
        ),
        const SpacerVertical(height: 20),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 23, 23, 23),
                // ThemeColors.greyBorder,
                Color.fromARGB(255, 39, 39, 39),
              ],
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Participants".toUpperCase(),
                      style: stylePTSansBold(),
                    ),
                    const SpacerVertical(height: 10),
                    Text(
                      "27,294",
                      style: stylePTSansBold(),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: ThemeColors.greyBorder,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your Rank".toUpperCase(),
                      style: stylePTSansBold(),
                    ),
                    const SpacerVertical(height: 10),
                    Text(
                      "--",
                      style: stylePTSansBold(),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
