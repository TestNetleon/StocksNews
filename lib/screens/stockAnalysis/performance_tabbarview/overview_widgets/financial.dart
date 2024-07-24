import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/stockAnalysis/performance_tabbarview/overview_widgets/financial_tabbar/net_profit_chart.dart';
import 'package:stocks_news_new/screens/stockAnalysis/performance_tabbarview/overview_widgets/financial_tabbar/quarterly_net_profit_chart.dart';
import 'package:stocks_news_new/screens/stockAnalysis/performance_tabbarview/overview_widgets/financial_tabbar/quarterly_revenue_chart.dart';
import 'package:stocks_news_new/screens/stockAnalysis/performance_tabbarview/overview_widgets/financial_tabbar/revenue_chart.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FinancialWidget extends StatefulWidget {
  const FinancialWidget({super.key});

  @override
  State<FinancialWidget> createState() => _FinancialWidgetState();
}

class _FinancialWidgetState extends State<FinancialWidget>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isYearlySelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacerVertical(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 53, 53, 53),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.price_check_outlined,
                          color: Colors.orange,
                          size: 22,
                        ),
                        SpacerHorizontal(
                          width: 8.0,
                        ),
                        Text('Financials',
                            style: stylePTSansRegular(
                                fontSize: 20.0, color: Colors.white)),
                        SpacerHorizontal(
                          width: 8.0,
                        ),
                        Icon(
                          Icons.ac_unit_outlined,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.orange,
                      size: 30,
                    ),
                  ],
                ),
              ),
              SpacerVertical(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 1,
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                        color: const Color.fromARGB(255, 6, 185, 6),
                        borderRadius: BorderRadius.circular(10)),
                    labelStyle:
                        const TextStyle(color: Colors.white, fontSize: 14),
                    unselectedLabelColor: Colors.grey,
                    controller: controller,
                    indicatorWeight: 0,
                    padding: EdgeInsets.all(10.0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.all(0),
                    tabs: const [
                      Tab(
                        text: 'Revenue',
                      ),
                      Tab(
                        text: 'Net Profit',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.22,
                child: TabBarView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    isYearlySelected ? RevenueChart() : QuarterlyRevenueChart(),
                    isYearlySelected
                        ? NetProfitChart()
                        : QuarterlyNetProfitChart(),
                  ],
                ),
              ),
              SpacerVertical(
                height: 15,
              ),
              Text('all values are in Cr.',
                  style:
                      stylePTSansRegular(fontSize: 12.0, color: Colors.white)),
              SpacerVertical(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isYearlySelected = true;
                      });
                    },
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: isYearlySelected
                            ? Colors.white
                            : Color.fromARGB(255, 53, 53, 53),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text('Yearly',
                            style: stylePTSansBold(
                                fontSize: 14.0,
                                color: isYearlySelected
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : Colors.grey)),
                      ),
                    ),
                  ),
                  SpacerHorizontal(
                    width: 22,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isYearlySelected = false;
                      });
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: isYearlySelected
                            ? Color.fromARGB(255, 53, 53, 53)
                            : Colors.white,
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text('Quarterly',
                            style: stylePTSansBold(
                                fontSize: 14.0,
                                color: isYearlySelected
                                    ? Colors.grey
                                    : const Color.fromARGB(255, 0, 0, 0))),
                      ),
                    ),
                  )
                ],
              ),
              SpacerVertical(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
