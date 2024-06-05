import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../providers/compare_stocks_provider.dart';
import '../overview/item.dart';
import '../widgets/box.dart';

class CompareNewEarnings extends StatefulWidget {
  const CompareNewEarnings({super.key});

  @override
  State<CompareNewEarnings> createState() => _CompareNewEarningsState();
}

class _CompareNewEarningsState extends State<CompareNewEarnings> {
  bool date = false;
  bool actualEps = false;
  bool quarterly = false;
  bool annual = false;

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          CompareNewBox(
            title: "Upcoming earnings date",
            onTap: () {
              date = !date;
              setState(() {});
            },
            open: date,
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
            title: "Actual EPS",
            onTap: () {
              actualEps = !actualEps;
              setState(() {});
            },
            open: actualEps,
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
            title: "Quarterly Revenue",
            onTap: () {
              quarterly = !quarterly;
              setState(() {});
            },
            open: quarterly,
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
            title: "Annual Revenue",
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
          const SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
