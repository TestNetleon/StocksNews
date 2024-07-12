import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/spacer_horizontal.dart';
import '../../../../../widgets/spacer_vertical.dart';

class BenefitPoints extends StatelessWidget {
  final List<Point>? points;
  final bool isSpend;
  const BenefitPoints({super.key, this.points, this.isSpend = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white),
      ),
      padding: const EdgeInsets.only(left: 10),
      child: ListView.separated(
        itemCount: points?.length ?? 0,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 12, right: 12),
        itemBuilder: (context, index) {
          Point? data = points?[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0) const SpacerVertical(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Image.network(
                      points?[index].image ?? "",
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SpacerHorizontal(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data?.key}",
                          style: styleSansBold(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SpacerVertical(height: 5),
                        Text(
                          "${data?.text}",
                          overflow: TextOverflow.fade,
                          style: stylePTSansRegular(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SpacerHorizontal(width: 10),
                  Visibility(
                    visible: data?.point != null,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 10.0, top: 15, left: 10),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSpend
                              ? ThemeColors.darkRed
                              : ThemeColors.darkGreen,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            data?.point.toString() ?? "",
                            style: styleSansBold(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SpacerVertical(height: 3),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.black12,
            height: 20,
          );
        },
      ),
    );
  }
}

List<String> images = [
  Images.referAndEarn,
  Images.signup,
  Images.login,
  Images.profile,
  Images.portfolio,
  Images.beginnerPlan,
  Images.traderPlan,
  Images.bg,
];
