import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class TournamentOpenIndex extends StatelessWidget {
  const TournamentOpenIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: 'My Position',
      ),
      body: Container(),
    );
  }
}
