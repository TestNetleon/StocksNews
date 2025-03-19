import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/ui/base/lock.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';

import '../../../../models/lock.dart';
import '../../../base/button.dart';

class HomeLock extends StatelessWidget {
  final BaseLockInfoRes? lockInfo;
  final Widget? childWidget;
  final num setNum;
  final double blur;
  final showButton;

  const HomeLock({
    super.key,
    this.lockInfo,
    this.childWidget,
    this.blur = 2,
    this.showButton = true,
    required this.setNum,
  });

  @override
  Widget build(BuildContext context) {
    return OptionalParent(
      addParent: lockInfo != null,
      parentBuilder: (child) {
        return Stack(
          children: [
            Blur(
              blur: blur,
              child: child,
            ),
            // Positioned(
            //   top: 0,
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: CachedNetworkImage(
            //     imageUrl: lockInfo?.image ?? '',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Visibility(
              visible: showButton,
              child: Positioned(
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
                            await manager.getHomePremiumData();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
      child: childWidget ?? SizedBox(),
    );
  }
}
