import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/models/tools.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/ui/tabs/home/extra/lock.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../managers/home/home.dart';
import '../../../../utils/constants.dart';
import '../../../base/button.dart';
import '../../../base/heading.dart';
import '../../../base/lock.dart';
import 'item.dart';

class HomeInsiderTradesIndex extends StatelessWidget {
  final InsiderTradeListRes? insiderData;
  const HomeInsiderTradesIndex({super.key, this.insiderData});

  @override
  Widget build(BuildContext context) {
    if (insiderData == null) {
      return SizedBox();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseHeading(
            titleStyle: styleBaseBold(fontSize: 22),
            title: insiderData?.title,
            margin: EdgeInsets.only(top: Pad.pad20, bottom: Pad.pad16),
            viewMore: () {
              EventsService.instance.viewAllTopInsiderTradesHomePage();
              ToolsManager manager = context.read<ToolsManager>();
              manager.startNavigation(
                ToolsEnum.signals,
                index: 2,
              );
            },
            viewMoreText: 'View All',
          ),
          HomeLock(
            showButton: false,
            setNum: 1,
            lockInfo: insiderData?.lockInfo,
            childWidget: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  children: List.generate(
                    insiderData?.data?.length ?? 0,
                    (index) {
                      InsiderTradeRes? data = insiderData?.data?[index];
                      if (data == null) {
                        return SizedBox();
                      }
                      return HomeInsiderTradeItem(data: data);
                    },
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: insiderData?.lockInfo != null,
            child: Consumer<MyHomeManager>(
              builder: (context, manager, child) {
                return BaseButton(
                  text: insiderData?.lockInfo?.btn ?? '',
                  onPressed: () {
                    manager.setNumValue(1);
                    baseSUBSCRIBE(
                      insiderData!.lockInfo!,
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
        ],
      ),
    );
  }
}
