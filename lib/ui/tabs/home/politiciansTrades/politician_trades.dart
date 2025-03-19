import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import 'package:stocks_news_new/ui/tabs/home/politiciansTrades/item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../../../base/heading.dart';
import '../extra/lock.dart';

class HomePoliticianTradesIndex extends StatelessWidget {
  final PoliticianTradeListRes? politicianData;
  const HomePoliticianTradesIndex({super.key, this.politicianData});

  @override
  Widget build(BuildContext context) {
    if (politicianData == null) {
      return SizedBox();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseHeading(
            title: politicianData?.title,
            margin: EdgeInsets.only(top: Pad.pad20, bottom: Pad.pad10),
          ),
          HomeLock(
            setNum: 2,
            lockInfo: politicianData?.lockInfo,
            blur: 5,
            childWidget: SingleChildScrollView(
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
      ),
    );
  }
}
