import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/membership/store/faq_item.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  // height: 200,
                  decoration: const BoxDecoration(
                    color: ThemeColors.tabBack,
                    // borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 65, 171, 83),
                        Color.fromARGB(255, 1, 122, 44),
                      ],
                    ),
                  ),
                  child: Image.asset(
                    Images.storeBanner,
                    // width: 30,
                    // height: 30,
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   child: Container(
                //     width: ScreenUtil().screenWidth,
                //     padding: const EdgeInsets.all(16),
                //     decoration: const BoxDecoration(
                //       gradient: LinearGradient(
                //         colors: [Colors.transparent, ThemeColors.background],
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //       ),
                //     ),
                //     // child: Column(
                //     //   crossAxisAlignment: CrossAxisAlignment.start,
                //     //   children: [
                //     //     Text(
                //     //       "Running out of points?",
                //     //       style: stylePTSansBold(fontSize: 18),
                //     //     ),
                //     //     const SpacerVertical(height: 2),
                //     //     Text(
                //     //       "Check out our plans to continue using our features.",
                //     //       style: stylePTSansRegular(),
                //     //     ),
                //     //   ],
                //     // ),
                //   ),
                // )
              ],
            ),
            const SpacerVertical(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacerVertical(height: 12),
                  Text(
                    "Select Points Bundle",
                    style: stylePTSansBold(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "Running out of points? Check out our plans to continue using our features.",
                    style: stylePTSansRegular(color: Colors.black),
                  ),
                  const SpacerVertical(height: 2),
                  const Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PointsItem(points: "100", price: "\$100"),
                      SpacerHorizontal(width: 12),
                      PointsItem(points: "200", price: "\$200"),
                      SpacerHorizontal(width: 12),
                      PointsItem(points: "300", price: "\$300"),
                    ],
                  ),
                  const SpacerVertical(height: 20),
                  Text(
                    "Frequently Asked Questions",
                    style: stylePTSansBold(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SpacerVertical(height: 15),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return const FaqItem(
                        question: "Lorem Ipsum dummy text!!!",
                        answer: "Lorem Ipsum dummy text!!!",
                        openIndex: 1,
                        index: 0,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SpacerVertical(height: 12);
                    },
                    itemCount: 5,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PointsItem extends StatelessWidget {
  final String points;
  final String price;

  const PointsItem({
    super.key,
    required this.points,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  color: ThemeColors.tabBack,
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    opacity: .5,
                    image: AssetImage(
                      Images.storeBack,
                    ),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 1, 87, 15),
                      Color.fromARGB(255, 128, 197, 151),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const SpacerVertical(height: 20),
                    Text(
                      "Get",
                      style: stylePTSansRegular(),
                      textAlign: TextAlign.center,
                    ),
                    const SpacerVertical(height: 5),
                    Text(
                      points,
                      style: stylePTSansBold(fontSize: 28).copyWith(
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SpacerVertical(height: 2),
                    Text(
                      "Points",
                      style: stylePTSansRegular(),
                      textAlign: TextAlign.center,
                    ),
                    // const SpacerVertical(height: 2),
                    // Text(
                    //   "in Just",
                    //   style: stylePTSansRegular(),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SpacerVertical(height: 5),
                    Text(
                      price,
                      style: stylePTSansBold(fontSize: 20).copyWith(
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            // decoration: const BoxDecoration(
            //   color: ThemeColors.tabBack,
            //   // borderRadius: BorderRadius.circular(6),
            //   shape: BoxShape.circle,
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [
            //       Color.fromARGB(255, 1, 87, 15),
            //       Color.fromARGB(255, 128, 197, 151),
            //     ],
            //   ),
            // ),
            // child: const Icon(Icons.star, size: 36),
            child: Image.asset(
              Images.starAffiliate,
              width: 60,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }
}
