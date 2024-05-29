import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import 'widgets/header.dart';
import 'overview/overview.dart';

class CompareStockNewContainer extends StatelessWidget {
  const CompareStockNewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
              Dimen.padding, Dimen.padding, Dimen.padding, 0),
          child: Column(
            children: [
              SizedBox(
                height: constraints.maxWidth * 0.4,
                // width: double.infinity,
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: CompareNewHeader(),
                ),
              ),
              Expanded(
                child: CustomTabContainerNEW(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollable: true,
                  tabsPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  tabs: List.generate(
                      provider.tabs.length, (index) => provider.tabs[index]),
                  widgets: List.generate(
                    provider.tabs.length,
                    (index) {
                      if (index == 0) {
                        return const CompareNewOverview();
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
