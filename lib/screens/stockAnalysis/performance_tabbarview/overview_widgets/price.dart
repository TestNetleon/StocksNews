import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/stockAnalysis/performance_tabbarview/overview_widgets/price_tabbar/past_returns.dart';
import 'package:stocks_news_new/screens/stockAnalysis/performance_tabbarview/overview_widgets/price_tabbar/past_volumne.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PriceWidget extends StatefulWidget {
  const PriceWidget({super.key});

  @override
  State<PriceWidget> createState() => _PriceWidgetState();
}

class _PriceWidgetState extends State<PriceWidget>
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
                        Text('Price & Volume',
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
                        // gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: const [
                        //       Color.fromARGB(255, 24, 189, 33),
                        //       Colors.yellow,
                        //       Colors.orange,
                        //     ]),
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
                        text: 'Past returns',
                      ),
                      Tab(
                        text: 'Past Volume',
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
                  children: const <Widget>[
                    PastReturns(),
                    PastVolumne(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
