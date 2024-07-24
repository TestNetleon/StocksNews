import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StockSubAnalysis extends StatelessWidget {
  const StockSubAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final Shader textGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 247, 204, 86),
        Color.fromARGB(255, 245, 143, 47)
      ],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 60.0));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SWOT analysis',
            style: stylePTSansBold(fontSize: 18.0, color: Colors.white)),
        const SpacerVertical(
          height: 8.0,
        ),
        Container(
          height: 240,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 53, 53, 53),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(255, 102, 100, 100)),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Stregnth',
                                        style: stylePTSansBold(
                                            fontSize: 14.0,
                                            color: const Color.fromARGB(
                                                255, 75, 74, 74))),
                                    const SpacerVertical(
                                      height: 8.0,
                                    ),
                                    Text('6',
                                        style: stylePTSansBold(
                                            fontSize: 14.0,
                                            color: Colors.green)),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(100),
                                        bottomRight: Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, left: 8.0),
                                      child: Text('S',
                                          style: stylePTSansBold(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SpacerHorizontal(
                          width: 12.0,
                        ),
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(255, 102, 100, 100)),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Weakness',
                                          style: stylePTSansBold(
                                              fontSize: 14.0,
                                              color: const Color.fromARGB(
                                                  255, 75, 74, 74))),
                                      const SpacerVertical(
                                        height: 8.0,
                                      ),
                                      Text('6',
                                          style: stylePTSansBold(
                                              fontSize: 14.0,
                                              color: Colors.green)),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(100),
                                        bottomLeft: Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, right: 8.0),
                                      child: Text('W',
                                          style: stylePTSansBold(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SpacerVertical(
                      height: 8.0,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(255, 102, 100, 100)),
                          // padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Opportunity',
                                        style: stylePTSansBold(
                                            fontSize: 14.0,
                                            color: const Color.fromARGB(
                                                255, 75, 74, 74))),
                                    const SpacerVertical(
                                      height: 8.0,
                                    ),
                                    Text('6',
                                        style: stylePTSansBold(
                                            fontSize: 14.0,
                                            color: Colors.green)),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(100)),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, left: 8.0),
                                      child: Text('O',
                                          style: stylePTSansBold(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SpacerHorizontal(
                          width: 10.0,
                        ),
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(255, 102, 100, 100)),
                          // padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Threat',
                                          style: stylePTSansBold(
                                              fontSize: 14.0,
                                              color: const Color.fromARGB(
                                                  255, 75, 74, 74))),
                                      const SpacerVertical(
                                        height: 8.0,
                                      ),
                                      Text('6',
                                          style: stylePTSansBold(
                                              fontSize: 14.0,
                                              color: Colors.green)),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(100)),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, right: 8.0),
                                      child: Text('T',
                                          style: stylePTSansBold(
                                              fontSize: 14.0,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'View details',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              foreground: Paint()..shader = textGradient,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orange,
                          )
                        ],
                      )
                    ],
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
