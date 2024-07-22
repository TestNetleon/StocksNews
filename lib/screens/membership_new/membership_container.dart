import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'widgtes/faq.dart';
import 'widgtes/reviews.dart';
import 'widgtes/upgrade_plan.dart';

class NewMembershipContainer extends StatefulWidget {
  final String? inAppMsgId;
  final String? notificationId;
  final bool withClickCondition;

  const NewMembershipContainer(
      {super.key,
      this.withClickCondition = false,
      this.inAppMsgId,
      this.notificationId});

  @override
  State<NewMembershipContainer> createState() => _NewMembershipContainerState();
}

class _NewMembershipContainerState extends State<NewMembershipContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getMembershipInfo());
  }

  void _getMembershipInfo() {
    MembershipProvider provider = context.read<MembershipProvider>();
    provider.getMembershipInfo(
      inAppMsgId: widget.inAppMsgId,
      notificationId: widget.notificationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();
    MembershipInfoRes? data = provider.membershipInfoRes;

    return BaseUiContainer(
      hasData: !provider.isLoading && data != null,
      isLoading: provider.isLoading,
      error: provider.error,
      showPreparingText: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Image.asset(
                Images.start3,
                fit: BoxFit.fill,
                height: 350,
                opacity: const AlwaysStoppedAnimation(.5),
              ),
              // height: 350.0,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  NewMembershipUpgradeCurrentPlan(
                    withClickCondition: widget.withClickCondition,
                  ),
                  const SpacerVertical(height: 10),
                  Visibility(
                    visible: data?.testimonials != null,
                    child: const NewMembershipReviews(),
                  ),
                  Visibility(
                    visible: data?.testimonials != null,
                    child: const SpacerVertical(height: 10),
                  ),
                  Visibility(
                    visible: data?.faq != null,
                    child: const NewMembershipFaq(),
                  ),
                  const SpacerVertical(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
