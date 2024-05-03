import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/login/login.dart';
import 'package:stocks_news_new/screens/auth/signup/signup.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

// class StartIndex extends StatefulWidget {
//   static const path = "StartIndex";
//   const StartIndex({super.key});

//   @override
//   State<StartIndex> createState() => _StartIndexState();
// }

// class _StartIndexState extends State<StartIndex> {
//   int _activeIndex = 0;
//   List<StartClass> array = [
//     StartClass(
//       title: "Social Trending",
//       colorText: "Stocks!",
//       description: "Stocks mentioned more often today than yesterday.",
//       color: ThemeColors.background,
//     ),
//     StartClass(
//       title: "Track Insider",
//       colorText: 'Trades',
//       description:
//           "These insiders have been the most active in trading stocks.",
//       color: ThemeColors.background,
//     ),
//     StartClass(
//       title: "Most Discussed",
//       colorText: 'Stocks!',
//       description: "See most discussed stock data from social media.",
//       color: ThemeColors.background,
//     ),
//     StartClass(
//       title: "Latest Stock",
//       colorText: 'News!',
//       description: "Read latest news from wide range of media sources.",
//       color: ThemeColors.background,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BaseContainer(
//       body: Stack(
//         alignment: Alignment.center,
//         // fit: StackFit.expand,
//         children: [
//           CarouselSlider.builder(

//             itemCount: array.length,
//             itemBuilder: (context, index, realIndex) {
//               return Container(
//                 color: array[index].color,
//                 alignment: Alignment.center,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       array[index].title,
//                       style: stylePTSansBold(
//                         fontSize: 45,
//                       ),
//                     ),
//                     // Text(
//                     //   array[index].colorText,
//                     //   style: styleGeorgiaBold(fontSize: 45),
//                     // ),
//                     GradientText(
//                       array[index].colorText,
//                       style: stylePTSansBold(fontSize: 45),
//                       colors: const [
//                         Colors.purple,
//                         Colors.red,
//                         Colors.orange,
//                       ],
//                     ),
//                     const SpacerVertical(height: 30),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 30.sp),
//                       child: Text(
//                         array[index].description,
//                         textAlign: TextAlign.center,
//                         style: styleGeorgiaBold(
//                             fontSize: 15, color: ThemeColors.greyText),
//                       ),
//                     ),
//                     const SpacerVertical(height: 240),
//                   ],
//                 ),
//               );
//             },
//             options: CarouselOptions(
//               autoPlayInterval: const Duration(seconds: 10),
//               height: double.infinity,
//               // disableCenter: true,

//               autoPlay: true,
//               viewportFraction: 1,
//               pauseAutoPlayOnTouch: true,
//               enlargeCenterPage: true,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _activeIndex = index;
//                 });
//               },
//             ),
//           ),
//           Positioned(
//             bottom: 150.sp,
//             child: AnimatedSmoothIndicator(
//               activeIndex: _activeIndex,
//               count: array.length,
//               // effect: WormEffect(
//               //   spacing: 10.sp,
//               //   type: WormType.thin,
//               //   activeDotColor: ThemeColors.accent,
//               //   dotColor: ThemeColors.greyText,
//               //   dotWidth: 15.sp,
//               //   dotHeight: 8.sp,
//               // ),
//               effect: ExpandingDotsEffect(
//                 spacing: 10.sp,
//                 activeDotColor: ThemeColors.accent,
//                 expansionFactor: 2.5,
//                 dotColor: ThemeColors.greyBorder,
//                 dotWidth: 8.sp,
//                 dotHeight: 8.sp,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 80.sp,
//             right: 30.sp,
//             left: 30.sp,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ThemeButtonSmall(
//                   color: ThemeColors.white,
//                   textColor: ThemeColors.background,
//                   iconColor: ThemeColors.background,
//                   onPressed: () {
//                     Navigator.pushNamed(context, Login.path);
//                   },
//                   text: "Log In",
//                 ),
//                 ThemeButtonSmall(
//                   color: ThemeColors.white,
//                   textColor: ThemeColors.background,
//                   iconColor: ThemeColors.background,
//                   onPressed: () {
//                     Navigator.pushNamed(context, SignUp.path);
//                   },
//                   text: "Sign Up",
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 20.sp,
//             right: 30.sp,
//             left: 30.sp,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: ThemeColors.accent,
//                   elevation: 10,
//                   padding: EdgeInsets.all(10.sp)),
//               onPressed: () {
//                 Preference.setFirstTime(false);

//                 Navigator.pushNamedAndRemoveUntil(
//                     navigatorKey.currentContext!, Tabs.path, (route) => false);
//               },
//               child: Text(
//                 "Continue as Guest",
//                 style: stylePTSansBold(color: ThemeColors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class StartIndex extends StatefulWidget {
  static const path = "StartIndex";
  const StartIndex({super.key});

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
    ),
    StartClass(
      title: "Track Insider",
      colorText: 'Trades',
      description:
          "These insiders have been the most active in trading stocks.",
      color: ThemeColors.background,
    ),
    StartClass(
      title: "Most Discussed",
      colorText: 'Stocks!',
      description: "See most discussed stock data from social media.",
      color: ThemeColors.background,
    ),
    StartClass(
      title: "Latest Stock",
      colorText: 'News!',
      description: "Read latest news from wide range of media sources.",
      color: ThemeColors.background,
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
                itemCount: array.length,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    color: array[index].color,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          array[index].title,
                          style: stylePTSansBold(
                            fontSize: 45,
                          ),
                        ),
                        // Text(
                        //   array[index].colorText,
                        //   style: styleGeorgiaBold(fontSize: 45),
                        // ),
                        GradientText(
                          array[index].colorText,
                          style: stylePTSansBold(fontSize: 45),
                          colors: const [
                            Colors.purple,
                            Colors.red,
                            Colors.orange,
                          ],
                        ),
                        const SpacerVertical(height: 30),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.sp),
                          child: Text(
                            array[index].description,
                            textAlign: TextAlign.center,
                            style: styleGeorgiaBold(
                                fontSize: 15, color: ThemeColors.greyText),
                          ),
                        ),
                        const SpacerVertical(height: 80),
                      ],
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
                    fontBold: true,
                    color: ThemeColors.white,
                    textColor: ThemeColors.background,
                    onPressed: () {
                      Navigator.push(context, createRoute(const Login()));
                    },
                    text: "Log In",
                  ),
                  ThemeButtonSmall(
                    fontBold: true,
                    color: ThemeColors.white,
                    textColor: ThemeColors.background,
                    onPressed: () {
                      Navigator.push(context, createRoute(const SignUp()));
                    },
                    text: "Create new account",
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: ThemeButton(
                textSize: 15,
                onPressed: () {
                  Preference.setFirstTime(false);

                  Navigator.pushNamedAndRemoveUntil(
                      navigatorKey.currentContext!,
                      Tabs.path,
                      (route) => false);
                },
                text: "Continue as Guest",
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
  Color color;
  StartClass({
    required this.title,
    required this.description,
    required this.color,
    required this.colorText,
  });
}
