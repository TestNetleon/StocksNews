import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import '../../tools/scanner/screens/extra/header.dart';

class HomeScannerIndex extends StatefulWidget {
  const HomeScannerIndex({super.key});

  @override
  State<HomeScannerIndex> createState() => _HomeScannerIndexState();
}

class _HomeScannerIndexState extends State<HomeScannerIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScannerManager>().getScannerPorts(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerManager>(
      builder: (context, value, child) {
        return Column(
          children: [
            MarketScannerHeader(isOnline: true),
          ],
        );
      },
    );
  }
}
