import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/referral_manager.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/pointsTransaction/index.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/referFriend/points_list.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

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
  }

  void _navigateToTransactions() {
    Navigator.pushNamed(
      context,
      ReferPointsTransaction.path,
      arguments: {"type": "", "title": null},
    );
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
          Padding(
            padding: EdgeInsets.all(Dimen.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  manager.data?.title ?? "",
                  style: styleBaseBold(fontSize: 26, height: 1.25),
                ),
                SpacerVertical(height: 4),
                HtmlWidget(
                  manager.data?.subTitle ?? "",
                  textStyle: styleBaseRegular(
                    fontSize: 16,
                    color: ThemeColors.neutral80,
                    height: 1.4,
                  ),
                ),
                SpacerVertical(height: 24),
                BaseBorderContainer(
                  padding: EdgeInsets.zero,
                  color: ThemeColors.secondary100,
                  child: Column(
                    children: [
                      Text(
                        "Your Referral Code",
                        style: styleBaseRegular(
                          fontSize: 14,
                          color: ThemeColors.gray2,
                        ),
                      ),
                      SpacerVertical(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "WARBST",
                            style: styleBaseBold(
                              fontSize: 20,
                              color: ThemeColors.white,
                            ),
                          ),
                          Image.asset(
                            Images.copy,
                            width: 17,
                          )
                        ],
                      ),
                      SpacerVertical(height: 8),
                      Text(
                        "https://stocksnews.page.link/tdqX",
                        style: styleBaseRegular(
                          fontSize: 14,
                          color: ThemeColors.white,
                        ),
                      ),
                      SpacerVertical(height: 14),
                      BaseButton(
                        onPressed: () {},
                        text: "Share with Friends",
                        color: ThemeColors.white,
                        textStyle: styleBaseBold(
                          fontSize: 16,
                          color: ThemeColors.secondary100,
                        ),
                        padding: EdgeInsets.all(12),
                      )
                    ],
                  ),
                ),
                SpacerVertical(height: Dimen.padding),
                Text(
                  manager.data?.pointsSummary?.title ?? "",
                  style: styleBaseBold(fontSize: 20, height: 1.25),
                ),
                SpacerVertical(height: Dimen.padding),
              ],
            ),
          ),
          PointsList(data: manager.data?.pointsSummary?.data),
          SpacerVertical(height: Dimen.padding),
          BaseButton(
            margin: EdgeInsets.all(16),
            onPressed: _navigateToTransactions,
            text: "View Points Transactions",
          ),
          SpacerVertical(height: Dimen.padding),
        ],
      ),
    );
  }
}
