import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/onboarding.dart';
import 'package:stocks_news_new/managers/onboarding.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../base/button.dart';
import '../base/scaffold.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

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

  _navigateToHome({skipped = true}) {
    Preference.setShowIntro(false);
    Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) {
          return Tabs();
        },
      ),
      (route) => false,
    );

    // if (skipped) {
    //   EventsService.instance.onBoardingSKIP();
    // } else {
    //   EventsService.instance.onBoardingGOTO_7DAY();
    // }
  }

  @override
  Widget build(BuildContext context) {
    OnboardingManager manager = context.watch<OnboardingManager>();
    return BaseScaffold(
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
                  style: styleBaseRegular(
                    color: ThemeColors.secondary120,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: List.generate(
                  manager.data?.onboarding?.length ?? 0,
                  (index) {
                    OnboardingListRes? data = manager.data?.onboarding?[index];
                    if (data == null) {
                      return SizedBox();
                    }
                    return OnboardingSlideItem(data: data);
                  },
                ),
              ),
            ),
            const SpacerVertical(height: 20),
            Visibility(
              visible: manager.data?.onboarding != null &&
                  manager.data?.onboarding?.isNotEmpty == true,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: manager.data?.onboarding?.length ?? 0,
                effect: WormEffect(
                  activeDotColor: ThemeColors.secondary120,
                  dotColor: ThemeColors.neutral10,
                  dotWidth: 10,
                  dotHeight: 10,
                ),
              ),
            ),
            const SpacerVertical(height: 20),
            Visibility(
              visible:
                  manager.data?.btnName != null && manager.data?.btnName != '',
              child: BaseButton(
                radius: 8,
                onPressed: () {
                  _navigateToHome(skipped: false);

                  Future.delayed(Duration(milliseconds: 200), () async {
                    UserManager manager =
                        navigatorKey.currentContext!.read<UserManager>();
                    await manager.navigateToMySubscription();
                  });
                },
                color: ThemeColors.primary100,
                textColor: ThemeColors.black,
                text: manager.data?.btnName ?? '',
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
          style: styleBaseRegular(fontSize: 20),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: styleBaseRegular(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
