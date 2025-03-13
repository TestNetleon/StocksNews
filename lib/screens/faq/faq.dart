// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/faq_provider.dart';
// import 'package:stocks_news_new/screens/faq/faq_container.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';
// import 'package:stocks_news_new/widgets/error_display_common.dart';
// import 'package:stocks_news_new/widgets/loading.dart';

// import '../../widgets/custom/refresh_indicator.dart';

// class FAQBase extends StatefulWidget {
//   const FAQBase({super.key});
// //
//   @override
//   State<FAQBase> createState() => _FAQBaseState();
// }

// class _FAQBaseState extends State<FAQBase> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _callApi();
//     });
//   }

//   _callApi() {
//     FaqProvide provider = context.read<FaqProvide>();
//     if (provider.data == null || provider.data?.isEmpty == true) {
//       context.read<FaqProvide>().getFAQs();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseContainer(
//       appBar: const AppBarHome(
//         isPopBack: true,
//         title: "Frequently Asked Questions",
//       ),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(
//           Dimen.padding,
//           // Dimen.padding.sp,
//           0,
//           Dimen.padding,
//           0,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // const ScreenTitle(title: "Frequently Asked Questions"),
//             Expanded(child: _getWidget()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _getWidget() {
//     FaqProvide provider = context.watch<FaqProvide>();
//     return provider.isLoading
//         ? const Loading()
//         : provider.data != null
//             ? CommonRefreshIndicator(
//                 onRefresh: () => provider.getFAQs(),
//                 child: const FAQContainer())
//             : ErrorDisplayWidget(
//                 error: provider.error,
//                 onRefresh: provider.getFAQs,
//               );
//   }
// }
