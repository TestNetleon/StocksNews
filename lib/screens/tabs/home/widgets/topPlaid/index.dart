import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';

class TopPlaidIndex extends StatelessWidget {
  const TopPlaidIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGridView(
      length: 4,
      getChild: (index) {
        return Container();
      },
    );
  }
}
