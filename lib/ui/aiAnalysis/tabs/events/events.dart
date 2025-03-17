import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../models/stockDetail/overview.dart';
import '../../../../utils/colors.dart';

class AIEvents extends StatelessWidget {
  const AIEvents({super.key});

  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();
    List<BaseKeyValueRes>? events = manager.data?.events;
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: events?.length ?? 0,
      padding: EdgeInsets.only(
        bottom: 12,
        top: 10,
        right: Pad.pad16,
        left: Pad.pad16,
      ),
      itemBuilder: (context, index) {
        BaseKeyValueRes? data = events?[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: data?.title != null && data?.title != '',
              child: Text(
                "${data?.title}",
                style: styleBaseBold(fontSize: 18),
              ),
            ),
            Visibility(
              visible: data?.value != null && data?.value != '',
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "${data?.value}",
                  style: styleBaseRegular(),
                ),
              ),
            ),
            Visibility(
              visible: data?.subTitle != null && data?.subTitle != '',
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "${data?.subTitle}",
                  style: styleBaseRegular(
                    color: ThemeColors.neutral80,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return BaseListDivider(height: 25);
      },
    );
  }
}
