import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/membership_new/membership_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class NewMembership extends StatelessWidget {
  const NewMembership({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      drawer: BaseDrawer(resetIndex: true),
      appBar: AppBarHome(
        isPopback: true,
        showTrailing: true,
        canSearch: true,
      ),
      body: NewMembershipContainer(),
    );
  }
}
