import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ArticleFeedback extends StatelessWidget {
  const ArticleFeedback({
    this.title,
    this.submitMessage,
    this.feebackType,
    required this.onSubmit,
    super.key,
  });
  final String? title, submitMessage;
  final Function(String) onSubmit;
  final List<String>? feebackType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ThemeColors.greyBorder,
          ),
          bottom: BorderSide(
            color: ThemeColors.greyBorder,
          ),
        ),
      ),
      // color: Colors.amber,
      child: submitMessage != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Images.tickFeedback, width: 30),
                const SpacerVertical(height: 5),
                Text(
                  "$submitMessage",
                  style: stylePTSansBold(),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Column(
              children: [
                Text(
                  "$title",
                  style: stylePTSansBold(),
                ),
                const SpacerVertical(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ItemArticleLike(
                      icon: Icons.thumb_down,
                      label: feebackType?[0] ?? "Bad",
                      onTap: () => onSubmit("bad"),
                    ),
                    // const SpacerHorizontal(width: 30),
                    ItemArticleLike(
                      icon: Icons.sentiment_neutral_sharp,
                      label: feebackType?[1] ?? "Just Okay",
                      onTap: () => onSubmit("sort_of"),
                    ),
                    // const SpacerHorizontal(width: 15),
                    ItemArticleLike(
                      icon: Icons.thumb_up,
                      label: feebackType?[2] ?? "AMAZING",
                      onTap: () => onSubmit("absolutely"),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}

class ItemArticleLike extends StatelessWidget {
  const ItemArticleLike({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: ThemeColors.tabBack,
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 10),
            child: Icon(
              icon,
              color: Colors.amberAccent,
            ),
          ),
        ),
        Text(
          label,
          style: stylePTSansRegular(
            color: ThemeColors.greyText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
