import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class AffiliateLeaderBoardTab extends StatelessWidget {
  final String name;
  final String? icon;
  final bool isSelected;
  const AffiliateLeaderBoardTab(
      {super.key, required this.name, this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: ThemeColors.accent) : null,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 23, 23, 23),
            Color.fromARGB(255, 48, 48, 48),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Text(
            name,
            style: stylePTSansBold(),
          ),
          const SpacerVertical(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(300),
            child: Image.asset(
              icon ?? Images.stockIcon,
              height: 43,
              width: 43,
            ),
          ),
        ],
      ),
    );
  }
}
