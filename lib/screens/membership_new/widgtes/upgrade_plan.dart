import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
import 'package:stocks_news_new/providers/membership.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../providers/user_provider.dart';
import '../../../route/my_app.dart';
import '../../../service/revenue_cat.dart';
import '../../auth/membershipAsk/ask.dart';

// class NewMembershipUpgradeCurrentPlan extends StatefulWidget {
//   final bool withClickCondition;

//   const NewMembershipUpgradeCurrentPlan(
//       {super.key, this.withClickCondition = false});

//   @override
//   State<NewMembershipUpgradeCurrentPlan> createState() =>
//       _NewMembershipUpgradeCurrentPlanState();
// }

// class _NewMembershipUpgradeCurrentPlanState
//     extends State<NewMembershipUpgradeCurrentPlan> {
//   List<bool> isSelectedList = List.generate(3, (_) => false);
//   int selectedIndex = -1;

//   Future _subscribe() async {
//     UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
//     if (provider.user == null) {
//       Utils().showLog("---ask to login----");
//       isPhone ? await loginSheet() : await loginSheetTablet();
//     }
//     if (provider.user == null) {
//       Utils().showLog("---still user not found----");

//       return;
//     }
//     if (provider.user?.membership?.purchased == 1) {
//       Utils().showLog("---found user is already having membership----");

//       Navigator.pop(context);
//     }
//     if (provider.user?.phone == null || provider.user?.phone == '') {
//       Utils().showLog("---asking for phone number verification----");

//       await membershipLogin();
//     }

//     if (provider.user?.phone != null &&
//         provider.user?.phone != '' &&
//         provider.user?.membership?.purchased == 0) {
//       await RevenueCatService.initializeSubscription();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     MembershipProvider provider = context.watch<MembershipProvider>();
//     MembershipInfoRes? data = provider.membershipInfoRes;

//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
//           child: HtmlWidget(
//             data?.title ?? '',
//             textStyle: stylePTSansBold(fontSize: 26),
//           ),
//         ),
//         const SpacerVertical(height: 10),
//         GestureDetector(
//           onTap: () {
//             setState(() {});
//           },
//           child: Container(
//             width: MediaQuery.of(context).size.width / 1.05,
//             decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   stops: [0.2, 0.65],
//                   colors: [
//                     Color.fromARGB(255, 32, 128, 65),
//                     Color.fromARGB(255, 22, 22, 22),
//                   ],
//                 ),
//                 border: Border.all(color: Colors.green),
//                 borderRadius: BorderRadius.circular(10.0)),
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       // width: 60,
//                       decoration: const BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10.0),
//                               topRight: Radius.circular(10.0),
//                               bottomLeft: Radius.circular(10.0))),
//                       padding: const EdgeInsets.all(8.0),
//                       child: Center(
//                         child: Text(
//                           data?.plan.name ?? 'Premium member',
//                           style: stylePTSansBold(
//                               fontSize: 16, color: Colors.black),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       data?.plan.price ?? '\$19.99/month',
//                       style: stylePTSansBold(fontSize: 16, color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 const SpacerVertical(
//                   height: 15,
//                 ),
//                 Visibility(
//                   visible: data?.plan.features != null &&
//                       data?.plan.features?.isNotEmpty == true,
//                   child: ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return Row(
//                         children: [
//                           Container(
//                             height: 20,
//                             width: 20,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: ThemeColors.white,
//                             ),
//                             // padding: const EdgeInsets.all(8),
//                             child: const Center(
//                               child: Icon(
//                                 Icons.check,
//                                 color: Colors.green,
//                                 size: 16,
//                               ),
//                             ),
//                           ),
//                           const SpacerHorizontal(
//                             width: 6,
//                           ),
//                           Flexible(
//                             // child: Text(
//                             //   '${data?.plan.features?[index]}',
//                             //   style: stylePTSansRegular(
//                             //       fontSize: 16, color: Colors.white),
//                             // ),
//                             child: HtmlWidget(
//                               '${data?.plan.features?[index]}',
//                               textStyle: const TextStyle(
//                                   color: ThemeColors.white,
//                                   height: 1.5,
//                                   fontFamily: Fonts.ptSans,
//                                   fontSize: 16),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return const SpacerVertical(height: 20);
//                     },
//                     itemCount: data?.plan.features?.length ?? 0,
//                   ),
//                 ),
//                 const SpacerVertical(height: 20),
//                 MyElevatedButton(
//                   width: double.infinity,
//                   onPressed: () {
//                     // if (widget.withClickCondition) {
//                     //   _subscribe();
//                     // } else {
//                     //   RevenueCatService.initializeSubscription();
//                     // }
//                     RevenueCatService.initializeSubscription();

//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) =>
//                     //         const SubscriptionPurchased(isMembership: true),
//                     //   ),
//                     // );
//                   },
//                   borderRadius: BorderRadius.circular(10),
//                   child: Text(
//                     'Continue',
//                     style: stylePTSansBold(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//                 const SpacerVertical(height: 10),
//                 Center(
//                   child: Text(
//                     Platform.isAndroid
//                         ? 'Cancel anytime. Secured by the Play Store.'
//                         : 'Cancel anytime. Secured by the App Store.',
//                     textAlign: TextAlign.center,
//                     style: stylePTSansRegular(fontSize: 12, color: Colors.grey),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SpacerVertical(height: 10),
//       ],
//     );
//   }
// }

class NewMembershipUpgradeCurrentPlan extends StatefulWidget {
  final bool withClickCondition;

  const NewMembershipUpgradeCurrentPlan({
    super.key,
    this.withClickCondition = false,
  });

  @override
  State<NewMembershipUpgradeCurrentPlan> createState() =>
      _NewMembershipUpgradeCurrentPlanState();
}

class _NewMembershipUpgradeCurrentPlanState
    extends State<NewMembershipUpgradeCurrentPlan> {
  List<bool> isSelectedList = List.generate(3, (_) => false);
  int selectedIndex = -1;

  // Future _subscribe({type}) async {
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  //   if (provider.user == null) {
  //     Utils().showLog("---ask to login----");
  //     isPhone ? await loginSheet() : await loginSheetTablet();
  //   }
  //   if (provider.user == null) {
  //     Utils().showLog("---still user not found----");

  //     return;
  //   }
  //   // if (provider.user?.membership?.purchased == 1 &&
  //   //     (provider.user?.membership?.canUpgrade == false ||
  //   //         provider.user?.membership?.canUpgrade == null)) {
  //   //   Utils().showLog("---found user is already having membership----");

  //   //   Navigator.pop(context);
  //   // }
  //   if (provider.user?.membership?.purchased == 1 &&
  //       (provider.user?.membership?.canUpgrade == false ||
  //           provider.user?.membership?.canUpgrade == null)) {
  //     Utils().showLog("---found user is already having membership----");

  //     Navigator.pop(context);
  //   }

  //   if (provider.user?.phone == null || provider.user?.phone == '') {
  //     Utils().showLog("---asking for phone number verification----");

  //     await membershipLogin();
  //   }

  //   if (provider.user?.phone != null && provider.user?.phone != ''
  //       // && provider.user?.membership?.purchased == 0
  //       ) {
  //     await RevenueCatService.initializeSubscription(type: type);
  //   }
  // }

  Future _subscribe({type, required int index}) async {
    UserProvider? provider = navigatorKey.currentContext!.read<UserProvider>();
    MembershipProvider? membershipProvider =
        navigatorKey.currentContext!.read<MembershipProvider>();

    if (provider.user == null) {
      Utils().showLog("Ask login-----");
      isPhone ? await loginSheet() : await loginSheetTablet();

      if (provider.user?.membership?.purchased == 1) {
        Utils().showLog("---user already purchased membership----");
        await membershipProvider.getMembershipInfo();
        // membershipProvider.selectedIndex(index);
      }
    }

    if (provider.user == null) {
      Utils().showLog("---still user not found----");
      return;
    }

    if (membershipProvider.membershipInfoRes?.plans?[index].activeText != '' &&
        membershipProvider.membershipInfoRes?.plans?[index].activeText !=
            null) {
      Utils().showLog("---As this membership is already purchased----");
      return;
    }

    if (provider.user?.phone == null || provider.user?.phone == '') {
      Utils().showLog("Ask phone for membership-----");
      await membershipLogin();
      return;
    }
    if (provider.user?.phone != null || provider.user?.phone != '') {
      Utils().showLog("Open Paywall-----");
      await RevenueCatService.initializeSubscription(type: type);
    }
  }

  @override
  Widget build(BuildContext context) {
    MembershipProvider provider = context.watch<MembershipProvider>();
    MembershipInfoRes? data = provider.membershipInfoRes;

    // UserProvider userProvider = context.watch<UserProvider>();
    // UserRes? user = userProvider.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider.membershipInfoRes?.newTitle ?? "",
            style: stylePTSansBold(color: Colors.white, fontSize: 30),
          ),
          Visibility(
            // visible: data?.plan.features != null &&
            //           data?.plan.features?.isNotEmpty == true,
            visible: data?.newFeatures?.isNotEmpty == true,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 7,
                      width: 7,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ThemeColors.white,
                      ),
                    ),
                    const SpacerHorizontal(width: 6),
                    Flexible(
                      child: HtmlWidget(
                        '${data?.newFeatures?[index]}',
                        textStyle: const TextStyle(
                          color: ThemeColors.white,
                          height: 1.5,
                          fontFamily: Fonts.ptSans,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerVertical(height: 15);
              },
              itemCount: data?.newFeatures?.length ?? 0,
            ),
          ),
          const SpacerVertical(height: 20),
          Text(
            data?.selectTitle ?? "",
            style: styleSansBold(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          // SpacerVertical(height: 5),
          // HtmlWidget(
          //   data?.selectTitle ?? "",
          //   textStyle: const TextStyle(
          //     color: ThemeColors.white,
          //     height: 1.5,
          //     fontFamily: Fonts.ptSans,
          //     fontSize: 16,
          //   ),
          // ),
          const SpacerVertical(height: 25),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Plan? plan = data?.plans?[index];

              return GestureDetector(
                // onTap: index == 0 && user?.membership?.canUpgrade == true
                //     ? null
                //     : () {
                //         if (widget.withClickCondition) {
                //           _subscribe(type: plan?.type);
                //         } else {
                //           RevenueCatService.initializeSubscription(
                //               type: plan?.type);
                //         }

                //         for (int i = 0; i < (data?.plans?.length ?? 0); i++) {
                //           data?.plans?[i].selected = false;
                //         }

                //         plan?.selected = true;

                //         setState(() {});
                //       },
                onTap: plan?.activeText != null && plan?.activeText != ''
                    ? null
                    : () {
                        _subscribe(
                          type: plan?.type,
                          index: index,
                        );

                        provider.selectedIndex(index);
                        setState(() {});
                      },

                child: Column(
                  children: [
                    Visibility(
                      // visible:
                      //     index == 0 && user?.membership?.canUpgrade == true,

                      visible:
                          plan?.activeText != null && plan?.activeText != '',

                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        decoration: const BoxDecoration(
                          // color: Colors.yellow,
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromARGB(255, 1, 101, 16),
                              ThemeColors.accent
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          plan?.activeText ?? "Your current plan",
                          style: styleSansBold(
                              fontSize: 16, color: ThemeColors.white),
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width / 1.05,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.2, 0.65],
                          colors: [
                            // index == 0 && user?.membership?.canUpgrade == true
                            plan?.activeText != null && plan?.activeText != ''
                                ? const Color(0xFF434343)
                                : const Color(0xFF064E1F),
                            const Color(0xFF161616),
                          ],
                        ),
                        border: Border.all(
                          color:
                              // index == 0 && user?.membership?.canUpgrade == true
                              plan?.activeText != null && plan?.activeText != ''
                                  ? Colors.grey
                                  : Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0))),
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    plan?.name ?? "",
                                    style: stylePTSansBold(
                                        fontSize: 17, color: Colors.black),
                                  ),
                                ),
                              ),
                              const SpacerHorizontal(width: 10),
                              // index == 0 && user?.membership?.canUpgrade == true
                              //     ? SizedBox()
                              //     :

                              Visibility(
                                visible: plan?.activeText == null ||
                                    plan?.activeText == '',
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: ThemeColors.white,
                                      width: 2,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    padding: const EdgeInsets.all(6.7),
                                    decoration: BoxDecoration(
                                      color: plan?.selected == true
                                          ? ThemeColors.white
                                          : null,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SpacerVertical(height: 12),
                          Text(
                            plan?.price ?? "",
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SpacerVertical(height: 10),
                          HtmlWidget(
                            plan?.billed ?? "",
                            textStyle: stylePTSansRegular(
                                fontSize: 16, color: ThemeColors.greyText),
                          ),
                          const SpacerVertical(height: 10),
                          Text(
                            plan?.description ?? "",
                            style: stylePTSansBold(
                                fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SpacerVertical(height: 20);
            },
            itemCount: data?.plans?.length ?? 0,
          ),
          const SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
