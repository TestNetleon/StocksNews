import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/widgets/compare_sc_simmer/compare_footer_sc_simmer.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/widgets/compare_sc_simmer/compare_header_sc_simmer.dart';
import 'package:stocks_news_new/widgets/screen_title_simmer.dart';

class CompareScreenSimmer extends StatelessWidget {
  const CompareScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitleSimmer(
            titleVisible: false,
          ),
          CompareHeaderScreenSimmer(),
          CompareFooterScreenSimmer()
        ],
      ),
    );
  }
}
