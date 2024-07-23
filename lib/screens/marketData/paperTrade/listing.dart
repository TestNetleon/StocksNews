import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../tabs/home/widgets/app_bar_home.dart';
import 'item.dart';

class PaperTradeListing extends StatelessWidget {
  const PaperTradeListing({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        showTrailing: true,
        canSearch: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimen.padding,
          vertical: Dimen.padding,
        ),
        itemBuilder: (context, index) {
          return const SdPaperTradeItem();
        },
        separatorBuilder: (context, index) {
          return const SpacerVertical();
        },
        itemCount: 20,
      ),
    );
  }
}
