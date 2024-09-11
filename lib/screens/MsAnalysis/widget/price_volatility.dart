import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../modals/msAnalysis/ms_top_res.dart';
import 'pointer_container.dart';
import 'title_tag.dart';

class MsPriceVolatility extends StatelessWidget {
  const MsPriceVolatility({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    num avg = provider.priceVolatility?.volatility ?? 0;
    MsStockTopRes? topData = provider.topData;
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
                      child: MsPointerContainer(
                        isDownwards: true,
                        title: "${topData?.symbol}",
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left:
                          (avg / 100) * ScreenUtil().screenWidth - 30, //STATIC
                      child: MsPointerContainer(
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
}
