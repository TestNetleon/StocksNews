import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../providers/compare_stocks_provider.dart';
import '../overview/item.dart';
import '../widgets/box.dart';

class CompareNewDividends extends StatefulWidget {
  const CompareNewDividends({super.key});

  @override
  State<CompareNewDividends> createState() => _CompareNewDividendsState();
}

class _CompareNewDividendsState extends State<CompareNewDividends> {
  bool dividendYield = false;
  bool annual = false;
  bool increase = false;
  bool annualized = false;
  bool payoutRatio = false;
  bool recentPayment = false;
  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          CompareNewBox(
            title: "Dividend Yield",
            onTap: () {
              dividendYield = !dividendYield;
              setState(() {});
            },
            open: dividendYield,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    provider.company.length,
                    (index) =>
                        CompareNewOverviewItem(index: index, item: "N/A"),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Annual Dividend",
            onTap: () {
              annual = !annual;
              setState(() {});
            },
            open: annual,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    provider.company.length,
                    (index) =>
                        CompareNewOverviewItem(index: index, item: "N/A"),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Dividend increase track record",
            onTap: () {
              increase = !increase;
              setState(() {});
            },
            open: increase,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    provider.company.length,
                    (index) =>
                        CompareNewOverviewItem(index: index, item: "N/A"),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Annualized 3-year dividend growth",
            onTap: () {
              annualized = !annualized;
              setState(() {});
            },
            open: annualized,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    provider.company.length,
                    (index) =>
                        CompareNewOverviewItem(index: index, item: "N/A"),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Dividend payout ratio",
            onTap: () {
              payoutRatio = !payoutRatio;
              setState(() {});
            },
            open: payoutRatio,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    provider.company.length,
                    (index) =>
                        CompareNewOverviewItem(index: index, item: "N/A"),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            title: "Recent dividend payment",
            onTap: () {
              recentPayment = !recentPayment;
              setState(() {});
            },
            open: recentPayment,
            child: Container(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    provider.company.length,
                    (index) =>
                        CompareNewOverviewItem(index: index, item: "N/A"),
                  ),
                ),
              ),
            ),
          ),
          const SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
