import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
import 'package:stocks_news_new/screens/offerMembership/blackFriday/widgets/faq.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../providers/offerMembership/christmas.dart';
import '../../../service/braze/service.dart';
import '../../../widgets/cache_network_image.dart';
import '../blackFriday/widgets/reviews.dart';
import 'widgets/upgrade_plan.dart';

class ChristmasContainer extends StatefulWidget {
  final String? inAppMsgId;
  final String? notificationId;

  const ChristmasContainer({super.key, this.inAppMsgId, this.notificationId});

  @override
  State<ChristmasContainer> createState() => _ChristmasContainerState();
}

class _ChristmasContainerState extends State<ChristmasContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMembershipInfo();
      BrazeService.membershipVisit();
    });
  }

  void _getMembershipInfo() {
    ChristmasProvider provider = context.read<ChristmasProvider>();
    provider.getMembershipInfo(
      inAppMsgId: widget.inAppMsgId,
      notificationId: widget.notificationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    ChristmasProvider provider = context.watch<ChristmasProvider>();
    MembershipInfoRes? data = provider.membershipInfoRes;

    return BaseUiContainer(
      hasData: !provider.isLoading && data != null,
      isLoading: provider.isLoading,
      error: provider.error,
      showPreparingText: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(8),
                  //     topRight: Radius.circular(8),
                  //   ),
                  //   child: Image.asset(
                  //     Images.blackFriday,
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: Colors.green,
                          width: 1,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: CachedNetworkImagesWidget(
                        data?.featuredImage ?? '',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SpacerVertical(height: 10),
                  ChristmasUpgradeCurrentPlan(),
                  const SpacerVertical(height: 10),
                  Visibility(
                    visible: data?.testimonials != null &&
                        data?.testimonials.isNotEmpty == true,
                    child: OfferMembershipReviews(
                      data: data?.testimonials,
                      color: ThemeColors.sos,
                    ),
                  ),
                  Visibility(
                    visible: data?.testimonials != null,
                    child: const SpacerVertical(height: 10),
                  ),
                  Visibility(
                    visible: data?.faq != null,
                    child: OfferMembershipFaq(
                      openIndex: provider.faqOpenIndex,
                      faq: data?.faq,
                      provider: provider,
                      color: ThemeColors.sos,
                    ),
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
