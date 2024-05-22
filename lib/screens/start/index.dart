import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocks_news_new/modals/welcome_res.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class StartIndex extends StatefulWidget {
  final List<WelcomeRes>? welcome;
  static const path = "StartIndex";
  const StartIndex({super.key, this.welcome});

  @override
  State<StartIndex> createState() => _StartIndexState();
}

class _StartIndexState extends State<StartIndex> {
  int _activeIndex = 0;
  List<StartClass> array = [
    StartClass(
      title: "Social Trending",
      colorText: "Stocks!",
      description: "Stocks mentioned more often today than yesterday.",
      color: ThemeColors.background,
      // lottieFile:
      //     "https://lottie.host/e313273f-6091-474d-84db-a8635c17ad46/Z1ytoZt3Vp.json",
      // lottieFile:
      //     "https://lottie.host/e0a7a0db-24c4-4d04-9f89-fa8d995ebed5/U5BCDolXsb.json",
      lottieFile: Images.trendingGIF,
    ),
    StartClass(
      title: "Track Insider",
      colorText: 'Trades',
      description:
          "These insiders have been the most active in trading stocks.",
      color: ThemeColors.background,
      lottieFile: Images.bearBullGIF,

      // lottieFile:
      //     "https://lottie.host/e6984867-8de5-4c6b-9802-d31e3838d0c2/gya8lFmcM4.json",
    ),
    StartClass(
      title: "Most Discussed",
      colorText: 'Stocks!',
      description: "See most discussed stock data from social media.",
      color: ThemeColors.background,
      lottieFile: Images.discussedGIF,
    ),
    StartClass(
      title: "Latest Stock",
      colorText: 'News!',
      description: "Read latest news from wide range of media sources.",
      color: ThemeColors.background,
      lottieFile: Images.newsGIT,
    ),
    StartClass(
      title: "Set Stocks",
      colorText: 'Alerts!',
      description: "Set stock alert in case of mention spike.",
      color: ThemeColors.background,
      lottieFile: Images.alertBellGIF,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // fit: StackFit.expand,
          children: [
            Expanded(
              child: CarouselSlider.builder(
                itemCount: widget.welcome?.length ?? 0,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Visibility(
                          //     visible: array[index].lottieFile != null,
                          //     child: Lottie.network(
                          //         height: 300.sp,
                          //         array[index].lottieFile ?? "")),

                          Visibility(
                            visible: array[index].lottieFile != null,
                            child: Image.asset(
                              array[index].lottieFile ?? "",
                              height: 250.sp,
                            ),
                          ),

                          Text(
                            widget.welcome?[index].title ?? "",
                            style: stylePTSansBold(
                              fontSize: 45,
                            ),
                          ),
                          // Text(
                          //   array[index].colorText,
                          //   style: styleGeorgiaBold(fontSize: 45),
                          // ),
                          GradientText(
                            widget.welcome?[index].colorText ?? "",
                            style: stylePTSansBold(fontSize: 45),
                            colors: const [
                              Color.fromARGB(255, 32, 97, 34),
                              Color.fromARGB(255, 28, 235, 35),
                              Color.fromARGB(255, 138, 235, 141),
                            ],
                          ),
                          const SpacerVertical(height: 30),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.sp),
                            child: Text(
                              widget.welcome?[index].description ?? "",
                              textAlign: TextAlign.center,
                              style: styleGeorgiaBold(
                                  fontSize: 15, color: ThemeColors.greyText),
                            ),
                          ),
                          const SpacerVertical(height: 80),
                        ],
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlayInterval: const Duration(seconds: 10),
                  height: double.infinity,
                  // disableCenter: true,

                  autoPlay: true,
                  viewportFraction: 1,
                  pauseAutoPlayOnTouch: true,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _activeIndex = index;
                    });
                  },
                ),
              ),
            ),
            AnimatedSmoothIndicator(
              activeIndex: _activeIndex,
              count: array.length,
              // effect: WormEffect(
              //   spacing: 10.sp,
              //   type: WormType.thin,
              //   activeDotColor: ThemeColors.accent,
              //   dotColor: ThemeColors.greyText,
              //   dotWidth: 15.sp,
              //   dotHeight: 8.sp,
              // ),
              effect: ExpandingDotsEffect(
                spacing: 10.sp,
                activeDotColor: ThemeColors.accent,
                expansionFactor: 2.5,
                dotColor: ThemeColors.greyBorder,
                dotWidth: 8.sp,
                dotHeight: 8.sp,
              ),
            ),
            const SpacerVertical(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ThemeButtonSmall(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
                    fontBold: true,
                    color: ThemeColors.white,
                    textColor: ThemeColors.background,
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   createRoute(
                      //     const Login(
                      //       dontPop: "true",
                      //     ),
                      //   ),
                      // );
                      loginSheet(dontPop: "true");
                    },
                    text: "Log In",
                  ),
                  ThemeButtonSmall(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
                    fontBold: true,
                    color: ThemeColors.white,
                    textColor: ThemeColors.background,
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   createRoute(
                      //     const SignUp(
                      //       dntPop: "true",
                      //     ),
                      //   ),
                      // );
                      signupSheet(dontPop: "true");
                    },
                    text: "Create New Account",
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Preference.setFirstTime(false);

                Navigator.pushNamedAndRemoveUntil(
                    context, Tabs.path, (route) => false);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue as Guest",
                      style: stylePTSansBold(
                          fontSize: 12, color: ThemeColors.greyText),
                    ),
                    const SpacerHorizontal(width: 10),
                    const Icon(Icons.arrow_forward_ios,
                        size: 14, color: ThemeColors.greyText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StartClass {
  String title;
  String colorText;
  String description;
  String? lottieFile;
  Color color;
  StartClass({
    required this.title,
    required this.description,
    required this.color,
    required this.colorText,
    this.lottieFile,
  });
}
