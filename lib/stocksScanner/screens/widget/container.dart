import 'package:flutter/material.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../modals/market_scanner_res.dart';
import '../../modals/scanner_res.dart';
import 'item.dart';

//MARK: Online Data
class ScannerBaseContainer extends StatefulWidget {
  final List<MarketScannerRes>? dataList;
  const ScannerBaseContainer({super.key, this.dataList});

  @override
  State<ScannerBaseContainer> createState() => _ScannerBaseContainerState();
}

class _ScannerBaseContainerState extends State<ScannerBaseContainer> {
  // void _sortData(
  //     List<MarketScannerRes> dataList, SortByEnums sortBy, bool ascending) {
  //   dataList.sort((a, b) {
  //     int compareResult = 0;
  //     switch (sortBy) {
  //       case SortByEnums.symbol:
  //         compareResult = a.identifier?.compareTo(b.identifier ?? '') ?? 0;
  //         break;
  //     }
  //     return ascending ? compareResult : -compareResult;
  //   });
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.dataList?.isEmpty == true || widget.dataList == null) {
      return SizedBox();
    }
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context, index) {
            MarketScannerRes? data = widget.dataList?[index];
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
          itemCount: widget.dataList?.length ?? 0,
        ),
      ],
    );
  }
}

//MARK: Offline Data
class ScannerBaseContainerOffline extends StatefulWidget {
  final List<ScannerRes>? dataList;
  const ScannerBaseContainerOffline({super.key, this.dataList});

  @override
  State<ScannerBaseContainerOffline> createState() =>
      _ScannerBaseContainerOfflineState();
}

class _ScannerBaseContainerOfflineState
    extends State<ScannerBaseContainerOffline> {
  // void _sortData(
  //     List<ScannerRes> dataList, SortByEnums sortBy, bool ascending) {
  //   dataList.sort((a, b) {
  //     int compareResult = 0;
  //     switch (sortBy) {
  //       case SortByEnums.symbol:
  //         compareResult = a.identifier?.compareTo(b.identifier ?? '') ?? 0;
  //         break;
  //     }
  //     return ascending ? compareResult : -compareResult;
  //   });
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.dataList?.isEmpty == true || widget.dataList == null) {
      return SizedBox();
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        ScannerRes? data = widget.dataList?[index];
        return ScannerBaseItem(data: data);
      },
      separatorBuilder: (context, index) {
        return SpacerVertical(height: 15);
      },
      itemCount: widget.dataList?.length ?? 0,
    );
  }
}
