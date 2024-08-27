import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/ipo_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/ipo/item.dart';
import 'package:stocks_news_new/utils/colors.dart';

class IpoIndex extends StatelessWidget {
  const IpoIndex({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          IpoRes? data = provider.ipoRes?[index];
          return IpoItem(
            index: index,
            data: data,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 12,
            color: ThemeColors.greyBorder,
          );
        },
        itemCount: provider.ipoRes?.length ?? 0);
  }
}
