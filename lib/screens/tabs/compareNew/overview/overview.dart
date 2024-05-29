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
  bool volume = false;
  bool avgVolume = false;
  bool previousClose = false;
  bool open = false;
  bool eps = false;
  bool peRatio = false;
  bool avg50Ema = false;
  bool avg200Ema = false;
  bool revenue = false;
  bool bookValue = false;
  bool dividend = false;
  bool ev = false;
  bool bidAsk = false;
  bool marketCap = false;
  bool shareOutstanding = false;
  bool earning = false;

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
            title: "Year Low",
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
          CompareNewBox(
            hideTop: true,
            title: "Volume",
            onTap: () {
              volume = !volume;
              setState(() {});
            },
            open: volume,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].volume,
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
            title: "Average Volume (3m)",
            onTap: () {
              avgVolume = !avgVolume;
              setState(() {});
            },
            open: avgVolume,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].avgVolume,
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
            title: "Previous Close",
            onTap: () {
              previousClose = !previousClose;
              setState(() {});
            },
            open: previousClose,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].previousClose,
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
            title: "Open",
            onTap: () {
              open = !open;
              setState(() {});
            },
            open: open,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].open,
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
            title: "EPS",
            onTap: () {
              eps = !eps;
              setState(() {});
            },
            open: eps,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      "${provider.company[index].eps}",
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
            title: "PE/ ratio",
            onTap: () {
              peRatio = !peRatio;
              setState(() {});
            },
            open: peRatio,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      "${provider.company[index].pe}",
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
            title: "Average 50 EMA (D)",
            onTap: () {
              avg50Ema = !avg50Ema;
              setState(() {});
            },
            open: avg50Ema,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].priceAvg50,
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
            title: "Average 200 EMA (D)",
            onTap: () {
              avg200Ema = !avg200Ema;
              setState(() {});
            },
            open: avg200Ema,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].priceAvg200,
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
            title: "Revenue",
            onTap: () {
              revenue = !revenue;
              setState(() {});
            },
            open: revenue,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      // provider.company[index].revenue,
                      'N/A',
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
            title: "Book value/Share",
            onTap: () {
              bookValue = !bookValue;
              setState(() {});
            },
            open: bookValue,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      // provider.company[index].revenue,
                      'N/A',
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
            title: "Dividend (yield)",
            onTap: () {
              dividend = !dividend;
              setState(() {});
            },
            open: dividend,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      // provider.company[index].revenue,
                      'N/A',
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
            title: "EV/Ebitda",
            onTap: () {
              ev = !ev;
              setState(() {});
            },
            open: ev,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      // provider.company[index].revenue,
                      'N/A',
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
            title: "Bid/Ask",
            onTap: () {
              bidAsk = !bidAsk;
              setState(() {});
            },
            open: bidAsk,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      // provider.company[index].revenue,
                      'N/A',
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
            title: "Market Cap.",
            onTap: () {
              marketCap = !marketCap;
              setState(() {});
            },
            open: marketCap,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].mktCap,
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
            title: "Shares Outstanding",
            onTap: () {
              shareOutstanding = !shareOutstanding;
              setState(() {});
            },
            open: shareOutstanding,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].sharesOutstanding,
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
            title: "Earnings Announcement",
            onTap: () {
              earning = !earning;
              setState(() {});
            },
            open: earning,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  provider.company.length,
                  (index) => Expanded(
                    child: Text(
                      provider.company[index].earningsAnnouncement,
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
