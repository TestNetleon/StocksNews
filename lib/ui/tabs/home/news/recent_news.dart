import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../../models/my_home.dart';

class HomeNewsIndex extends StatelessWidget {
  final HomeNewsRes? newsData;
  const HomeNewsIndex({super.key, this.newsData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${newsData?.title}',
          style: styleGeorgiaBold(),
        ),
      ],
    );
  }
}
