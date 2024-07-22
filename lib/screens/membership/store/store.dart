import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/store_info_res.dart';
import 'package:stocks_news_new/providers/store_provider.dart';
import 'package:stocks_news_new/screens/membership/store/faq_item.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //
      getStoreInfo();
    });
  }

  void getStoreInfo() {
    StoreProvider provider = context.read<StoreProvider>();

    provider.getStoreInfo();
  }

  @override
  Widget build(BuildContext context) {
    StoreProvider provider = context.watch<StoreProvider>();
    StoreInfoRes? data = provider.data;

    // List points = [
    //   {
    //     "icon": Images.advisor,
    //     "title": "Secure Transactions:",
    //     "text":
    //         "All purchases are processed securely via the App Store and Play Store",
    //   },
    //   {
    //     "icon": Images.advisor,
    //     "title": "Trusted Platform:",
    //     "text":
    //         "Join thousands of satisfied users who trust Points Central for their premium content needs.",
    //   },
    //   {
    //     "icon": Images.advisor,
    //     "title": "Instant Access:",
    //     "text":
    //         "Get immediate access to your points and start unlocking premium content and features right away.",
    //   },
    //   {
    //     "icon": Images.advisor,
    //     "title": "No Expiry:",
    //     "text":
    //         "Your points never expire, allowing you to use them whenever you need.",
    //   },
    //   {
    //     "icon": Images.advisor,
    //     "title": "Customer Support:",
    //     "text":
    //         "Our dedicated support team is always here to help you with any questions or issues.",
    //   },
    //   {
    //     "icon": Images.advisor,
    //     "title": "Flexible Bundles:",
    //     "text":
    //         " Choose from a variety of bundles to suit your needs and budget.",
    //   },
    // ];

    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
      ),
      body: BaseUiContainer(
        hasData: !provider.isLoading && data != null,
        isLoading: provider.isLoading,
        error: provider.error,
        showPreparingText: true,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  Images.start3,
                  fit: BoxFit.fill,
                  height: 350,
                  opacity: const AlwaysStoppedAnimation(.5),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data?.title}",
                          style: stylePTSansBold(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Text(
                          "${data?.subTitle}",
                          style: stylePTSansRegular(color: Colors.white),
                        ),
                      ],
                    ),
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
                        stops: [0.0, 0.4],
                        colors: [
                          Color.fromARGB(255, 138, 255, 156),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Your Points Bundle",
                          style: stylePTSansBold(
                            color: Colors.black,
                            fontSize: 28,
                          ),
                        ),
                        // const SpacerVertical(height: 5),
                        // Text(
                        //   "Ran out of points? Get more at Points Central for premium content access!",
                        //   style: stylePTSansRegular(color: Colors.black),
                        // ),
                        CustomGridView(
                          length: data?.points.length ?? 0,
                          paddingVertical: 0,
                          itemSpace: 20,
                          paddingHorizontal: 0,
                          getChild: (index) {
                            return PointsItem(
                              points: "${data?.points[index].point}",
                              price: "${data?.points[index].price}",
                              onTap: () {
                                RevenueCatService.initializeSubscription(
                                    type: data?.points[index].lookupKey);
                              },
                            );
                          },
                        ),
                        const SpacerVertical(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 206, 245, 212),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(
                                  //   margin: const EdgeInsets.only(top: 4),
                                  //   child: const Icon(
                                  //     Icons.circle,
                                  //     size: 12,
                                  //     color: ThemeColors.themeGreen,
                                  //   ),
                                  // ),
                                  Container(
                                    height: 17,
                                    width: 17,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ThemeColors.white,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  const SpacerHorizontal(width: 10),
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            "${data?.benefits?[index].question}: ",
                                        style: stylePTSansBold(
                                            color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text:
                                                "${data?.benefits?[index].answer}",
                                            style: stylePTSansRegular(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );

                              // return Container(
                              //   width: double.infinity,
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 15, vertical: 40),
                              //   color: index % 2 == 0
                              //       ? Colors.black
                              //       : const Color.fromARGB(255, 22, 22, 22),
                              //   child: Column(
                              //     children: [
                              //       // const SpacerVertical(height: 10),
                              //       Text(
                              //         "${data?.benefits?[index].question}",
                              //         textAlign: TextAlign.center,
                              //         style: styleSansBold(
                              //           // color: Colors.black,
                              //           color: ThemeColors.themeGreen,
                              //           fontSize: 20,
                              //         ),
                              //       ),
                              //       const SpacerVertical(height: 10),
                              //       Text(
                              //         textAlign: TextAlign.center,
                              //         "${data?.benefits?[index].answer}",
                              //         style: stylePTSansRegular(
                              //           // color: Colors.black,
                              //           color: Colors.white,
                              //           fontSize: 16,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            },
                            separatorBuilder: (context, index) {
                              return const SpacerVertical(height: 8);
                            },
                            itemCount: data?.benefits?.length ?? 0,
                          ),
                        ),
                        const SpacerVertical(height: 15),
                        // const StoreEarnMore(),
                        // const SpacerVertical(height: 15),
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
                            return FaqItem(
                              question: "${data?.faq?[index].question}",
                              answer: "${data?.faq?[index].answer}",
                              openIndex: provider.faqOpenIndex,
                              index: index,
                              provider: provider,
                              textColor: Colors.black,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SpacerVertical(height: 12);
                          },
                          itemCount: data?.faq?.length ?? 0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PointsItem extends StatelessWidget {
  final String points;
  final String price;
  final Function()? onTap;

  const PointsItem({
    super.key,
    required this.points,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // AspectRatio(
          //   aspectRatio: .88,
          //   child: Container(
          //     padding: const EdgeInsets.all(2),
          //     margin: const EdgeInsets.only(top: 50),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       gradient: const LinearGradient(
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //         colors: [
          //           Color.fromARGB(255, 23, 254, 42),
          //           Color.fromARGB(255, 217, 159, 0),
          //         ],
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.5), // Color of the shadow
          //           spreadRadius: 5, // Spread radius
          //           blurRadius: 7, // Blur radius
          //           offset: const Offset(0, 3), // Offset from the box
          //         ),
          //       ],
          //     ),
          //     child: Container(
          //       width: double.infinity,
          //       padding: const EdgeInsets.all(12),
          //       // margin: const EdgeInsets.only(top: 50),
          //       // constraints: const BoxConstraints(
          //       //   maxWidth: 250,
          //       //   minWidth: 150,
          //       // ),
          //       decoration: BoxDecoration(
          //         color: ThemeColors.tabBack,
          //         borderRadius: BorderRadius.circular(10),
          //         image: const DecorationImage(
          //           fit: BoxFit.cover,
          //           opacity: .5,
          //           image: AssetImage(Images.storeBack),
          //         ),
          //         gradient: const LinearGradient(
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //           colors: [
          //             Color.fromARGB(255, 1, 87, 15),
          //             Color.fromARGB(255, 128, 197, 151),
          //           ],
          //         ),
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           // const SpacerVertical(height: 20),
          //           // Text(
          //           //   "Get",
          //           //   style: stylePTSansRegular(),
          //           //   textAlign: TextAlign.center,
          //           // ),
          //           // const SpacerVertical(height: 5),
          //           Expanded(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: [
          //                 Row(
          //                   crossAxisAlignment: CrossAxisAlignment.end,
          //                   children: [
          //                     Text(
          //                       points,
          //                       style: stylePTSansBold(fontSize: 34).copyWith(
          //                         height: 0,
          //                         fontWeight: FontWeight.w900,
          //                         shadows: [
          //                           Shadow(
          //                             blurRadius: 10.0,
          //                             color: Colors.black.withOpacity(0.5),
          //                             offset: const Offset(2.0, 2.0),
          //                           ),
          //                         ],
          //                       ),
          //                       textAlign: TextAlign.center,
          //                     ),
          //                     const SpacerHorizontal(width: 10),
          //                     Padding(
          //                       padding: const EdgeInsets.only(bottom: 5),
          //                       child: Text(
          //                         "Points",
          //                         style:
          //                             stylePTSansRegular(fontSize: 16).copyWith(
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 // const SpacerVertical(height: 2),
          //                 // Text(
          //                 //   "Unlimited Validity",
          //                 //   style: stylePTSansRegular(fontSize: 14),
          //                 //   textAlign: TextAlign.center,
          //                 // ),
          //               ],
          //             ),
          //           ),
          //           const SpacerVertical(height: 12),
          //           // Text(
          //           //   "Points",
          //           //   style: stylePTSansRegular(),
          //           //   textAlign: TextAlign.center,
          //           // ),
          //           // // const SpacerVertical(height: 2),
          //           // // Text(
          //           // //   "in Just",
          //           // //   style: stylePTSansRegular(),
          //           // //   textAlign: TextAlign.center,
          //           // // ),
          //           // const SpacerVertical(height: 5),
          //           Container(
          //             width: double.infinity,
          //             padding: const EdgeInsets.symmetric(
          //                 vertical: 6, horizontal: 8),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(30),
          //               color: Colors.black,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Flexible(
          //                   child: Text(
          //                       maxLines: 1,
          //                       "Buy @ $price",
          //                       overflow: TextOverflow.ellipsis,
          //                       style: stylePTSansRegular(
          //                           fontSize: Platform.isAndroid ? 12 : 16)),
          //                 ),
          //                 const SpacerHorizontal(width: 2),
          //                 Image.asset(
          //                   Images.buyPoints,
          //                   color: Colors.white,
          //                   width: 15,
          //                   height: 15,
          //                 )
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          Container(
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
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
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
                        RichText(
                          text: TextSpan(
                              text: points,
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
                              children: [
                                TextSpan(
                                  text: "  Points",
                                  style:
                                      stylePTSansRegular(fontSize: 16).copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ]),
                        ),

                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [
                        //     Text(
                        //       points,
                        //       style: stylePTSansBold(fontSize: 34).copyWith(
                        //         height: 0,
                        //         fontWeight: FontWeight.w900,
                        //         shadows: [
                        //           Shadow(
                        //             blurRadius: 10.0,
                        //             color: Colors.black.withOpacity(0.5),
                        //             offset: const Offset(2.0, 2.0),
                        //           ),
                        //         ],
                        //       ),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //     const SpacerHorizontal(width: 10),
                        //     Flexible(
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(bottom: 5),
                        //         child: Text(
                        //           "Points",
                        //           maxLines: 1,
                        //           overflow: TextOverflow.ellipsis,
                        //           style:
                        //               stylePTSansRegular(fontSize: 16).copyWith(
                        //             fontWeight: FontWeight.w600,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

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
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Buy @ $price",
                            textAlign: TextAlign.center,
                            style: stylePTSansRegular(
                              // fontSize: Platform.isAndroid ? 12 : 16,
                              fontSize: Platform.isAndroid ? 12 : 16,
                            ),
                          ),
                        ),
                        const SpacerHorizontal(width: 2),
                        Image.asset(
                          Images.buyPoints,
                          color: Colors.white,
                          width: 15,
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5,
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  Images.pointIcon2,
                  width: 55,
                  height: 55,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
