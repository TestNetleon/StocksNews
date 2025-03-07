import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../../../../../widgets/spacer_vertical.dart';
import 'item.dart';

//MARK: Online Data
class ScannerBaseContainer extends StatefulWidget {
  final List<LiveScannerRes>? dataList;
  const ScannerBaseContainer({super.key, this.dataList});

  @override
  State<ScannerBaseContainer> createState() => _ScannerBaseContainerState();
}

class _ScannerBaseContainerState extends State<ScannerBaseContainer> {
  @override
  Widget build(BuildContext context) {
    if (widget.dataList?.isEmpty == true || widget.dataList == null) {
      return SizedBox();
    }
    return BaseScroll(
      margin: EdgeInsets.only(top: Pad.pad16),
      onRefresh: () async {
        context.read<ScannerManager>().onRefresh();
      },
      children: List.generate(
        widget.dataList?.length ?? 0,
        (index) {
          LiveScannerRes? data = widget.dataList?[index];
          return Column(
            children: [
              ScannerBaseItem(
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
                    extendedHoursPercentChange:
                        data?.extendedHoursPercentChange,
                  ),
                ),
              ),
              Divider(
                color: ThemeColors.neutral5,
                height: 32,
                thickness: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}

//MARK: Offline Data
class ScannerBaseContainerOffline extends StatefulWidget {
  final List<OfflineScannerRes>? dataList;
  const ScannerBaseContainerOffline({super.key, this.dataList});

  @override
  State<ScannerBaseContainerOffline> createState() =>
      _ScannerBaseContainerOfflineState();
}

class _ScannerBaseContainerOfflineState
    extends State<ScannerBaseContainerOffline> {
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
        OfflineScannerRes? data = widget.dataList?[index];
        return ScannerBaseItem(data: data);
      },
      separatorBuilder: (context, index) {
        return SpacerVertical(height: 15);
      },
      itemCount: widget.dataList?.length ?? 0,
    );
  }
}
