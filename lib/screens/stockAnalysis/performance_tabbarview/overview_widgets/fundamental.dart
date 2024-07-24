import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class FundamentalWidget extends StatefulWidget {
  const FundamentalWidget({super.key});

  @override
  State<FundamentalWidget> createState() => _FundamentalWidgetState();
}

class _FundamentalWidgetState extends State<FundamentalWidget> {
  // ignore: non_constant_identifier_names
  List<Map<String, dynamic>> fundamental = [
    {
      "title": "P/E Ratio",
      "amount": "-",
    },
    {
      "title": "Sector P/E",
      "amount": "119.07",
    },
    {"title": "Deividend yield", "amount": "0.6%"},
    {"title": "Market Cap", "amount": "\$40Cr"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpacerVertical(
          height: 10.0,
        ),
        Container(
          // height: 400,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 53, 53, 53),
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.note_add_sharp,
                        color: Colors.orange,
                        size: 20,
                      ),
                      SpacerHorizontal(
                        width: 8.0,
                      ),
                      Text('Fundamentals',
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
              Row(
                children: [
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromARGB(255, 10, 10, 10)),
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('Small-Cap',
                          style: stylePTSansRegular(
                              fontSize: 12.0, color: Colors.grey)),
                    ),
                  ),
                  SpacerHorizontal(
                    width: 8,
                  ),
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromARGB(255, 10, 10, 10)),
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('Small-Cap',
                          style: stylePTSansRegular(
                              fontSize: 12.0, color: Colors.grey)),
                    ),
                  )
                ],
              ),
              SpacerVertical(
                height: 10,
              ),
              SizedBox(
                height: 150,
                child: GridView.builder(
                    itemCount: fundamental.length,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        crossAxisSpacing: 12),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            color: const Color.fromARGB(255, 27, 27, 27)),
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fundamental[index]['title'].toString(),
                                style: stylePTSansRegular(
                                    fontSize: 12.0, color: Colors.grey)),
                            SpacerVertical(
                              height: 8.0,
                            ),
                            Text(fundamental[index]['amount'].toString(),
                                style: stylePTSansRegular(
                                    fontSize: 12.0, color: Colors.white)),
                          ],
                        ),
                      );
                    }),
              ),
              SpacerVertical(
                height: 4.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
