import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import '../../../modals/msAnalysis/other_stocks.dart';
import '../widget/title_tag.dart';
import 'item.dart';

class MsOtherStocks extends StatefulWidget {
  const MsOtherStocks({super.key});

  @override
  State<MsOtherStocks> createState() => _MsOtherStocksState();
}

class _MsOtherStocksState extends State<MsOtherStocks> {
  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    // if (provider.otherStocks == null || provider.otherStocks?.isEmpty == true) {
    //   return SizedBox();
    // }

    return BaseUiContainer(
      hasData: !provider.isLoadingOtherStock && provider.otherStocks != null,
      isLoading: provider.isLoadingOtherStock,
      showPreparingText: true,
      placeholder: _dataWidget(
          otherStocks: List.generate(
        3,
        (index) {
          return MsMyOtherStockRes(
            change: "",
            changesPercentage: null,
            image: "",
            name: "",
            symbol: "",
            validTicker: 0,
          );
        },
      )),
      child: _dataWidget(otherStocks: provider.otherStocks),
    );
  }

  Column _dataWidget({List<MsMyOtherStockRes>? otherStocks}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MsTitle(title: "Your Other Stocks"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: List.generate(
              otherStocks?.length ?? 0,
              (index) {
                MsMyOtherStockRes? data = otherStocks?[index];
                return MsOtherStockItem(data: data);
              },
            ),
          ),
        ),
      ],
    );
  }
}
