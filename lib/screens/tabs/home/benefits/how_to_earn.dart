import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/benefits/widgets/benefit_title.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HowToEarn extends StatefulWidget {
  final String? images;
  final String? description;
  final Function() onTap;

  const HowToEarn({
    required this.onTap,
    super.key,
    this.images,
    this.description,
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

    List<String> images = [
      Images.referAndEarn,
      Images.signup,
      Images.login,
      Images.profile,
      Images.portfolio,
      Images.beginnerPlan,
      Images.traderPlan,
      Images.bg,
    ];
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
                      height: 180,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Image.asset(
                                Images.reward,
                                height: 80.0,
                                width: 100.0,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SpacerVertical(height: 8),
                                  Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                        stops: [0.3, 0.65],
                                        colors: [
                                          Color.fromARGB(255, 32, 128, 65),
                                          Color.fromARGB(255, 11, 85, 37),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      earn?.banner.title ?? "",
                                      style: stylePTSansRegular(
                                        color: ThemeColors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const SpacerVertical(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      earn?.banner.subTitle ?? "",
                                      style: stylePTSansRegular(
                                        color: ThemeColors.lightGreen,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SpacerVertical(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 25.0,
                                    ),
                                    child: Text(
                                      earn?.banner.text ?? "",
                                      style: stylePTSansRegular(
                                        color: ThemeColors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SpacerVertical(height: 8),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SpacerVertical(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.white),
                          ),
                          padding: const EdgeInsets.only(left: 10),
                          child: ListView.separated(
                            itemCount:
                                provider.benefitRes?.earn.points.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            itemBuilder: (context, index) {
                              Point? data =
                                  provider.benefitRes?.earn.points[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0)
                                    const SpacerVertical(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Image.asset(
                                          images[index],
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                      const SpacerHorizontal(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${data?.key}",
                                              style:
                                                  styleSansBold(fontSize: 14),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SpacerVertical(height: 5),
                                            Text(
                                              "${data?.text}",
                                              overflow: TextOverflow.fade,
                                              style: stylePTSansRegular(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SpacerHorizontal(width: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10.0,
                                          top: 15,
                                        ),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ThemeColors.darkGreen,
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Center(
                                            child: Text(
                                              data?.point.toString() ?? "",
                                              style: styleSansBold(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SpacerVertical(height: 3),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                color: Colors.black12,
                                height: 20,
                              );
                            },
                          ),
                        ),
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
