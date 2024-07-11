import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/modals/stockDetailRes/earnings.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/ownership/ownership_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg.dart';

class AnalysisBenefitItem extends StatelessWidget {
  final SdBenefitAnalyst? data;
  final String? images;
  final String? description;
  // final bool isOpen;
  final Function() onTap;
//
  const AnalysisBenefitItem({
    required this.data,
    // required this.isOpen,
    required this.onTap,
    super.key,
    this.images,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          // gradient: const LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   stops: [0.2, 0.65],
          //   colors: [
          //     Color.fromARGB(255, 14, 41, 0),
          //     // ThemeColors.greyBorder,
          //     Color.fromARGB(255, 0, 0, 0),
          //   ],
          // ),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.green)),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SvgPicture.asset(
                  images.toString(),
                  width: 40,
                  height: 40,
                ),
              ),
              const SpacerHorizontal(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${data?.key}",
                      style: styleSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height: 8),
                    Text(
                      description.toString() ?? "",
                      style: styleSansBold(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SpacerHorizontal(width: 10),
              Text(
                data?.point.toString() ?? "",
                style: styleSansBold(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
