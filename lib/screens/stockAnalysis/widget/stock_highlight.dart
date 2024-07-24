import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StockHightlight extends StatelessWidget {
  const StockHightlight({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Stock highlight', style: stylePTSansBold(fontSize: 18.0)),
        const SpacerVertical(
          height: 10.0,
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              // padding: const EdgeInsets.all(8.0),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 48, 47, 47),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.only(right: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpacerVertical(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Stock Sentiment',
                              style: stylePTSansRegular(
                                  fontSize: 18.0, color: Colors.grey)),
                          const SpacerHorizontal(
                            width: 8.0,
                          ),
                          const Icon(Icons.ac_unit_rounded)
                        ],
                      ),
                      const SpacerVertical(
                        height: 8.0,
                      ),
                      Text('Bullish',
                          style: stylePTSansBold(
                              fontSize: 18.0, color: Colors.green)),
                      const SpacerVertical(
                        height: 8.0,
                      ),
                      SizedBox(
                        width: 180,
                        child: Text(
                            'Buyers are optimized about the price rise, Stock is up trend',
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                            style: stylePTSansRegular(
                                fontSize: 18.0, color: Colors.grey)),
                      ),
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}
