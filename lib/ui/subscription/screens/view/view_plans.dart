import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/legal/index.dart';
import 'package:stocks_news_new/ui/subscription/screens/view/annual.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../utils/colors.dart';
import 'monthly.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';

class ViewAllPlans extends StatefulWidget {
  const ViewAllPlans({super.key});

  @override
  State<ViewAllPlans> createState() => _ViewAllPlansState();
}

class _ViewAllPlansState extends State<ViewAllPlans> {
  final List<MarketResData> _tabs = [
    MarketResData(title: 'Monthly', slug: 'monthly_plans'),
    MarketResData(title: 'Annual', slug: 'annual_plans'),
  ];

  int _selectedTab = 0;
  void _onChange(index) {
    if (_selectedTab != index) {
      _selectedTab = index;
      if (kDebugMode) {
        print('Selected $index');
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionManager manager = context.watch<SubscriptionManager>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Pad.pad16),
          child: BaseTabs(
            isScrollable: false,
            data: _tabs,
            onTap: _onChange,
          ),
        ),
        if (_selectedTab == 0) ViewMonthlyPlan(),
        if (_selectedTab == 1) ViewAnnualPlan(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              BaseButton(
                text: 'Purchase',
                onPressed: manager.selectedPlan == null || !manager.isClickable
                    ? null
                    : manager.onPurchase,
              ),
              SpacerVertical(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        openUrl(
                            'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
                      },
                      child: Text(
                        'Terms of Service',
                        style: styleBaseRegular(color: ThemeColors.neutral40),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: manager.subscriptionData?.showRestore == true,
                    child: Flexible(
                      child: GestureDetector(
                        onTap: manager.onRestorePurchase,
                        child: Text(
                          'Restore Purchase',
                          style: styleBaseRegular(color: ThemeColors.neutral40),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            LegalInfoIndex(
                              slug: 'privacy-policy',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Privacy Policy',
                        style: styleBaseRegular(color: ThemeColors.neutral40),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
