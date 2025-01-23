import 'package:flutter/material.dart';

import '../../../widgets/spacer_vertical.dart';
import '../../modals/market_scanner_res.dart';
import '../../modals/scanner_res.dart';
import 'item.dart';

class ScannerBaseContainer extends StatelessWidget {
  final List<MarketScannerRes>? dataList;
  const ScannerBaseContainer({super.key, this.dataList});

  @override
  Widget build(BuildContext context) {
    if (dataList?.isEmpty == true || dataList == null) {
      return SizedBox();
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        MarketScannerRes? data = dataList?[index];
        return ScannerBaseItem(
          data: ScannerRes(
            identifier: data?.identifier,
            name: data?.security?.name,
            bid: data?.bid,
            ask: data?.ask,
            volume: data?.volume,
            price: data?.last,
            sector: data?.sector,
            change: data?.change,
            changesPercentage: data?.percentChange,
            image: data?.image,
            ext: Ext(
              extendedHoursDate: data?.extendedHoursDate,
              extendedHoursTime: data?.extendedHoursTime,
              extendedHoursType: data?.extendedHoursType,
              extendedHoursPrice: data?.extendedHoursPrice,
              extendedHoursChange: data?.extendedHoursChange,
              extendedHoursPercentChange: data?.extendedHoursPercentChange,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SpacerVertical(height: 15);
      },
      itemCount: dataList?.length ?? 0,
    );
  }
}
