import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/referral_manager.dart';
import 'package:stocks_news_new/service/appsFlyer/service.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/referFriend/points_list.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/referFriend/referral_header.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class ReferAFriend extends StatefulWidget {
  const ReferAFriend({super.key});

  @override
  State<ReferAFriend> createState() => _ReferAFriendState();
}

class _ReferAFriendState extends State<ReferAFriend> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    ReferralManager manager = context.read<ReferralManager>();
    manager.getData();
    Utils().showLog("SHRE URL ***** => $shareUrl  => ${shareUrl == null}");

    if (shareUrl == null) {
      AppsFlyerService.instance.createUserInvitationLink();
    }
  }

  @override
  Widget build(BuildContext context) {
    ReferralManager manager = context.watch<ReferralManager>();
    return BaseLoaderContainer(
      hasData: manager.data != null,
      isLoading: manager.isLoading,
      error: manager.error,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: _callAPI,
        children: [
          ReferralHeader(),
          PointsList(data: manager.data?.pointsSummary?.data),
        ],
      ),
    );
  }
}
