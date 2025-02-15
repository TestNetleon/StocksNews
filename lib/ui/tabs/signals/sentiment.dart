import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../models/ticker.dart';
import '../../../widgets/custom/base_loader_container.dart';
import '../../base/base_list_divider.dart';
import '../../base/stock_item.dart';
import 'widgets/sentiment_gauge.dart';

class SignalSentiment extends StatefulWidget {
  const SignalSentiment({super.key});

  @override
  State<SignalSentiment> createState() => _SignalSentimentState();
}

class _SignalSentimentState extends State<SignalSentiment> {
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

    return BaseLoaderContainer(
      isLoading: manager.isLoadingSentiment,
      hasData: manager.signalSentimentData != null,
      showPreparingText: true,
      error: manager.errorSentiment,
      child: BaseScroll(
        margin: EdgeInsets.zero,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
            child: SignalsSentimentGauge(),
          ),
          Visibility(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseHeading(title: 'Most Mentioned Stocks'),
                  Row(
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
                                  ? styleBaseBold()
                                  : styleBaseRegular(
                                      color: ThemeColors.neutral20,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          manager.signalSentimentData?.mostMentions?.data == null ||
                  manager.signalSentimentData?.mostMentions?.data?.isEmpty ==
                      true
              ? Center(
                  child: BaseHeading(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    subtitle:
                        manager.signalSentimentData?.mostMentions?.message,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    BaseTickerRes? data =
                        manager.signalSentimentData?.mostMentions?.data?[index];
                    if (data == null) {
                      return SizedBox();
                    }
                    return BaseStockItem(
                      slidable: false,
                      data: data,
                      index: index,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return BaseListDivider();
                  },
                  itemCount:
                      manager.signalSentimentData?.mostMentions?.data?.length ??
                          0,
                ),
          Visibility(
            visible: manager.signalSentimentData?.recentMentions?.data !=
                    null &&
                manager.signalSentimentData?.recentMentions?.data?.isNotEmpty ==
                    true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseHeading(title: 'Most Recent Stocks'),
                      ],
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    BaseTickerRes? data = manager
                        .signalSentimentData?.recentMentions?.data?[index];
                    if (data == null) {
                      return SizedBox();
                    }
                    return BaseStockItem(
                      slidable: false,
                      data: data,
                      index: index,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return BaseListDivider();
                  },
                  itemCount: manager
                          .signalSentimentData?.recentMentions?.data?.length ??
                      0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SignalMentionStockRes {
  String label;
  num value;
  SignalMentionStockRes({
    required this.label,
    required this.value,
  });
}
