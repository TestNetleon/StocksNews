import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/prediction/Widget/linechart.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class TechnicalAnalaysis extends StatefulWidget {
  const TechnicalAnalaysis({super.key});

  @override
  State<TechnicalAnalaysis> createState() => _TechnicalAnalaysisState();
}

class _TechnicalAnalaysisState extends State<TechnicalAnalaysis>
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

  List<String> Technical = [
    "Moving Averages (MA)",
    "Relative Strength Index (RSI)",
    "Bollinger Bands",
    "MACD (Moving Average Convergence Divergence)"
  ];

  List<bool> isSelectedList = List.generate(4, (_) => false);
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Technical Analysis Metrics',
            style: stylePTSansBold(fontSize: 18)),
        const SizedBox(
          height: 8.0,
        ),
        ListView.builder(
          itemCount: Technical.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            var theme = Theme.of(context);
            return GestureDetector(
              onTap: () {
                setState(() {
                  // Toggle visibility of the additional container
                  print(isSelectedList[index]);
                  isSelectedList[index] = !isSelectedList[index];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  Technical[
                                      index], // Display the overall value here
                                  style: stylePTSansBold(color: Colors.black)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'Total Contract value of bookings on a quartely basis', // Display the overall value here
                                  style: stylePTSansRegular(
                                      fontSize: 12, color: Colors.black)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          Images.download,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Image.asset(
                          Images.edit,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.arrow_outward,
                          color: Colors.black,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Total Revenue of 2024', // Display the overall value here
                                style: stylePTSansBold(
                                    fontSize: 14, color: Colors.green)),
                            Row(
                              children: [
                                Text(
                                    '\$49.91M', // Display the overall value here
                                    style: stylePTSansBold(
                                        color: Colors.green, fontSize: 30)),
                                Icon(
                                  Icons.arrow_upward,
                                  color: Colors.green,
                                )
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Image.asset(
                              Images.graphHolder,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Visibility(
                      visible: isSelectedList[index],
                      child: Column(
                        children: [
                          DefaultTabController(
                            length: 2,
                            initialIndex: 1,
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                  color: const Color.fromARGB(255, 6, 185, 6),
                                  borderRadius: BorderRadius.circular(10)),
                              labelStyle: const TextStyle(color: Colors.white),
                              unselectedLabelColor: Colors.grey,
                              controller: controller,
                              indicatorWeight: 0,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelPadding: EdgeInsets.all(0),
                              tabs: const [
                                Tab(
                                  text: 'Summary',
                                ),
                                Tab(
                                  text: 'Details',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 300.0,
                            child: TabBarView(
                              controller: controller,
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  // padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //graph
                                      const SizedBox(
                                        height: 180,
                                        child: LineChartSample2(),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0, right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'open', // Display the overall value here
                                                style: stylePTSansBold(
                                                  color: const Color.fromARGB(
                                                      255, 102, 105, 102),
                                                )),
                                            Text(
                                                'High', // Display the overall value here
                                                style: stylePTSansBold(
                                                  color: const Color.fromARGB(
                                                      255, 102, 105, 102),
                                                )),
                                            Text(
                                                'Low', // Display the overall value here
                                                style: stylePTSansBold(
                                                  color: const Color.fromARGB(
                                                      255, 102, 105, 102),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '224.06', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.green)),
                                          Text(
                                              '105.41', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.red)),
                                          Text(
                                              '96.0374', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.red)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Volume', // Display the overall value here
                                              style: stylePTSansBold(
                                                color: const Color.fromARGB(
                                                    255, 102, 105, 102),
                                              )),
                                          Text(
                                              'Avg. Volume', // Display the overall value here
                                              style: stylePTSansBold(
                                                color: const Color.fromARGB(
                                                    255, 102, 105, 102),
                                              )),
                                          Text(
                                              'Market Cap', // Display the overall value here
                                              style: stylePTSansBold(
                                                color: const Color.fromARGB(
                                                    255, 102, 105, 102),
                                              )),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '63,6334', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.green)),
                                          Text(
                                              '78,323', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.red)),
                                          Text(
                                              '13,7435', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.red)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  // padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //graph
                                      const SizedBox(
                                        height: 180,
                                        child: LineChartSample2(),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0, right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'open', // Display the overall value here
                                                style: stylePTSansBold(
                                                  color: const Color.fromARGB(
                                                      255, 102, 105, 102),
                                                )),
                                            Text(
                                                'High', // Display the overall value here
                                                style: stylePTSansBold(
                                                  color: const Color.fromARGB(
                                                      255, 102, 105, 102),
                                                )),
                                            Text(
                                                'Low', // Display the overall value here
                                                style: stylePTSansBold(
                                                  color: const Color.fromARGB(
                                                      255, 102, 105, 102),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '224.06', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.green)),
                                          Text(
                                              '105.41', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.red)),
                                          Text(
                                              '96.0374', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.red)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Volume', // Display the overall value here
                                              style: stylePTSansBold(
                                                color: const Color.fromARGB(
                                                    255, 102, 105, 102),
                                              )),
                                          Text(
                                              'Avg. Volume', // Display the overall value here
                                              style: stylePTSansBold(
                                                color: const Color.fromARGB(
                                                    255, 102, 105, 102),
                                              )),
                                          Text(
                                              'Market Cap', // Display the overall value here
                                              style: stylePTSansBold(
                                                color: const Color.fromARGB(
                                                    255, 102, 105, 102),
                                              )),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '63,6334', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.green)),
                                          Text(
                                              '78,323', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.red)),
                                          Text(
                                              '13,7435', // Display the overall value here
                                              style: stylePTSansBold(
                                                  color: Colors.red)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
