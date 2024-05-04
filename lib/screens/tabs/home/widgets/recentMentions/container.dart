import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/recentMentions/item.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class MostRecentMentions extends StatefulWidget {
  const MostRecentMentions({super.key});

  @override
  State<MostRecentMentions> createState() => _MostRecentMentionsState();
}

//
class _MostRecentMentionsState extends State<MostRecentMentions> {
  // final PageController _pageController = PageController(
  //   initialPage: 0,
  //   viewportFraction: 1,
  // );
  int currentIndex = 0;

  // Timer? _autoscrollTimer;
  // bool _autoscrollEnabled = true;

  CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   _autoscrollTimer?.cancel();
  //   super.dispose();
  // }

  // void _startAutoscroll() {
  //   _autoscrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
  //     List<RecentMention>? recentMentions =
  //         context.read<HomeProvider>().homeInsiderRes?.recentMentions;
  //     if (_autoscrollEnabled) {
  //       final nextPage = (currentIndex + 1) % (recentMentions?.length ?? 0);
  //       _pageController.animateToPage(
  //         nextPage,
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   });
  // }

  // void _onPageChange(index) {
  //   currentIndex = index;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    List<RecentMention>? recentMentions =
        context.watch<HomeProvider>().homeInsiderRes?.recentMentions;
    return Column(
      children: [
        const ScreenTitle(title: "Most Recent Mentions"),
        // Text(
        //   "Discover trending stocks with our real-time data. This section highlights the most mentioned stocks in news in the past hour.",
        //   style: stylePTSansRegular(fontSize: 12),
        // ),
        // const SpacerVertical(height: 10),
        // LayoutBuilder(
        //   builder: (context, constraints) {
        //     return Stack(
        //       alignment: Alignment.center,
        //       children: [
        //         SizedBox(
        //           height: constraints.maxWidth * 0.4,
        //           child: PageView.builder(
        //             controller: _pageController,
        //             itemCount: recentMentions?.length,
        //             onPageChanged: (index) => _onPageChange(index),
        //             itemBuilder: (context, index) {
        //               if (recentMentions == null) {
        //                 return const SizedBox();
        //               }
        //               RecentMention data = recentMentions[index];
        //               return RecentMentionsItem(
        //                 constraints: constraints,
        //                 data: data,
        //                 onJumpNext: currentIndex == recentMentions.length - 1
        //                     ? () {
        //                         _pageController.jumpToPage(0);
        //                       }
        //                     : () {
        //                         _pageController.animateToPage(
        //                           currentIndex + 1,
        //                           duration: const Duration(milliseconds: 500),
        //                           curve: Curves.easeInOut,
        //                         );
        //                       },
        //                 onJumpBack: currentIndex == 0
        //                     ? () {
        //                         _pageController.jumpToPage(
        //                           recentMentions.length - 1,
        //                         );
        //                       }
        //                     : () {
        //                         _pageController.animateToPage(
        //                           currentIndex - 1,
        //                           duration: const Duration(milliseconds: 500),
        //                           curve: Curves.easeInOut,
        //                         );
        //                       },
        //               );
        //             },
        //           ),
        //         ),
        //       ],
        //     );
        //   },
        // ),
        LayoutBuilder(
          builder: (context, constraints) {
            double imageHeight = constraints.maxWidth * 0.4;
            return CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: imageHeight,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                pauseAutoPlayOnTouch: true,
                viewportFraction: 1,
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  currentIndex = index;
                  setState(() {});
                },
              ),
              items: recentMentions?.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return RecentMentionsItem(
                      constraints: constraints,
                      data: i,
                      onJumpBack: () {
                        log("Going to previous page");
                        _carouselController.previousPage();
                      },
                      onJumpNext: () {
                        _carouselController.nextPage();
                      },
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
        const SpacerVertical(height: 20),
      ],
    );
  }
}
