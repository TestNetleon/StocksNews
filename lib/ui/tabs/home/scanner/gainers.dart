import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';
import 'package:stocks_news_new/widgets/loading.dart';

import 'container.dart';
import 'manager/gainers.dart';

class HomeScannerGainersIndex extends StatelessWidget {
  const HomeScannerGainersIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeGainersManager>(
      builder: (context, manager, child) {
        if (manager.dataList != null) {
          List<LiveScannerRes>? list = manager.dataList;
          if (list == null || list.isEmpty) {
            return SizedBox();
          }

          return HomeScannerBaseContainer(dataList: list);
        } else if (manager.offlineDataList != null) {
          List<OfflineScannerRes>? list = manager.offlineDataList;
          if (list == null || list.isEmpty) {
            return SizedBox();
          }

          return HomeScannerBaseContainerOffline(dataList: list);
        } else {
          return Loading();
        }
      },
    );
  }
}
