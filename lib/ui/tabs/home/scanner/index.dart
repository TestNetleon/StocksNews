import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/lock.dart';
import 'package:stocks_news_new/ui/tabs/home/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/scanner_port.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
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
      HomeGainersManager manager = context.read<HomeGainersManager>();
      MyHomeManager homeManager = context.read<MyHomeManager>();

      BaseLockInfoRes? lock = homeManager.data?.scannerPort?.lockInfo;
      if (lock == null) {
        manager.stopListeningPorts();
        Future.delayed(Duration(milliseconds: 100), () {
          manager.startListeningPorts();
        });
      }
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
                // BaseButton(
                //   text: 'Go to Scanner',
                //   onPressed: () {
                //     ToolsManager manager = context.read<ToolsManager>();
                //     manager.startNavigation(ToolsEnum.scanner);
                //   },
                // ),
              ],
            ),
            if (lock != null) _lock(lock),
            if (lock != null) SpacerVertical(height: 300),
          ],
        );
      },
    );
  }

  Widget _lock(BaseLockInfoRes lock) {
    bool isDark = context.read<ThemeManager>().isDarkMode;

    return Consumer<MyHomeManager>(
      builder: (context, value, child) {
        return Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: (isDark ? lock.imageDark : lock.image) ?? "",
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.white.withValues(alpha: 0.6),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                    color: ThemeColors.neutral5.withValues(alpha: 0.44),
                    borderRadius: BorderRadius.circular(8)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lock.title ?? '-',
                      style: styleBaseBold(
                        color: ThemeColors.primary120,
                        fontSize: 40,
                      ),
                    ),
                    SpacerVertical(height: 10),
                    Text(
                      lock.subTitle ?? '-',
                      textAlign: TextAlign.center,
                      style: styleBaseSemiBold(
                        color: ThemeColors.black,
                        fontSize: 18,
                      ),
                    ),
                    SpacerVertical(height: 15),
                    BaseButton(
                      text: lock.btn ?? '',
                      onPressed: () {
                        value.setNumValue(3);
                        baseSUBSCRIBE(
                          lock,
                          manager: value,
                          callAPI: () async {
                            await value.getHomeData();
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
