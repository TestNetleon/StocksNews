import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/dividends/dividend_overtime_charts.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/dividends/dividend_payment_barchart.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/custom_tab_item_label.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:vibration/vibration.dart';

class DividendInnerTabs extends StatefulWidget {
  const DividendInnerTabs({super.key});
//
  @override
  State<DividendInnerTabs> createState() => _DividendInnerTabsState();
}

class _DividendInnerTabsState extends State<DividendInnerTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpacerVertical(height: isPhone ? 0 : 5),
        Container(
          padding: const EdgeInsets.all(2),
          // margin: widget.padding,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 21, 21, 21),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomTabHome(
                label: "Dividends Payments",
                selected: _selectedIndex == 0,
                onTap: () async {
                  try {
                    if (Platform.isAndroid) {
                      bool isVibe = await Vibration.hasVibrator() ?? false;
                      if (isVibe) {
                        Vibration.vibrate(
                            pattern: [50, 50, 79, 55], intensities: [1, 10]);
                      }
                    } else {
                      HapticFeedback.lightImpact();
                    }
                  } catch (e) {}
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              CustomTabHome(
                label: "Div. Yield Over Time",
                selected: _selectedIndex == 1,
                onTap: () async {
                  try {
                    if (Platform.isAndroid) {
                      bool isVibe = await Vibration.hasVibrator() ?? false;
                      if (isVibe) {
                        Vibration.vibrate(
                            pattern: [50, 50, 79, 55], intensities: [1, 10]);
                      }
                    } else {
                      HapticFeedback.lightImpact();
                    }
                  } catch (e) {}
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
        provider.isLoadingDividends
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 40.sp),
                child: const CircularProgressIndicator(
                  color: ThemeColors.accent,
                ),
              )
            : provider.dividends != null
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _selectedIndex == 0
                        ? const DividendPaymentBarchart()
                        : const DividendPaymentLineChart(),
                  )
                : SizedBox.shrink(),
        // : Center(
        //     child: ErrorDisplayNewWidget(
        //       error: provider.error,
        //       onRefresh: provider.getDividendsData(symbol: widget.symbol),
        //     ),
        //   ),
        const SpacerVertical(height: Dimen.itemSpacing),
      ],
    );
  }
}
