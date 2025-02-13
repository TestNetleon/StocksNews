import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/screens/membership/view.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';

class MembershipIndex extends StatefulWidget {
  const MembershipIndex({super.key});

  @override
  State<MembershipIndex> createState() => _MembershipIndexState();
}

class _MembershipIndexState extends State<MembershipIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MembershipProvider>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();

    return BaseContainer(
      appBar: AppBarHome(isPopBack: true, title: "My Membership"),
      body: Padding(
        padding: EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
        child: BaseUiContainer(
          hasData: !provider.isLoading &&
              (provider.data?.isNotEmpty == true && provider.data != null),
          isLoading: provider.isLoading,
          error: provider.error,
          isFull: true,
          showPreparingText: true,
          onRefresh: () {
            provider.getData();
          },
          child: Column(
            children: [
              const MyMembershipWidget(),
              Expanded(
                child: MembershipView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
