import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocks_news_new/models/onboarding.dart';
import 'package:stocks_news_new/managers/onboarding.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

import '../tabs/tabs.dart';
import 'slide_item.dart';

//MARK: Slides Index
class OnboardingSlides extends StatefulWidget {
  static const path = 'OnboardingSlides';
  const OnboardingSlides({super.key});

  @override
  State<OnboardingSlides> createState() => _OnboardingSlidesState();
}

class _OnboardingSlidesState extends State<OnboardingSlides> {
  final PageController _pageController = PageController();

  _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Tabs();
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    OnboardingManager provider = context.watch<OnboardingManager>();
    return BaseContainer(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Pad.pad16,
          vertical: Pad.pad16,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: _navigateToHome,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Skip',
                  style: stylePTSansRegular(
                    color: ThemeColors.secondary100,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: List.generate(
                  provider.data?.onboarding?.length ?? 0,
                  (index) {
                    OnboardingListRes? data = provider.data?.onboarding?[index];
                    if (data == null) {
                      return SizedBox();
                    }
                    return OnboardingSlideItem(data: data);
                  },
                ),
              ),
            ),
            const SpacerVertical(height: 20),
            SmoothPageIndicator(
              controller: _pageController,
              count: 4,
              effect: WormEffect(
                activeDotColor: ThemeColors.secondary120,
                dotColor: ThemeColors.neutral10,
                dotWidth: 10,
                dotHeight: 10,
              ),
            ),
            const SpacerVertical(height: 20),
            Visibility(
              visible: provider.data?.btnName != null &&
                  provider.data?.btnName != '',
              child: ThemeButton(
                radius: 8,
                onPressed: () {},
                color: ThemeColors.primary100,
                textColor: ThemeColors.black,
                text: provider.data?.btnName ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String image, String title, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 250),
        const SizedBox(height: 20),
        Text(
          title,
          style: stylePTSansRegular(fontSize: 20, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: stylePTSansRegular(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
