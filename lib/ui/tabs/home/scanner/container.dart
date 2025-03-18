import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'item.dart';

//MARK: Online Data
class HomeScannerBaseContainer extends StatefulWidget {
  final List<LiveScannerRes>? dataList;
  const HomeScannerBaseContainer({super.key, this.dataList});

  @override
  State<HomeScannerBaseContainer> createState() =>
      _HomeScannerBaseContainerState();
}

class _HomeScannerBaseContainerState extends State<HomeScannerBaseContainer> {
  @override
  void initState() {
    super.initState();
    Utils().showLog('INIT LIVE');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataList?.isEmpty == true || widget.dataList == null) {
      return SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CustomGridView(
        length: widget.dataList?.length ?? 0,
        paddingVertical: 0,
        paddingHorizontal: 0,
        itemSpace: 10,
        getChild: (index) {
          LiveScannerRes? data = widget.dataList?[index];

          return HomeScannerItem(
            data: OfflineScannerRes(
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
      ),
    );
  }
}

//MARK: Offline Data
class HomeScannerBaseContainerOffline extends StatefulWidget {
  final List<OfflineScannerRes>? dataList;
  const HomeScannerBaseContainerOffline({super.key, this.dataList});

  @override
  State<HomeScannerBaseContainerOffline> createState() =>
      _HomeScannerBaseContainerOfflineState();
}

class _HomeScannerBaseContainerOfflineState
    extends State<HomeScannerBaseContainerOffline> {
  @override
  void initState() {
    super.initState();
    Utils().showLog('INIT OFFLINE');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataList?.isEmpty == true || widget.dataList == null) {
      return SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CustomGridView(
        length: widget.dataList?.length ?? 0,
        paddingHorizontal: 0,
        itemSpace: 10,
        paddingVertical: 0,
        getChild: (index) {
          OfflineScannerRes? data = widget.dataList?[index];
          if (data == null) {
            return SizedBox();
          }
          return HomeScannerItem(data: data);
        },
      ),
    );
  }
}
