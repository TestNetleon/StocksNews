import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FundamentalAnalaysis extends StatefulWidget {
  const FundamentalAnalaysis({super.key});

  @override
  State<FundamentalAnalaysis> createState() => _FundamentalAnalaysisState();
}

class _FundamentalAnalaysisState extends State<FundamentalAnalaysis> {
  List<String> fundamentals = ["Net Profilt", "Revenue", "Debits"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fundamental Analysis Metrics',
            style: stylePTSansBold(fontSize: 18)),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.radar,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text('AI Satisfation Scan',
                            style: stylePTSansBold(
                                color: Colors.black, fontSize: 20)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        Images.edit,
                        opacity: const AlwaysStoppedAnimation(.5),
                        height: 20,
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Image.asset(
                        Images.report,
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
              Text('Recent Customer Satisfication Score',
                  style: stylePTSansRegular(color: Colors.black)),
              const SizedBox(
                height: 3.0,
              ),
              Text('Within your casual range of 80-90%',
                  style: stylePTSansRegular(color: Colors.green)),
              const SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          showLabels: false,
                          showTicks: false,
                          startAngle: 270,
                          endAngle: 270,
                          axisLineStyle: const AxisLineStyle(
                            thickness: 1,
                            color: Color.fromARGB(255, 60, 209, 30),
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          pointers: const <GaugePointer>[
                            RangePointer(
                              value: 25.0,
                              width: 0.15,
                              color: Colors.white,
                              pointerOffset: 0.1,
                              cornerStyle: CornerStyle.bothCurve,
                              sizeUnit: GaugeSizeUnit.factor,
                            ),
                            RangePointer(
                              value: 80.0,
                              width: 0.15,
                              color: Color.fromARGB(255, 243, 243, 243),
                              pointerOffset: 0.1,
                              cornerStyle: CornerStyle.bothCurve,
                              sizeUnit: GaugeSizeUnit.factor,
                            )
                          ],
                        )
                      ],
                    ),
                    Positioned(
                      top: 60,
                      child: Column(
                        children: [
                          Text('80%', // Display the overall value here
                              style: stylePTSansBold(fontSize: 25)),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Text(
                              'Satisfiction Index', // Display the overall value here
                              style: stylePTSansRegular(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
                child: ListView.builder(
                  itemCount: fundamentals.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromARGB(255, 177, 247, 179),
                                offset: Offset(0, 2),
                                blurRadius: 6,
                                spreadRadius: 2)
                          ]),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            child: Text(
                                fundamentals[
                                    index], // Display the overall value here
                                style: stylePTSansBold(color: Colors.black)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
