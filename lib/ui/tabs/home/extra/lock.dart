import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/ui/base/lock.dart';

import '../../../../models/lock.dart';
import '../../../base/button.dart';

class HomeLock extends StatelessWidget {
  final BaseLockInfoRes? lockInfo;
  final Widget? child;
  final num setNum;

  const HomeLock({
    super.key,
    this.lockInfo,
    this.child,
    required this.setNum,
  });

  @override
  Widget build(BuildContext context) {
    if (lockInfo == null) {
      return SizedBox();
    }
    return Stack(
      children: [
        child ?? SizedBox(),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: CachedNetworkImage(
            imageUrl: lockInfo?.image ?? '',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Consumer<MyHomeManager>(
            builder: (context, manager, child) {
              return BaseButton(
                text: lockInfo?.btn ?? '',
                onPressed: () {
                  manager.setNumValue(setNum);
                  baseSUBSCRIBE(
                    lockInfo!,
                    manager: manager,
                    callAPI: () async {
                      manager.getHomePremiumData();
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
