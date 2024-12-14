// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/custom/refer.dart';
// import '../../../../../route/my_app.dart';
// import '../../../../widgets/custom/update_membership.dart';

// class ReferPurchaseSlider extends StatefulWidget {
//   const ReferPurchaseSlider({super.key});

//   @override
//   State<ReferPurchaseSlider> createState() => _ReferPurchaseSliderState();
// }

// //
// class _ReferPurchaseSliderState extends State<ReferPurchaseSlider> {
//   void _newsDetail({String? slug}) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (_) => NewsDetails(slug: slug),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserProvider provider = context.watch<UserProvider>();
//     HomeProvider homeProvider = context.watch<HomeProvider>();
//     // bool showReferral = provider.extra?.referral?.shwReferral ?? false;
//     bool showReferral = homeProvider.extra?.referral?.shwReferral ?? false;

//     bool purchased = provider.user?.membership?.purchased == 1;

//     if (!showReferral && !showMembership) {
//       return const SizedBox();
//     }

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double imageHeight = constraints.maxWidth * 0.24;
//         return CarouselSlider(
//             options: CarouselOptions(
//               height: imageHeight,
//               autoPlay: showReferral && !purchased && showMembership,
//               autoPlayInterval: const Duration(seconds: 5),
//               autoPlayAnimationDuration: const Duration(milliseconds: 800),
//               pauseAutoPlayOnTouch: true,
//               viewportFraction: 1,
//               scrollPhysics: showReferral && !purchased && showMembership
//                   ? const AlwaysScrollableScrollPhysics()
//                   : const NeverScrollableScrollPhysics(),
//               autoPlayCurve: Curves.fastOutSlowIn,
//             ),
//             items: [
//               if (showReferral) const ReferApp(),
//               if (showMembership && !purchased) const UpdateMembershipCard(),
//             ]);
//       },
//     );
//   }
// }
