import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import 'package:stocks_news_new/ui/tabs/home/extra/lock.dart';
import '../../../../utils/constants.dart';
import '../../../base/heading.dart';
import 'item.dart';

class HomeInsiderTradesIndex extends StatelessWidget {
  final InsiderTradeListRes? insiderData;
  const HomeInsiderTradesIndex({super.key, this.insiderData});

  @override
  Widget build(BuildContext context) {
    if (insiderData == null) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: insiderData?.title,
          margin: EdgeInsets.only(
            top: Pad.pad20,
            bottom: Pad.pad16,
          ),
        ),
        HomeLock(
          setNum: 1,
          lockInfo: insiderData?.lockInfo,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
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
      ],
    );
  }
}
