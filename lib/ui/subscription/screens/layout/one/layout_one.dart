import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/legal/index.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/ui/subscription/model/layout_one.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'plans.dart';

class SubscriptionLayoutOne extends StatefulWidget {
  const SubscriptionLayoutOne({super.key});

  @override
  State<SubscriptionLayoutOne> createState() => _SubscriptionLayoutOneState();
}

class _SubscriptionLayoutOneState extends State<SubscriptionLayoutOne>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  num _selectedIndex = 0;

  onChange(index) {
    _selectedIndex = index;
    setState(() {});
    SubscriptionManager manager = context.read<SubscriptionManager>();
    manager.onChangePlan(null);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionManager>(
      builder: (context, value, child) {
        LayoutDataRes? basic = value.subscriptionData?.layout1?.basic;
        LayoutDataRes? pro = value.subscriptionData?.layout1?.pro;
        LayoutDataRes? elite = value.subscriptionData?.layout1?.elite;

        return LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: ThemeColors.blackShade,
                        ),
                      ),
                    ),
                  ],
                ),
                SpacerVertical(height: constraints.maxWidth / 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    textAlign: TextAlign.center,
                    value.subscriptionData?.layout1?.title?.toUpperCase() ?? '',
                    style: styleBaseBold(
                        fontSize: 30, color: ThemeColors.primary120),
                  ),
                ),
                SpacerVertical(height: 20),
                Container(
                  // decoration: BoxDecoration(
                  //   border: Border(
                  //     bottom: BorderSide(
                  //       color: Colors.secondary120,
                  //     ),
                  //   ),
                  // ),
                  child: TabBar(
                    onTap: onChange,
                    controller: _tabController,
                    labelPadding: EdgeInsets.only(bottom: 5),
                    indicator: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: ThemeColors.primary120,
                        ),
                      ),
                    ),
                    tabs: [
                      Text(
                        'BASIC',
                        style: styleBaseBold(
                          fontSize: 14,
                          color: ThemeColors.primary120,
                        ),
                      ),
                      Text(
                        'PRO',
                        style: styleBaseBold(
                          fontSize: 14,
                          color: ThemeColors.primary120,
                        ),
                      ),
                      Text(
                        'ELITE',
                        style: styleBaseBold(
                          fontSize: 14,
                          color: ThemeColors.primary120,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedIndex == 0) LayoutOnePlans(data: basic),
                if (_selectedIndex == 1) LayoutOnePlans(data: pro),
                if (_selectedIndex == 2) LayoutOnePlans(data: elite),
                GradientGlowButton(
                  onPressed: value.selectedPlan == null || !value.isClickable
                      ? null
                      : value.onPurchase,
                  // text: value.subscriptionData?.layout1?.btn ?? '',
                  text: 'Get Access Now',
                ),
                SpacerVertical(height: 15),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    children: [
                      TextSpan(
                        text: "Terms of Use",
                        style: styleBaseRegular(color: ThemeColors.greyText),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            openUrl(
                                'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
                          },
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: styleBaseRegular(color: ThemeColors.greyText),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, LegalInfoIndex.path,
                                arguments: {
                                  'slug': "privacy-policy",
                                });
                          },
                      ),
                      if (value.subscriptionData?.showRestore == true)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: CircleAvatar(
                              radius: 3,
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ),
                      if (value.subscriptionData?.showRestore == true)
                        TextSpan(
                          text: "Restore",
                          style: styleBaseRegular(color: ThemeColors.greyText),
                          recognizer: TapGestureRecognizer()
                            ..onTap = value.onRestorePurchase,
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class GradientGlowButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const GradientGlowButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool isDisabled = onPressed == null;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed, // Disable tap if null
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isDisabled
              ? LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade700],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.greenAccent.shade400,
                    Colors.green.shade800,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.66),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: Offset(-3, 3),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                text,
                style: styleBaseBold(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            if (isDisabled)
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
