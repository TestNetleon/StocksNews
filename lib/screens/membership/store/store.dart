import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/membership/store/faq_item.dart';
import 'package:stocks_news_new/screens/membership/store/store_earn_more.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    List points = [
      {
        "icon": Images.advisor,
        "title": "Secure Transactions:",
        "text":
            "All purchases are processed securely via the App Store and Play Store",
      },
      {
        "icon": Images.advisor,
        "title": "Trusted Platform:",
        "text":
            "Join thousands of satisfied users who trust Points Central for their premium content needs.",
      },
      {
        "icon": Images.advisor,
        "title": "Instant Access:",
        "text":
            "Get immediate access to your points and start unlocking premium content and features right away.",
      },
      {
        "icon": Images.advisor,
        "title": "No Expiry:",
        "text":
            "Your points never expire, allowing you to use them whenever you need.",
      },
      {
        "icon": Images.advisor,
        "title": "Customer Support:",
        "text":
            "Our dedicated support team is always here to help you with any questions or issues.",
      },
      {
        "icon": Images.advisor,
        "title": "Flexible Bundles:",
        "text":
            " Choose from a variety of bundles to suit your needs and budget.",
      },
    ];

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
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 215, 255, 221), Colors.white],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SpacerVertical(height: 12),
                  Text(
                    "Points Central",
                    style: stylePTSansBold(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "Ran out of points? Get more at Points Central for premium content access!",
                    style: stylePTSansRegular(color: Colors.black),
                  ),
                  const SpacerVertical(height: 2),
                  // const Row(
                  //   children: [
                  //     PointsItem(points: "100", price: "\$100"),
                  //     SpacerHorizontal(width: 12),
                  //     PointsItem(points: "200", price: "\$200"),
                  //     SpacerHorizontal(width: 12),
                  //     PointsItem(points: "300", price: "\$300"),
                  //   ],
                  // ),
                  CustomGridView(
                    length: 4,
                    paddingVertical: 0,
                    itemSpace: 20,
                    paddingHorizontal: 0,
                    getChild: (index) {
                      if (index == 0) {
                        return const PointsItem(points: "100", price: "\$100");
                      } else if (index == 1) {
                        return const PointsItem(points: "200", price: "\$200");
                      } else if (index == 2) {
                        return const PointsItem(points: "300", price: "\$300");
                      } else {
                        return const PointsItem(points: "400", price: "\$400");
                      }
                    },
                  ),
                  const SpacerVertical(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 219, 243, 220),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: const Icon(
                                Icons.circle,
                                size: 12,
                                color: ThemeColors.themeGreen,
                              ),
                            ),
                            const SpacerHorizontal(width: 10),
                            // Flexible(
                            //   child: Text(
                            //     points[index]["title"],
                            //     style: stylePTSansBold(color: Colors.black),
                            //   ),
                            // ),
                            // Flexible(
                            //   child: Text(
                            //     points[index]["title"],
                            //     style: stylePTSansRegular(color: Colors.black),
                            //   ),
                            // ),
                            Flexible(
                              child: RichText(
                                // points[index]["title"],
                                // style: stylePTSansRegular(color: Colors.black),
                                text: TextSpan(
                                  text: """${points[index]["title"]} """,
                                  style: stylePTSansBold(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: points[index]["text"],
                                      style: stylePTSansRegular(
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SpacerVertical(height: 8);
                      },
                      itemCount: points.length,
                    ),
                  ),

                  const SpacerVertical(height: 15),
                  const StoreEarnMore(),
                  const SpacerVertical(height: 15),
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
                  ),
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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AspectRatio(
          aspectRatio: .88,
          child: Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 23, 254, 42),
                  Color.fromARGB(255, 217, 159, 0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Color of the shadow
                  spreadRadius: 5, // Spread radius
                  blurRadius: 7, // Blur radius
                  offset: const Offset(0, 3), // Offset from the box
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              // margin: const EdgeInsets.only(top: 50),
              // constraints: const BoxConstraints(
              //   maxWidth: 250,
              //   minWidth: 150,
              // ),
              decoration: BoxDecoration(
                color: ThemeColors.tabBack,
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  opacity: .5,
                  image: AssetImage(Images.storeBack),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SpacerVertical(height: 20),
                  // Text(
                  //   "Get",
                  //   style: stylePTSansRegular(),
                  //   textAlign: TextAlign.center,
                  // ),
                  // const SpacerVertical(height: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              points,
                              style: stylePTSansBold(fontSize: 34).copyWith(
                                height: 0,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SpacerHorizontal(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Points",
                                style:
                                    stylePTSansRegular(fontSize: 16).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SpacerVertical(height: 2),
                        // Text(
                        //   "Unlimited Validity",
                        //   style: stylePTSansRegular(fontSize: 14),
                        //   textAlign: TextAlign.center,
                        // ),
                      ],
                    ),
                  ),
                  const SpacerVertical(height: 12),

                  // Text(
                  //   "Points",
                  //   style: stylePTSansRegular(),
                  //   textAlign: TextAlign.center,
                  // ),
                  // // const SpacerVertical(height: 2),
                  // // Text(
                  // //   "in Just",
                  // //   style: stylePTSansRegular(),
                  // //   textAlign: TextAlign.center,
                  // // ),
                  // const SpacerVertical(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Buy Now - $price",
                          style: stylePTSansRegular(fontSize: 16).copyWith(
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        const SpacerHorizontal(width: 10),
                        Image.asset(
                          Images.buyPoints,
                          color: Colors.white,
                          width: 18,
                          height: 18,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
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
        ),
      ],
    );
  }
}
