import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PriceVolatility extends StatelessWidget {
  const PriceVolatility({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Price Volatility',
          style: stylePTSansBold(fontSize: 18.0, color: Colors.white)),
      const SpacerVertical(
        height: 8.0,
      ),
      Container(
        // height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black38,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 35,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 24, 189, 33),
                          Colors.yellow,
                          Colors.orange,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 140,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 122, 219, 43),
                        borderRadius: BorderRadius.circular(20.0)),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'TVSELECT',
                      style: stylePTSansRegular(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 210,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(20.0)),
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Industry',
                        style: stylePTSansRegular(
                            fontSize: 12.0, color: Colors.black)),
                  ),
                ),
                const Positioned(
                  left: 140,
                  child: Dash(
                      direction: Axis.vertical,
                      length: 40,
                      dashLength: 10,
                      dashColor: Colors.white),
                ),
                const Positioned(
                  left: 210,
                  child: Dash(
                      direction: Axis.vertical,
                      length: 40,
                      dashLength: 10,
                      dashColor: Colors.white),
                ),
                Container(
                  width: 10,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.all(8.0),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
              ],
            ),
            const SpacerVertical(height: 12),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(66, 77, 73, 73),
                  borderRadius: BorderRadius.circular(20.0)),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.ac_unit_rounded),
                  const SpacerHorizontal(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                        'TVSELECT had lower price volatility then Industry in the last quarter',
                        style: stylePTSansRegular(
                            fontSize: 14.0, color: Colors.grey)),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    ]);
  }
}
