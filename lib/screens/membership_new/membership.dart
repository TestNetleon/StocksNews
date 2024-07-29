import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/membership_new/membership_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class NewMembership extends StatelessWidget {
  final bool withClickCondition;
  final String? inAppMsgId;
  final String? notificationId;
  const NewMembership({
    super.key,
    this.withClickCondition = false,
    this.inAppMsgId,
    this.notificationId,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(isPopback: true),
      body: NewMembershipContainer(
        withClickCondition: withClickCondition,
      ),
    );
  }
}
