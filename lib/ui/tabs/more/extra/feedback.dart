import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../models/news/detail.dart';

class FeedbackIndexItem extends StatelessWidget {
  final FeedbackRes? feedback;
  final void Function(MarketResData) onTap;
  const FeedbackIndexItem({
    super.key,
    this.feedback,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<MarketResData>? data = feedback?.type;

    if (data == null || data.isEmpty == true) {
      return SizedBox();
    }
    if (feedback?.existMessage != null && feedback?.existMessage != '') {
      return Container(
        margin: EdgeInsets.only(top: Pad.pad32),
        child: Column(
          children: [
            Image.asset(Images.tickFeedback, width: 30),
            const SpacerVertical(height: 5),
            Text(
              textAlign: TextAlign.center,
              feedback?.existMessage ?? '',
              style: styleBaseBold(),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: Pad.pad32),
      alignment: Alignment.center,
      child:
          //  feedback?.existMessage != null && feedback?.existMessage != ''
          //     ? Text(
          //         textAlign: TextAlign.center,
          //         feedback?.existMessage ?? '',
          //         style: styleBaseBold(),
          //       )
          //     :
          Column(
        children: [
          Text(
            feedback?.title ?? '',
            style: styleBaseBold(fontSize: 29),
          ),
          SpacerVertical(height: Pad.pad16),
          SingleChildScrollView(
            child: Row(
              children: List.generate(
                data.length,
                (index) {
                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(Pad.pad16),
                            onTap: () {
                              onTap(data[index]);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 35,
                                vertical: 27,
                              ),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ThemeColors.neutral10),
                                  borderRadius:
                                      BorderRadius.circular(Pad.pad16)),
                              child: CachedNetworkImage(
                                imageUrl: data[index].icon ?? '',
                                height: 33,
                                width: 33,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          data[index].title ?? '',
                          style: styleBaseRegular(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
