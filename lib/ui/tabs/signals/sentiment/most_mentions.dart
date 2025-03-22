import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../models/signals/sentiment.dart';
import '../../../../models/ticker.dart';
import '../../../base/base_list_divider.dart';
import '../../../base/stock/add.dart';
import 'sentiment.dart';

class SignalMostMentions extends StatefulWidget {
  const SignalMostMentions({super.key});

  @override
  State<SignalMostMentions> createState() => _SignalsMostMentionsState();
}

class _SignalsMostMentionsState extends State<SignalMostMentions> {
  List<SignalMentionStockRes> innerTabs = [
    SignalMentionStockRes(label: '1 Day', value: 1),
    SignalMentionStockRes(label: '3 Day', value: 3),
    SignalMentionStockRes(label: '5 Day', value: 5),
    SignalMentionStockRes(label: '14 Day', value: 14),
    SignalMentionStockRes(label: '30 Day', value: 30),
  ];
  int selectedInnerTab = 0;
  @override
  Widget build(BuildContext context) {
    SignalsManager manager = context.watch<SignalsManager>();
    SignalMentionsRes? mostMentions = manager.signalSentimentData?.mostMentions;
    return Column(
      children: [
        Visibility(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseHeading(
                    title: mostMentions?.title ?? 'Most Mentioned Stocks'),
                Container(
                  margin: EdgeInsets.only(bottom: Pad.pad5),
                  child: Row(
                    children: List.generate(
                      innerTabs.length,
                      (index) {
                        return Container(
                          margin: EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () {
                              if (selectedInnerTab != index &&
                                  !manager.isLoadingSentiment) {
                                selectedInnerTab = index;
                                setState(() {});

                                manager.getSignalSentimentData(
                                  dataAll: 0,
                                  days: innerTabs[index].value,
                                  loadFull: false,
                                );
                              }
                            },
                            child: Text(
                              innerTabs[index].label,
                              style: selectedInnerTab == index
                                  ? styleBaseBold(
                                      color: ThemeColors.secondary120,
                                    )
                                  : styleBaseRegular(
                                      color: ThemeColors.neutral20,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        mostMentions?.data == null || mostMentions?.data?.isEmpty == true
            ? Center(
                child: BaseHeading(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  subtitle: mostMentions?.message,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  BaseTickerRes? data = mostMentions?.data?[index];
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
                itemCount: mostMentions?.data?.length ?? 0,
              ),
      ],
    );
  }
}
