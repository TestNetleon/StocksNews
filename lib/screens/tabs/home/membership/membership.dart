import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/membership/widgtes/faq.dart';
import 'package:stocks_news_new/screens/tabs/home/membership/widgtes/reviews.dart';
import 'package:stocks_news_new/screens/tabs/home/membership/widgtes/upgrade_plan.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/my_evaluvated_button.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NewMembership extends StatelessWidget {
  const NewMembership({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: const AppBarHome(
        isPopback: true,
        showTrailing: true,
        canSearch: true,
      ),
      body: Stack(
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
                )
                // height: 350.0,
                ),
          ),
          const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  NewMembershipUpgradeCurrentPlan(),
                  NewMembershipReviews(),
                  SpacerVertical(
                    height: 10,
                  ),
                  NewMembershipFaq(),
                  SpacerVertical(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12.0),
                child: MyElevatedButton(
                  width: double.infinity,
                  onPressed: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: const Text('Upgrade Now'),
                )),
          ),
        ],
      ),
    ));
  }
}
