import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import 'package:stocks_news_new/ui/tabs/home/politiciansTrades/item.dart';
import '../../../base/heading.dart';
import '../extra/lock.dart';

class HomePoliticianTradesIndex extends StatelessWidget {
  final PoliticianTradeListRes? politicianData;
  const HomePoliticianTradesIndex({super.key, this.politicianData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(title: politicianData?.title),
        HomeLock(
          setNum: 2,
          lockInfo: politicianData?.lockInfo,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: Row(
                children: List.generate(
                  politicianData?.data?.length ?? 0,
                  (index) {
                    PoliticianTradeRes? data = politicianData?.data?[index];
                    if (data == null) {
                      return SizedBox();
                    }
                    return HomePoliticianTradeItem(data: data);
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
