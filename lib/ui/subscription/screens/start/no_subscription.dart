import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/subscription/screens/view/plans.dart';
import 'package:stocks_news_new/ui/subscription/superwall_service.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';
import '../../manager.dart';
import '../../model/subscription.dart';

class NoSubscription extends StatelessWidget {
  const NoSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    SubscriptionManager manager = context.watch<SubscriptionManager>();
    NoSubscriptionRes? noSubscription =
        manager.subscriptionData?.noSubscription;
    return Column(
      children: [
        Expanded(
          child: BaseScroll(
            margin: EdgeInsets.symmetric(
              horizontal: Pad.pad16,
              vertical: Pad.pad16,
            ),
            children: [
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Pad.pad16),
                  child: Container(
                    padding: EdgeInsets.all(27),
                    decoration: BoxDecoration(
                      color: ThemeColors.neutral5,
                      borderRadius: BorderRadius.circular(Pad.pad16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: noSubscription?.icon ?? '',
                      height: 33,
                      width: 33,
                    ),
                  ),
                ),
              ),
              BaseHeading(
                title: noSubscription?.subTitle,
                textAlign: TextAlign.center,
                margin: EdgeInsets.only(bottom: 32, top: Pad.pad24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  noSubscription?.text?.length ?? 0,
                  (index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            Images.tickCircle,
                            height: 32,
                            width: 32,
                            color: ThemeColors.secondary100,
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: Pad.pad16),
                              child: HtmlWidget(
                                noSubscription?.text?[index] ?? '',
                                textStyle: styleBaseRegular(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: 10),
          child: BaseButton(
            onPressed: () {
              if (manager.layoutData?.superWallLayout != null &&
                  manager.layoutData?.superWallLayout != '') {
                SuperwallService.instance.initializeSuperWall(
                    value: manager.layoutData?.superWallLayout ?? '');
                return;
              }
              Navigator.pushNamed(context, SubscriptionPlansIndex.path);
            },
            text: 'View Plans',
          ),
        ),
      ],
    );
  }
}
