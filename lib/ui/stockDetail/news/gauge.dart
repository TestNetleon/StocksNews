import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/gauge.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../managers/stockDetail/stock.detail.dart';
import '../../../models/market/market_res.dart';
import '../../../models/stockDetail/overview.dart';

class SDLatestNewsGauge extends StatefulWidget {
  final BaseKeyValueRes? sentimentsPer;

  const SDLatestNewsGauge({super.key, this.sentimentsPer});

  @override
  State<SDLatestNewsGauge> createState() => _SDLatestNewsGaugeState();
}

class _SDLatestNewsGaugeState extends State<SDLatestNewsGauge> {
  final List<MarketResData> _ranges = [
    MarketResData(
      title: '1D',
      slug: '1',
    ),
    MarketResData(
      title: '7D',
      slug: '7',
    ),
    MarketResData(
      title: '15D',
      slug: '15',
    ),
    MarketResData(
      title: '30D',
      slug: '30',
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.sentimentsPer == null) {
      return SizedBox();
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        BaseGaugeItem(value: widget.sentimentsPer?.value),
        Positioned(
          top: 20,
          child: Column(
            children: [
              Text(
                '${widget.sentimentsPer?.title}',
                style: styleBaseBold(fontSize: 17),
              ),
              Text(
                '${widget.sentimentsPer?.subTitle}',
                style: styleBaseRegular(
                  fontSize: 15,
                  color: ThemeColors.neutral40,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _ranges.length,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        right: index == _ranges.length - 1 ? 0 : 32),
                    child: GestureDetector(
                      onTap: () {
                        if (_selectedIndex != index) {
                          _selectedIndex = index;
                          setState(() {});
                          context.read<SDManager>().getSDLatestNews(
                                day: _ranges[index].slug ?? '',
                                showProgress: true,
                              );
                        }
                      },
                      child: Text(
                        _ranges[index].title ?? '',
                        style: _selectedIndex == index
                            ? styleBaseBold(color: ThemeColors.secondary120)
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
        ),
      ],
    );
  }
}
