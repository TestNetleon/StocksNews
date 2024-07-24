import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class Performancewidget extends StatelessWidget {
  const Performancewidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpacerVertical(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 53, 53, 53),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.electric_bolt,
                              color: Colors.orange,
                              size: 20,
                            ),
                            SpacerHorizontal(
                              width: 8.0,
                            ),
                            Text('Performance',
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
                    SpacerVertical(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('52 Week low',
                                style: stylePTSansRegular(
                                    fontSize: 16.0, color: Colors.grey)),
                            Text('52 Week high',
                                style: stylePTSansRegular(
                                    fontSize: 16.0, color: Colors.grey)),
                          ],
                        ),
                        SpacerVertical(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('\$45.80',
                                style: stylePTSansRegular(
                                    fontSize: 16.0, color: Colors.white)),
                            Text('\$50.82',
                                style: stylePTSansRegular(
                                    fontSize: 16.0, color: Colors.white)),
                          ],
                        ),
                        SpacerVertical(
                          height: 10,
                        ),
                        SizedBox(
                          height: 80,
                          child: Stack(
                            children: [
                              Container(
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color.fromARGB(255, 41, 40, 40)),
                                padding: const EdgeInsets.all(8.0),
                              ),
                              Positioned(
                                left: 140,
                                child: Container(
                                  height: 10,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      gradient: LinearGradient(colors: const [
                                        Color.fromARGB(255, 24, 189, 33),
                                        Colors.yellow,
                                        Colors.orange,
                                      ])),
                                  padding: const EdgeInsets.all(8.0),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 140,
                                child: Container(
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 122, 219, 43),
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text('341.6',
                                        style: stylePTSansRegular(
                                            fontSize: 14.0,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Today's low",
                                    style: stylePTSansRegular(
                                        fontSize: 16.0, color: Colors.grey)),
                                Text("Today's high",
                                    style: stylePTSansRegular(
                                        fontSize: 16.0, color: Colors.grey)),
                              ],
                            ),
                            SpacerVertical(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('\$45.80',
                                    style: stylePTSansRegular(
                                        fontSize: 16.0, color: Colors.white)),
                                Text('\$50.82',
                                    style: stylePTSansRegular(
                                        fontSize: 16.0, color: Colors.white)),
                              ],
                            ),
                            SpacerVertical(
                              height: 10,
                            ),
                            SizedBox(
                              height: 80,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Color.fromARGB(255, 41, 40, 40)),
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                  Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        gradient: LinearGradient(colors: const [
                                          Color.fromARGB(255, 24, 189, 33),
                                          Colors.yellow,
                                          Colors.orange,
                                        ])),
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                  Positioned(
                                    top: 20,
                                    left: 40,
                                    child: Container(
                                      height: 30,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 122, 219, 43),
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text('341.6',
                                            style: stylePTSansRegular(
                                                fontSize: 14.0,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SpacerVertical(
                      height: 30,
                    ),
                  ],
                ),
              ),
              const SpacerVertical(
                height: 8.0,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 36, 32, 32),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Open Price',
                                style: stylePTSansRegular(
                                    fontSize: 14.0, color: Colors.grey)),
                            SpacerVertical(
                              height: 8.0,
                            ),
                            Text('341',
                                style: stylePTSansRegular(
                                    fontSize: 14.0, color: Colors.white)),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                          child: VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                            // indent: 5,
                            // endIndent: 5,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Prev. Close',
                                style: stylePTSansRegular(
                                    fontSize: 14.0, color: Colors.grey)),
                            SpacerVertical(
                              height: 8.0,
                            ),
                            Text('341.8',
                                style: stylePTSansRegular(
                                    fontSize: 14.0, color: Colors.white)),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                          child: VerticalDivider(
                            color: Colors.grey,
                            thickness: 2,
                            // indent: 3/
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Volumne',
                                style: stylePTSansRegular(
                                    fontSize: 14.0, color: Colors.grey)),
                            SpacerVertical(
                              height: 8.0,
                            ),
                            Text('42,390',
                                style: stylePTSansRegular(
                                    fontSize: 14.0, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
