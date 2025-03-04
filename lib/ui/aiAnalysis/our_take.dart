import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../models/ai_analysis.dart';

class AIOurTake extends StatelessWidget {
  final AIourTakeRes? ourTake;

  const AIOurTake({super.key, this.ourTake});

  @override
  Widget build(BuildContext context) {
    if (ourTake == null) return SizedBox();
    return Container(
      padding: EdgeInsets.only(
        left: Pad.pad16,
        right: Pad.pad16,
        top: Pad.pad32,
        bottom: Pad.pad10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseHeading(
            title: ourTake?.title,
            margin: EdgeInsets.only(
              bottom: Pad.pad10,
            ),
          ),
          ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String? title = ourTake?.data?[index];
                if (title == null || title == '') {
                  return SizedBox();
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Icon(
                        Icons.circle,
                        color: ThemeColors.black,
                        size: 9,
                      ),
                    ),
                    SpacerHorizontal(width: 8),
                    Flexible(
                        child: Text(
                      title,
                      style: styleBaseRegular(fontSize: 18),
                    )),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                String? title = ourTake?.data?[index];

                if (title == null || title == '') {
                  return SizedBox();
                }
                return SpacerVertical(height: 10);
              },
              itemCount: ourTake?.data?.length ?? 0),
        ],
      ),
    );
  }
}
