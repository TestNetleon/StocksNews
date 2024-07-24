import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/main_tabbar.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/peer_comparison.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/price_volatility.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:stocks_news_new/modals/data.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/stock_analysis.dart';
import 'package:stocks_news_new/screens/stockAnalysis/widget/stock_highlight.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/stock_analysis_header.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StockAnalysis extends StatefulWidget {
  const StockAnalysis({super.key});

  @override
  State<StockAnalysis> createState() => _StockAnalysisState();
}

class _StockAnalysisState extends State<StockAnalysis> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarStockAnalysis(
        isPopback: true,
        showTrailing: true,
        canSearch: true,
        title: 'TCSELECT',
        amount: '\$240.5',
        percentage: '10.2',
        subPercentage: '-2.8',
        showrate: true,
      ),
      // ignore: prefer_const_constructors
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              StockHightlight(),
              SpacerVertical(
                height: 8.0,
              ),
              StockSubAnalysis(),
              SpacerVertical(
                height: 8.0,
              ),
              PriceVolatility(),
              SpacerVertical(
                height: 8.0,
              ),
              PerformaceTabbar(),
              SpacerVertical(
                height: 8.0,
              ),
              PeerComparison(),
              SpacerVertical(
                height: 8.0,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
