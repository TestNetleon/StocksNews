import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TopBilIndex extends StatelessWidget {
  final RecentMentions? topBils;
  const TopBilIndex({super.key, this.topBils});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: topBils?.data != null,
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            RecentMentionsRes? item = topBils?.data?[index];
            return SizedBox();
          },
          separatorBuilder: (context, index) {
            return SpacerVertical(height: Pad.pad3);
          },
          itemCount: topBils?.data?.length ?? 0,
        ));
  }
}
