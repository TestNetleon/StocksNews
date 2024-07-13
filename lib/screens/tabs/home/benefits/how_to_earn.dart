import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/benefits/widgets/benefit_title.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'widgets/banner.dart';
import 'widgets/points.dart';

class HowToEarn extends StatefulWidget {
  final String? images;
  // final String? description;
  final Function() onTap;

  const HowToEarn({
    required this.onTap,
    super.key,
    this.images,
    // this.description,
  });

  @override
  State<HowToEarn> createState() => _HowToEarnState();
}

class _HowToEarnState extends State<HowToEarn> {
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
    Earn? earn = provider.benefitRes?.earn;

    return BaseUiContainer(
      hasData: !provider.isLoadingBenefits && provider.benefitRes != null,
      isLoading: provider.isLoadingBenefits,
      error: provider.error,
      showPreparingText: true,
      isFull: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BenefitTitle(
                title: earn?.title,
                subTitle: earn?.subTitle,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ), // Adjust as needed
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
                            Color.fromARGB(255, 32, 128, 65),
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
                        BenefitsBanner(banner: earn?.banner),
                        const SpacerVertical(height: 12),
                        BenefitPoints(points: earn?.points),
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
