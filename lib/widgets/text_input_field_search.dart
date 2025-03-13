// import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/search_res.dart';
// import 'package:stocks_news_new/providers/search_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/screens/search/search.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// import '../screens/stockDetail/index.dart';

// //
// class TextInputFieldSearch extends StatefulWidget {
//   const TextInputFieldSearch({
//     // required this.controller,
//     required this.onSubmitted,
//     this.maxLength = 40,
//     this.minLines = 1,
//     this.editable = false,
//     this.shadow = true,
//     this.borderColor,
//     this.style,
//     this.hintText,
//     this.searching = false,
//     super.key,
//     this.radius,
//     this.contentPadding,
//     this.openConstraints = true,
//   });

//   // final TextEditingController controller;
//   final int maxLength;
//   final int minLines;
//   final bool editable;
//   final bool shadow;
//   final TextStyle? style;
//   final Color? borderColor;
//   final String? hintText;
//   final Function(String) onSubmitted;
//   final bool searching;
//   final double? radius;
//   final EdgeInsets? contentPadding;
//   final bool openConstraints;
//   @override
//   State<TextInputFieldSearch> createState() => _TextInputFieldSearchState();
// }

// class _TextInputFieldSearchState extends State<TextInputFieldSearch> {
//   final TextEditingController controller = TextEditingController();
//   // Timer? _timer;

//   @override
//   void dispose() {
//     // _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SearchProvider provider = context.watch<SearchProvider>();
//     var outlineInputBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(widget.radius?.r ?? Dimen.radius.r),
//       borderSide: BorderSide(
//         color: widget.borderColor ?? ThemeColors.primaryLight,
//         width: 1,
//       ),
//     );
//     return GestureDetector(
//       onTap: () => widget.editable
//           ? {}
//           : Navigator.push(
//               navigatorKey.currentContext!,
//               MaterialPageRoute(builder: (_) => const Search()),
//             ),
//       child: AnimatedSize(
//         alignment: Alignment.topCenter,
//         duration: const Duration(milliseconds: 300),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 TextField(
//                   cursorColor: ThemeColors.white,
//                   controller: controller,
//                   maxLength: widget.maxLength,
//                   minLines: widget.minLines,
//                   maxLines: widget.minLines,
//                   enabled: widget.editable,
//                   textCapitalization: TextCapitalization.sentences,
//                   style: widget.style ?? styleBaseBold(fontSize: 14),
//                   autofocus: false,
//                   decoration: InputDecoration(
//                     hintText: widget.hintText,
//                     hintStyle: styleBaseRegular(
//                       fontSize: 14,
//                       color: ThemeColors.greyText,
//                     ),
//                     constraints: widget.openConstraints
//                         ? BoxConstraints(
//                             minHeight: 0,
//                             maxHeight: widget.minLines > 1 ? 150.sp : 50.sp,
//                           )
//                         : null,
//                     contentPadding: widget.contentPadding ??
//                         EdgeInsets.fromLTRB(
//                           10.sp,
//                           10.sp,
//                           12.sp,
//                           10.sp,
//                         ),
//                     filled: true,
//                     fillColor: ThemeColors.primaryLight,
//                     enabledBorder: outlineInputBorder,
//                     border: outlineInputBorder,
//                     focusedBorder: outlineInputBorder,
//                     counterText: '',
//                     suffixIcon: Visibility(
//                       visible: !widget.searching,
//                       child: GestureDetector(
//                         onTap: () {
//                           widget.onSubmitted(controller.text);
//                           controller.text = "";
//                           setState(() {});
//                         },
//                         child: Icon(
//                           Icons.search,
//                           size: isPhone ? 22 : 16,
//                           color: ThemeColors.accent,
//                         ),
//                       ),
//                     ),
//                   ),
//                   onChanged: (value) {
//                     // if (_timer != null) {
//                     //   _timer!.cancel();
//                     // }
//                     // _timer = Timer(
//                     //   const Duration(milliseconds: 1000),
//                     //   () {
//                     //     _searchApiCall(value);
//                     //     // widget.onChanged(value);
//                     //   },
//                     // );
//                   },
//                   onSubmitted: (text) {
//                     widget.onSubmitted(text);
//                     controller.text = "";
//                     setState(() {});
//                   },
//                 ),
//                 Positioned(
//                   right: 10.sp,
//                   top: 10.sp,
//                   child: Visibility(
//                     visible: widget.searching,
//                     child: SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 3.sp,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Visibility(
//               visible: provider.data != null,
//               child: Container(
//                 padding: EdgeInsets.all(Dimen.padding.sp),
//                 margin: EdgeInsets.only(top: 5.sp),
//                 decoration: BoxDecoration(
//                   color: ThemeColors.primaryLight,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(Dimen.radius.r),
//                     bottomRight: Radius.circular(Dimen.radius.r),
//                   ),
//                 ),
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (BuildContext context, int index) {
//                     SearchRes? data = provider.data?[index];
//                     return InkWell(
//                       onTap: () {
//                         closeKeyboard();
//                         provider.clearSearch();

//                         Navigator.push(
//                           navigatorKey.currentContext!,
//                           MaterialPageRoute(
//                             builder: (_) => StockDetail(symbol: data!.symbol),
//                           ),
//                         );
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 6.sp),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               data?.symbol ?? '',
//                               style: styleBaseRegular(fontSize: 14),
//                             ),
//                             Text(
//                               data?.name ?? '',
//                               style: styleBaseRegular(
//                                   fontSize: 12, color: ThemeColors.greyText),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   separatorBuilder: (BuildContext context, int index) {
//                     return const Divider(color: ThemeColors.dividerDark);
//                   },
//                   itemCount: provider.data?.length ?? 0,
//                 ),
//               ),
//             ),
//             Visibility(
//               visible:
//                   provider.data == null && provider.status == Status.loaded,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 6.sp),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       Const.errNoRecord,
//                       style: styleBaseRegular(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
