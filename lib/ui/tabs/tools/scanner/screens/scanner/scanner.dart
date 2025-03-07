import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/widgets/loading.dart';

import '../../models/live.dart';
import '../../models/offline.dart';
import '../extra/container.dart';

class ScannerIndex extends StatelessWidget {
  const ScannerIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerManager>(
      builder: (context, manager, child) {
        if (manager.dataList != null) {
          List<LiveScannerRes>? list = manager.dataList;
          if (list == null || list.isEmpty) {
            return SizedBox();
          }
          return Expanded(
            child: ScannerBaseContainer(dataList: list),
          );
        } else if (manager.offlineDataList != null) {
          List<OfflineScannerRes>? list = manager.offlineDataList;
          if (list == null || list.isEmpty) {
            return SizedBox();
          }
          return Expanded(
            child: ScannerBaseContainerOffline(dataList: list),
          );
        } else {
          return Expanded(child: Loading());
        }
      },
    );
  }
}
