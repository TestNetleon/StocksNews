// import 'package:flutter/material.dart';
// import 'package:flutter_dash/flutter_dash.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
// import 'package:stocks_news_new/route/routes.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import 'title_tag.dart';

// class MsPriceVolatility extends StatelessWidget {
//   const MsPriceVolatility({super.key});

//   @override
//   Widget build(BuildContext context) {
//     MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
//     num avg = provider.priceVolatility?.volatility ?? 0;

//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       MsTitle(title: "Price Volatility"),
//       Container(
//         // height: 150,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.0),
//           color: Colors.black38,
//         ),
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Container(
//                     height: 35,
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Color.fromARGB(255, 24, 189, 33),
//                           Colors.yellow,
//                           Colors.orange,
//                         ],
//                       ),
//                     ),
//                     padding: const EdgeInsets.all(8.0),
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   left: 140,
//                   child: Container(
//                     height: 30,
//                     decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 122, 219, 43),
//                         borderRadius: BorderRadius.circular(20.0)),
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'TVSELECT',
//                       style: stylePTSansRegular(
//                         fontSize: 12.0,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 210,
//                   child: Container(
//                     height: 30,
//                     decoration: BoxDecoration(
//                         color: Colors.yellow,
//                         borderRadius: BorderRadius.circular(20.0)),
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Industry',
//                       style: stylePTSansRegular(
//                         fontSize: 12.0,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                   left: 140,
//                   child: Dash(
//                       direction: Axis.vertical,
//                       length: 40,
//                       dashLength: 10,
//                       dashColor: Colors.white),
//                 ),
//                 const Positioned(
//                   left: 210,
//                   child: Dash(
//                       direction: Axis.vertical,
//                       length: 40,
//                       dashLength: 10,
//                       dashColor: Colors.white),
//                 ),
//                 Container(
//                   width: 10,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20.0)),
//                   padding: const EdgeInsets.all(8.0),
//                 ),
//                 Positioned(
//                   right: 0,
//                   child: Container(
//                     width: 10,
//                     height: 50,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20.0)),
//                     padding: const EdgeInsets.all(8.0),
//                   ),
//                 ),
//               ],
//             ),
//             const SpacerVertical(height: 12),
//             Container(
//               decoration: BoxDecoration(
//                   color: Color.fromARGB(66, 77, 73, 73),
//                   borderRadius: BorderRadius.circular(20.0)),
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Icon(Icons.ac_unit_rounded),
//                   const SpacerHorizontal(
//                     width: 10.0,
//                   ),
//                   Expanded(
//                     child: Text(
//                         'TVSELECT had lower price volatility then Industry in the last quarter',
//                         style: stylePTSansRegular(
//                             fontSize: 14.0, color: Colors.grey)),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       )
//     ]);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'title_tag.dart';

class MsPriceVolatility extends StatelessWidget {
  const MsPriceVolatility({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew sdProvider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = sdProvider.tabRes?.keyStats;

    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    num avg = provider.priceVolatility?.volatility ?? 0;

    return BaseUiContainer(
      hasData: !provider.isLoadingPrice && provider.priceVolatility != null,
      isLoading: provider.isLoadingPrice,
      showPreparingText: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        MsTitle(title: "Price Volatility"),
        Container(
          // height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black38,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 25,
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _chip(),
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 24, 189, 33),
                                      Colors.yellow,
                                      Colors.orange,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            _chip(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 0,
                      child: Text(
                        "Low",
                        style: stylePTSansBold(fontSize: 12),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      right: 0,
                      child: Text(
                        "High",
                        style: stylePTSansBold(fontSize: 12),
                      ),
                    ),
                    Positioned(
                      left: (avg / 100) * ScreenUtil().screenWidth,
                      child: Dash(
                        direction: Axis.vertical,
                        dashLength: 8,
                        dashThickness: 2,
                        dashColor: ThemeColors.white,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left:
                          (avg / 100) * ScreenUtil().screenWidth - 20, //STATIC
                      child: _barTypeWidget(
                        isDownwards: true,
                        title: "${keyStats?.symbol}",
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left:
                          (avg / 100) * ScreenUtil().screenWidth - 30, //STATIC
                      child: _barTypeWidget(
                        title: "Industry",
                      ),
                    ),
                  ],
                ),
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
      ]),
    );
  }

  Widget _chip() {
    return Container(
      width: 8,
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _barTypeWidget({
    bool isDownwards = false,
    required String title,
  }) {
    return Column(
      children: [
        Visibility(
          visible: !isDownwards,
          child: CustomPaint(
            size: Size(10, 6),
            painter: TrianglePointer(isDownwards: isDownwards),
          ),
        ),
        Container(
          width: 80,
          decoration: BoxDecoration(
            color: ThemeColors.greyText,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Text(
            textAlign: TextAlign.center,
            title,
            style: styleGeorgiaRegular(color: ThemeColors.background),
          ),
        ),
        Visibility(
          visible: isDownwards,
          child: CustomPaint(
            size: Size(10, 6),
            painter: TrianglePointer(isDownwards: isDownwards),
          ),
        ),
      ],
    );
  }
}

class TrianglePointer extends CustomPainter {
  final bool isDownwards;

  TrianglePointer({this.isDownwards = true});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = ThemeColors.greyText;
    Path path = Path();

    if (isDownwards) {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
