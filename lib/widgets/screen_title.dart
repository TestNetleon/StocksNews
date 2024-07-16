import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/validations.dart';
import 'package:stocks_news_new/widgets/custom_readmore_text.dart';
import 'package:stocks_news_new/widgets/optiona_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class ScreenTitle extends StatelessWidget {
  final String? title;
  final TextStyle? style;
  final String? optionalText;
  final Widget? optionalWidget;
  final bool canPopBack;
  final String? subTitle;
  final bool divider;
  final bool htmlTitle;
  final EdgeInsets? dividerPadding;
  final bool subTitleHtml;
  final CrossAxisAlignment crossAxisAlignment;

  const ScreenTitle(
      {this.title,
      this.style,
      super.key,
      this.dividerPadding,
      this.optionalText,
      this.subTitle,
      this.canPopBack = false,
      this.divider = true,
      this.subTitleHtml = false,
      this.optionalWidget,
      this.htmlTitle = false,
      this.crossAxisAlignment = CrossAxisAlignment.end});
//
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          OptionalParent(
            addParent: optionalText != null || optionalWidget != null,
            parentBuilder: (child) {
              return Row(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  Expanded(
                    child: htmlTitle
                        ? HtmlWidget(
                            title ?? "",
                            textStyle: style ?? styleGeorgiaBold(fontSize: 25),
                          )
                        : Text(
                            title ?? "",
                            style: style ?? styleGeorgiaBold(fontSize: 25),
                          ),
                  ),
                  Visibility(
                    visible: optionalText != null,
                    child: Text(
                      optionalText ?? "",
                      style: style ?? stylePTSansRegular(fontSize: 12),
                    ),
                  ),
                  Visibility(
                    visible: optionalWidget != null,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.sp),
                      child: optionalWidget ?? const SizedBox(),
                    ),
                  ),
                ],
              );
            },
            child: OptionalParent(
              addParent: canPopBack,
              parentBuilder: (child) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title ?? "",
                        style: style ?? styleGeorgiaBold(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SpacerHorizontal(width: 20),
                  ],
                );
              },
              child: htmlTitle
                  ? HtmlWidget(
                      title ?? "",
                      textStyle: style ?? styleGeorgiaBold(fontSize: 25),
                    )
                  : Text(
                      title ?? "",
                      style: style ?? styleGeorgiaBold(fontSize: 25),
                    ),
            ),
          ),
        if (!isEmpty(subTitle))
          subTitleHtml
              ? HtmlWidget(
                  subTitle ?? "",
                  textStyle: stylePTSansRegular(
                      fontSize: 14, color: ThemeColors.greyText),
                  customWidgetBuilder: (element) {
                    return CustomReadMoreText(
                      text: element.text,
                    );
                  },
                )
              : Visibility(
                  visible: subTitle != null,
                  child: Container(
                    margin: EdgeInsets.only(top: 3.sp),
                    child: AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: CustomReadMoreText(
                          text: subTitle ?? "",
                        )
                        //  ReadMoreText(
                        //   textAlign: TextAlign.start,
                        //   subTitle ?? "",
                        //   trimLines: 2,
                        //   colorClickableText: ThemeColors.accent,
                        //   trimMode: TrimMode.Line,
                        //   trimCollapsedText: ' Read more',
                        //   trimExpandedText: ' Read less',
                        //   moreStyle: stylePTSansRegular(
                        //     color: ThemeColors.accent,
                        //     fontSize: 12,
                        //     height: 1.3,
                        //   ),
                        //   style: stylePTSansRegular(
                        //     height: 1.3,
                        //     fontSize: 13,
                        //     color: ThemeColors.greyText,
                        //   ),
                        // ),
                        ),
                    // Text(
                    //   subTitle ?? "",
                    //   style: stylePTSansRegular(
                    //       fontSize: 14, color: ThemeColors.greyText),
                    // ),
                  ),
                ),
        Padding(
          padding: dividerPadding ??
              const EdgeInsets.symmetric(vertical: Dimen.itemSpacing),
          child: const SizedBox(),
        )
        // Visibility(  //   dividerVisible
        //   visible: divider,
        //   child: Padding(
        //     padding: dividerPadding ??
        //         const EdgeInsets.symmetric(vertical: Dimen.itemSpacing),
        //     child: const Divider(
        //       color: ThemeColors.accent,
        //       height: 2,
        //       thickness: 2,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/validations.dart';
// import 'package:stocks_news_new/widgets/custom_readmore_text.dart';
// import 'package:stocks_news_new/widgets/optiona_parent.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class ScreenTitle extends StatefulWidget {
//   final String? title;
//   final TextStyle? style;
//   final String? optionalText;
//   final Widget? optionalWidget;
//   final bool canPopBack;
//   final String? subTitle;
//   final bool divider;
//   final bool htmlTitle;
//   final EdgeInsets? dividerPadding;
//   final bool subTitleHtml;

//   const ScreenTitle({
//     this.title,
//     this.style,
//     super.key,
//     this.dividerPadding,
//     this.optionalText,
//     this.subTitle,
//     this.canPopBack = false,
//     this.divider = true,
//     this.subTitleHtml = false,
//     this.optionalWidget,
//     this.htmlTitle = false,
//   });

//   @override
//   State<ScreenTitle> createState() => _ScreenTitleState();
// }

// class _ScreenTitleState extends State<ScreenTitle> {
//   bool show = false;

//   @override
//   void initState() {
//     super.initState();
//     show = false;
//   }

//   _change(value) {
//     show = !value;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.transparent,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           if (widget.title != null)
//             OptionalParent(
//               addParent:
//                   widget.optionalText != null || widget.optionalWidget != null,
//               parentBuilder: (child) {
//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Expanded(
//                       child: widget.htmlTitle
//                           ? HtmlWidget(
//                               widget.title ?? "",
//                               textStyle: widget.style ??
//                                   styleGeorgiaBold(fontSize: 30),
//                             )
//                           : Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   widget.title ?? "",
//                                   style: widget.style ??
//                                       styleGeorgiaBold(fontSize: 25),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(top: 6, left: 5),
//                                   child: Icon(
//                                     Icons.info_outline,
//                                     size: 20,
//                                     color: ThemeColors.white.withOpacity(0.5),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                     Visibility(
//                       visible: widget.optionalText != null,
//                       child: Text(
//                         widget.optionalText ?? "",
//                         style: widget.style ?? stylePTSansRegular(fontSize: 12),
//                       ),
//                     ),
//                     Visibility(
//                       visible: widget.optionalWidget != null,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 10.sp),
//                         child: widget.optionalWidget ?? const SizedBox(),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//               child: OptionalParent(
//                 addParent: widget.canPopBack,
//                 parentBuilder: (child) {
//                   return Row(
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(
//                             Icons.arrow_back_ios,
//                             size: 20,
//                           )),
//                       Expanded(
//                         child: Text(
//                           widget.title ?? "",
//                           style: widget.style ?? styleGeorgiaBold(fontSize: 17),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       const SpacerHorizontal(width: 20),
//                     ],
//                   );
//                 },
//                 child: widget.htmlTitle
//                     ? HtmlWidget(
//                         widget.title ?? "",
//                         textStyle:
//                             widget.style ?? styleGeorgiaBold(fontSize: 17),
//                       )
//                     : Text(
//                         widget.title ?? "",
//                         style: widget.style ?? styleGeorgiaBold(fontSize: 17),
//                       ),
//               ),
//             ),
//           // if (!isEmpty(subTitle))
//           //   subTitleHtml
//           //       ? HtmlWidget(
//           //           subTitle ?? "",
//           //           textStyle: stylePTSansRegular(
//           //               fontSize: 14, color: ThemeColors.greyText),
//           //           customWidgetBuilder: (element) {
//           //             return CustomReadMoreText(
//           //               text: element.text,
//           //             );
//           //           },
//           //         )
//           //       : Visibility(
//           //           visible: subTitle != null,
//           //           child: Container(
//           //             margin: EdgeInsets.only(top: 3.sp),
//           //             child: AnimatedSize(
//           //                 duration: const Duration(milliseconds: 300),
//           //                 curve: Curves.easeInOut,
//           //                 child: CustomReadMoreText(
//           //                   text: subTitle ?? "",
//           //                 )),
//           //           ),
//           //         ),
//           Visibility(
//             // visible: widget.divider,
//             visible: false,
//             child: Padding(
//               padding: widget.dividerPadding ??
//                   const EdgeInsets.symmetric(vertical: Dimen.itemSpacing),
//               child: const Divider(
//                 color: ThemeColors.accent,
//                 height: 2,
//                 thickness: 2,
//               ),
//             ),
//           ),

//           SpacerVertical(
//             height: Dimen.itemSpacing,
//           )
//         ],
//       ),
//     );
//   }
// }
//       //  ReadMoreText(
//                           //   textAlign: TextAlign.start,
//                           //   subTitle ?? "",
//                           //   trimLines: 2,
//                           //   colorClickableText: ThemeColors.accent,
//                           //   trimMode: TrimMode.Line,
//                           //   trimCollapsedText: ' Read more',
//                           //   trimExpandedText: ' Read less',
//                           //   moreStyle: stylePTSansRegular(
//                           //     color: ThemeColors.accent,
//                           //     fontSize: 12,
//                           //     height: 1.3,
//                           //   ),
//                           //   style: stylePTSansRegular(
//                           //     height: 1.3,
//                           //     fontSize: 13,
//                           //     color: ThemeColors.greyText,
//                           //   ),
//                           // ),
