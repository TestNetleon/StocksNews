import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'widgets/banner.dart';
import 'widgets/benefit_title.dart';
import 'widgets/points.dart';

class HowToSpend extends StatefulWidget {
  final String? images;
  final String? description;
  final Function() onTap;

  const HowToSpend({
    required this.onTap,
    super.key,
    this.images,
    this.description,
  });

  @override
  State<HowToSpend> createState() => _HowToSpendState();
}

class _HowToSpendState extends State<HowToSpend> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeProvider homeProvider = context.read<HomeProvider>();
      if (homeProvider.benefitRes == null) {
        homeProvider.getBenefitsDetails();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    Earn? spend = provider.benefitRes?.spend;

    // List<String> images = [
    //   Images.referAndEarn,
    //   Images.signup,
    //   Images.login,
    //   Images.profile,
    //   Images.bg,
    // ];

    return BaseUiContainer(
      hasData: !provider.isLoadingBenefits && provider.benefitRes != null,
      isLoading: provider.isLoadingBenefits,
      error: provider.error,
      showPreparingText: true,
      isFull: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BenefitTitle(
                title: spend?.title,
                subTitle: spend?.subTitle,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.2, 0.65],
                          colors: [
                            Color.fromARGB(255, 204, 56, 19),
                            Color.fromARGB(255, 39, 37, 37),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 14, 41, 0),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        BenefitsBanner(banner: spend?.banner, isSpend: true),
                        const SpacerVertical(height: 12),
                        BenefitPoints(points: spend?.points, isSpend: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
