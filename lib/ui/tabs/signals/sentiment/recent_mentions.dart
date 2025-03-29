import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/sentiment.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../../../../models/signals/sentiment.dart';
import '../../../../models/ticker.dart';
import '../../../base/base_list_divider.dart';
import '../../../base/stock/add.dart';

class SignalRecentMentions extends StatelessWidget {
  const SignalRecentMentions({super.key});

  @override
  Widget build(BuildContext context) {
    SignalsSentimentManager manager = context.watch<SignalsSentimentManager>();
    SignalMentionsRes? recentMentions = manager.data?.recentMentions;

    if (recentMentions?.data == null || recentMentions?.data?.isEmpty == true) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseHeading(
                  title: recentMentions?.title ?? 'Most Recent Stocks',
                ),
              ],
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            BaseTickerRes? data = recentMentions?.data?[index];
            if (data == null) {
              return SizedBox();
            }
            return BaseStockAddItem(
              data: data,
              index: index,
              manager: manager,
              onTap: (p0) {
                Navigator.pushNamed(context, SDIndex.path,
                    arguments: {'symbol': p0.symbol});
              },
            );
          },
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
          itemCount: recentMentions?.data?.length ?? 0,
        ),
      ],
    );
  }
}
