// import 'dart:async';

// import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/search_new.dart';
// import 'package:stocks_news_new/modals/search_res.dart';
// import 'package:stocks_news_new/providers/search_provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/search/search.dart';
// import 'package:stocks_news_new/screens/tabs/news/newsDetail/new_detail.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/cache_network_image.dart';
// import '../routes/my_app.dart';
// import '../screens/stockDetail/index.dart';
// import 'spacer_horizontal.dart';

// //
// class TextInputFieldSearchCommon extends StatefulWidget {
//   const TextInputFieldSearchCommon({
//     // required this.controller,
//     required this.onChanged,
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
//     this.searchFocusNode,
//     this.searchForNews = false,
//   });

//   // final TextEditingController controller;
//   final int maxLength;
//   final int minLines;
//   final bool editable;
//   final bool shadow;
//   final TextStyle? style;
//   final Color? borderColor;
//   final String? hintText;
//   final Function(String) onChanged;
//   final bool searching;
//   final double? radius;
//   final EdgeInsets? contentPadding;
//   final bool openConstraints;
//   final FocusNode? searchFocusNode;
//   final bool searchForNews;

//   @override
//   State<TextInputFieldSearchCommon> createState() =>
//       _TextInputFieldSearchCommonState();
// }

// class _TextInputFieldSearchCommonState
//     extends State<TextInputFieldSearchCommon> {
//   final TextEditingController controller = TextEditingController();
//   Timer? _timer;
//   bool firstTime = true;
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _searchApiCall(String text) {
//     firstTime = false;
//     setState(() {});
//     Utils().showLog("---calling search api call");
//     if (text.isEmpty) {
//       context.read<SearchProvider>().clearSearch();
//     } else {
//       Map request = {
//         "term": text,
//         "token": context.read<UserProvider>().user?.token ?? ""
//       };
//       // context.read<SearchProvider>().searchSymbols(request);
//       context.read<SearchProvider>().searchSymbolsAndNews(request);
//     }
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
//                   // focusNode: widget.searchFocusNode,
//                   autocorrect: false,
//                   controller: controller,
//                   maxLength: widget.maxLength,
//                   minLines: widget.minLines,
//                   maxLines: widget.minLines,
//                   enabled: widget.editable,
//                   textCapitalization: TextCapitalization.sentences,
//                   style: widget.style ??
//                       styleBaseBold(fontSize: isPhone ? 14 : 7),
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
//                     prefixIcon: Icon(
//                       Icons.search,
//                       size: isPhone ? 22 : 16.sp,
//                       color: ThemeColors.greyText,
//                     ),
//                   ),
//                   onChanged: (value) {
//                     if (_timer != null) {
//                       _timer!.cancel();
//                     }
//                     _timer = Timer(
//                       const Duration(milliseconds: 1000),
//                       () {
//                         _searchApiCall(value);
//                         // widget.onChanged(value);
//                       },
//                     );
//                   },
//                 ),
//                 Positioned(
//                   right: 10.sp,
//                   top: 10.sp,
//                   child: Visibility(
//                     visible: !firstTime && provider.isLoadingS,
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
//               visible: provider.dataNew != null,
//               child: Container(
//                 padding: EdgeInsets.all(Dimen.padding),
//                 margin: EdgeInsets.only(top: 5),
//                 decoration: BoxDecoration(
//                   color: ThemeColors.primaryLight,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(Dimen.radius.r),
//                     bottomRight: Radius.circular(Dimen.radius.r),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Visibility(
//                       visible: provider.dataNew?.symbols?.isNotEmpty == true,
//                       child: Padding(
//                         padding: EdgeInsets.only(bottom: 10),
//                         child: Text(
//                           "Symbols",
//                           style: styleBaseBold(color: ThemeColors.accent),
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: provider.dataNew?.symbols?.isNotEmpty == true,
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemBuilder: (BuildContext context, int index) {
//                           SearchRes? data = provider.dataNew?.symbols?[index];
//                           return InkWell(
//                             onTap: () {
//                               closeKeyboard();
//                               provider.clearSearch();
//                               // AmplitudeService.logUserInteractionEvent(
//                               //   type: 'Stock Search',
//                               //   selfText: "Searched for ${data?.symbol ?? ''}",
//                               // );
//                               Navigator.push(
//                                 navigatorKey.currentContext!,
//                                 MaterialPageRoute(
//                                     builder: (_) =>
//                                         StockDetail(symbol: data!.symbol)),
//                               );
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(vertical: 6),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                       width: 43,
//                                       height: 43,
//                                       padding: EdgeInsets.all(5),
//                                       child: CachedNetworkImagesWidget(
//                                           data?.image)),
//                                   const SpacerHorizontal(width: 6),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           data?.symbol ?? '',
//                                           style:
//                                               styleBaseRegular(fontSize: 14),
//                                         ),
//                                         Text(
//                                           data?.name ?? '',
//                                           style: styleBaseRegular(
//                                               fontSize: 12,
//                                               color: ThemeColors.greyText),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                         separatorBuilder: (BuildContext context, int index) {
//                           return const Divider(color: ThemeColors.dividerDark);
//                         },
//                         itemCount: provider.dataNew?.symbols?.length ?? 0,
//                       ),
//                     ),
//                     Visibility(
//                       visible: provider.dataNew?.news?.isNotEmpty == true,
//                       child: Padding(
//                         padding: EdgeInsets.only(bottom: 10, top: 10),
//                         child: Text(
//                           "News",
//                           style: styleBaseBold(color: ThemeColors.accent),
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: provider.dataNew?.news?.isNotEmpty == true,
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemBuilder: (BuildContext context, int index) {
//                           SearchNewsRes? data = provider.dataNew?.news?[index];
//                           return InkWell(
//                             onTap: () {
//                               closeKeyboard();
//                               provider.clearSearch();
//                               // AmplitudeService.logUserInteractionEvent(
//                               //   type: 'News Search',
//                               //   selfText: "Searched for ${data?.title ?? ''}",
//                               // );
//                               Navigator.push(
//                                 navigatorKey.currentContext!,
//                                 MaterialPageRoute(
//                                   builder: (_) => NewsDetails(slug: data!.slug),
//                                 ),
//                               );
//                             },
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(vertical: 6),
//                               child: Text(
//                                 data?.title ?? '',
//                                 style: styleBaseRegular(fontSize: 14),
//                               ),
//                             ),
//                           );
//                         },
//                         separatorBuilder: (BuildContext context, int index) {
//                           return const Divider(color: ThemeColors.dividerDark);
//                         },
//                         itemCount: provider.dataNew?.news?.length ?? 0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Visibility(
//               visible:
//                   provider.dataNew == null && provider.statusS == Status.loaded,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 6),
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
