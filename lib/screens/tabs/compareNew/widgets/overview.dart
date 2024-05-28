import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/screens/tabs/compareNew/widgets/box.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class CompareNewOverview extends StatefulWidget {
  const CompareNewOverview({super.key});

  @override
  State<CompareNewOverview> createState() => _CompareNewOverviewState();
}

class _CompareNewOverviewState extends State<CompareNewOverview> {
  bool symbolOpen = false;
  bool nameOpen = false;
  bool priceOpen = false;
  bool changePer = false;
  bool change = false;
  bool dayLow = false;
  bool dayHigh = false;
  bool yearLow = false;
  bool yearHigh = false;

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();
    return SingleChildScrollView(
      child: Column(
        children: [
          CompareNewBox(
            title: "Symbol",
            onTap: () {
              symbolOpen = !symbolOpen;
              setState(() {});
            },
            open: symbolOpen,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].symbol,
                      textAlign: TextAlign.left,
                      style: stylePTSansRegular(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            hideTop: true,
            title: "Name",
            onTap: () {
              nameOpen = !nameOpen;
              setState(() {});
            },
            open: nameOpen,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].name,
                      textAlign: TextAlign.left,
                      style: stylePTSansRegular(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            hideTop: true,
            title: "Price",
            onTap: () {
              priceOpen = !priceOpen;
              setState(() {});
            },
            open: priceOpen,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].price,
                      textAlign: TextAlign.left,
                      style: stylePTSansRegular(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            hideTop: true,
            title: "Change Percentage",
            onTap: () {
              changePer = !changePer;
              setState(() {});
            },
            open: changePer,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      "${provider.company[index].changesPercentage}%",
                      textAlign: TextAlign.left,
                      style: stylePTSansRegular(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            hideTop: true,
            title: "Change",
            onTap: () {
              change = !change;
              setState(() {});
            },
            open: change,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].changes.toCurrency(),
                      textAlign: TextAlign.left,
                      style: stylePTSansRegular(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            hideTop: true,
            title: "Day Low",
            onTap: () {
              dayLow = !dayLow;
              setState(() {});
            },
            open: dayLow,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].dayLow,
                      textAlign: TextAlign.left,
                      style: stylePTSansRegular(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            hideTop: true,
            title: "Day High",
            onTap: () {
              dayHigh = !dayHigh;
              setState(() {});
            },
            open: dayHigh,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].dayHigh,
                      textAlign: TextAlign.left,
                      style: stylePTSansRegular(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            hideTop: true,
            title: "year Low",
            onTap: () {
              yearLow = !yearLow;
              setState(() {});
            },
            open: yearLow,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].yearLow,
                      textAlign: TextAlign.left,
                      style: stylePTSansRegular(fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),
          CompareNewBox(
            hideTop: true,
            title: "Year High",
            onTap: () {
              yearHigh = !yearHigh;
              setState(() {});
            },
            open: yearHigh,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].yearHigh,
                      textAlign: TextAlign.left,
                      style: stylePTSansRegular(fontSize: 13),
                    ),
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
