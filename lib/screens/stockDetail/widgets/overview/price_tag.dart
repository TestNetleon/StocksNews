import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import '../../../../modals/stockDetailRes/earnings.dart';
import '../keystats/item.dart';

class SdOverviewLists extends StatelessWidget {
  final List<SdTopRes>? dataOver;
  final String? title;
  const SdOverviewLists({super.key, this.dataOver, this.title});

  @override
  Widget build(BuildContext context) {
    if (dataOver?.isEmpty == true || dataOver == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 20),
      child: Column(
        children: [
          ScreenTitle(title: title),
          CustomGridView(
              length: dataOver?.length ?? 0,
              getChild: (index) {
                SdTopRes? data = dataOver?[index];
                return StateItemNEW(
                  label: data?.key ?? "",
                  value: data?.value ?? "",
                );
              }),
        ],
      ),
    );
  }
}
