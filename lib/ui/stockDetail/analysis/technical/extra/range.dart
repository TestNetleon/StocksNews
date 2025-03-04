import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../utils/colors.dart';

class TechnicalAnaRange extends StatefulWidget {
  final void Function(String) onTap;
  const TechnicalAnaRange({
    super.key,
    required this.onTap,
  });

  @override
  State<TechnicalAnaRange> createState() => _TechnicalAnaRangeState();
}

class _TechnicalAnaRangeState extends State<TechnicalAnaRange> {
  final List<MarketResData> _ranges = [
    MarketResData(
      title: '1M',
      slug: '1min',
    ),
    MarketResData(
      title: '5M',
      slug: '5min',
    ),
    MarketResData(
      title: '15M',
      slug: '15min',
    ),
    MarketResData(
      title: '30M',
      slug: '30min',
    ),
    MarketResData(
      title: '1H',
      slug: '1hour',
    ),
    MarketResData(
      title: '4H',
      slug: '4hour',
    ),
    MarketResData(
      title: '1D',
      slug: '1day',
    ),
  ];

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpacerVertical(height: 10),
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
                          widget.onTap(_ranges[index].slug ?? '');
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
        ],
      );
    });
  }
}
