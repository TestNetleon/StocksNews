import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/benefits_items.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/benefits_redeem_items.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/home_partial_loading_widget.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class BenefitsMarketing extends StatefulWidget {
  const BenefitsMarketing({super.key});

  @override
  State<BenefitsMarketing> createState() => _BenefitsMarketingState();
}

class _BenefitsMarketingState extends State<BenefitsMarketing> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();

    return BaseContainer(
        drawer: const BaseDrawer(resetIndex: true),
        appBar: const AppBarHome(
          isPopback: true,
          showTrailing: true,
          canSearch: true,
        ),
        floatingAlingment: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 80,
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(18.0),
          child: ThemeButtonSmall(
            onPressed: () {},
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
            textSize: 15,
            fontBold: true,
            iconFront: true,
            color: _selectedIndex == 0
                ? ThemeColors.accent
                : const Color.fromARGB(255, 241, 70, 70),
            // icon: Icons.lock,
            radius: 30,
            mainAxisSize: MainAxisSize.max,
            text: "Get Rewarded Now",
            // showArrow: false,
          ),
        ),
        body: Expanded(
          child: CustomTabContainer(
            // scrollable: false,
            onChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            // padding: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: Dimen.padding),
            tabs: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text("How to earn"),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text("How to Spend"),
              ),
            ],
            widgets: [
              AnalysisBenefitItem(onTap: () {}),
              AnalysisBenefitRedeemItem(onTap: () {}),
            ],
          ),
        ));
  }
}
