import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import '../../../base/heading.dart';
import 'item.dart';

class HomeInsiderTradesIndex extends StatelessWidget {
  final InsiderTradeListRes? insiderData;
  const HomeInsiderTradesIndex({super.key, this.insiderData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(title: insiderData?.title),
        SingleChildScrollView(
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
        )
      ],
    );
  }
}
