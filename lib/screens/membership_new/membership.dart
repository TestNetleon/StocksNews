import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/membership_new/membership_container.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class NewMembership extends StatelessWidget {
  final String? inAppMsgId;
  final String? notificationId;
  final bool cancel;
  const NewMembership({
    super.key,
    this.inAppMsgId,
    this.notificationId,
    this.cancel = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: AppBarHome(
        isPopBack: true,
        icon: cancel ? Icons.close : null,
        canSearch: !cancel,
        showTrailing: !cancel,
      ),
      body: NewMembershipContainer(),
    );
  }
}
