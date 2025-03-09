import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/ui/tabs/home/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/scanner_port.dart';
import 'extra/header.dart';
import 'gainers.dart';

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
      print('HI');
      context.read<HomeGainersManager>().stopListeningPorts();
      Future.delayed(Duration(milliseconds: 100), () {
        context.read<HomeGainersManager>().startListeningPorts();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomeManager>(
      builder: (context, manager, child) {
        BaseLockInfoRes? lock = manager.data?.scannerPort?.lockInfo;
        CheckMarketOpenRes? marketOpenRes =
            manager.data?.scannerPort?.port?.checkMarketOpenApi;
        return Stack(
          children: [
            Column(
              children: [
                HomeScannerHeader(
                    isOnline: marketOpenRes?.startStreaming ?? false),
                HomeScannerGainersIndex(),
              ],
            ),
            if (lock != null) _lock(lock),
          ],
        );
      },
    );
  }

  Widget _lock(BaseLockInfoRes lock) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.all(2),
        child: CachedNetworkImage(
          imageUrl: lock.image ?? '',
          errorWidget: (context, url, error) {
            return Container(
              color: Colors.white.withValues(alpha: 0.6),
            );
          },
        ),
      ),
    );
  }
}
