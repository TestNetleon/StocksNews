import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/filters_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/marketData/widget/filter_multi_select_list.dart';
import 'package:stocks_news_new/screens/marketData/widget/marketDataBottomSheet/filter_single_select_list.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../widgets/bottom_sheet_tick.dart';

class BaseBottomSheets {
  gradientBottomSheet({
    required Widget child,
    String? title,
    String? subTitle,
    EdgeInsets? padding,
    Function()? onResetClick,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      enableDrag: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return Container(
          padding: padding ?? const EdgeInsets.fromLTRB(15, 0, 15, 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            border: Border(
              top: BorderSide(color: ThemeColors.greyBorder.withOpacity(0.4)),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ThemeColors.bottomsheetGradient, Colors.black],
            ),
            // gradient: const LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Color.fromARGB(255, 23, 23, 23),
            //     Color.fromARGB(255, 48, 48, 48),
            //   ],
            // ),
          ),
          constraints: BoxConstraints(
            maxHeight: ScreenUtil().screenHeight * .9,
          ),
          // height: 100,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: BottomSheetTick(),
                    ),
                  ),
                  Visibility(
                    visible: title != null && title != '',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ScreenTitle(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        title: title,
                        subTitle: subTitle,
                        optionalWidget: onResetClick != null
                            ? InkWell(
                                onTap: onResetClick,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    // vertical: 3,
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.refresh,
                                        size: 18,
                                        color: ThemeColors.accent,
                                      ),
                                      const SpacerHorizontal(width: 5),
                                      Text(
                                        "Reset Sorting",
                                        style: stylePTSansRegular(
                                          color: ThemeColors.accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // child: Container(
                                //   decoration: BoxDecoration(
                                //     color: ThemeColors.accent,
                                //     borderRadius: BorderRadius.circular(4),
                                //   ),
                                //   padding: const EdgeInsets.symmetric(
                                //     vertical: 3,
                                //     horizontal: 8,
                                //   ),
                                //   child:
                                //       Text("Reset", style: stylePTSansBold()),
                                // ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  gradientBottomSheetDraggable({
    // required Widget child,
    required Function(List<FiltersDataItem> selected) onSelected,
    String? title,
    String? subTitle,
    EdgeInsets? padding,
    // required Widget Function(ScrollController scrollController) widgetBuilder,
    List<FiltersDataItem>? items,
    List<String>? selected,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      // enableDrag: true,
      context: navigatorKey.currentContext!,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        shouldCloseOnMinExtent: true,
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: Border(
                top: BorderSide(color: ThemeColors.greyBorder.withOpacity(0.4)),
              ),
              // gradient: const LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Color.fromARGB(255, 23, 23, 23),
              //     Color.fromARGB(255, 48, 48, 48),
              //   ],
              // ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ThemeColors.bottomsheetGradient, Colors.black],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: BottomSheetTick(),
                  ),
                ),
                Visibility(
                  visible: title != null && title != '',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ScreenTitle(title: title, subTitle: subTitle),
                  ),
                ),
                Expanded(
                  child: FilterMultiSelectListing(
                    scrollController: scrollController,
                    items: items!,
                    selectedData: selected,
                    onSelected: onSelected,
                  ),
                ),
                // Footer(),
              ],
            ),
          );
        },
      ),
    );

    // showModalBottomSheet(
    //   isScrollControlled: true,
    //   useSafeArea: true,
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(10),
    //       topRight: Radius.circular(10),
    //     ),
    //   ),
    //   // enableDrag: true,
    //   context: navigatorKey.currentContext!,
    //   builder: (context) {
    //     return DraggableScrollableSheet(
    //         expand: false,
    //         shouldCloseOnMinExtent: false,
    //         initialChildSize: 0.5,
    //         minChildSize: 0.3,
    //         maxChildSize: 0.9,
    //         builder: (context, scrollController) {
    //           return Container(
    //             padding: padding ??
    //                 EdgeInsets.fromLTRB(
    //                   15,
    //                   0,
    //                   15,
    //                   ScreenUtil().bottomBarHeight + 15,
    //                 ),
    //             decoration: BoxDecoration(
    //               borderRadius: const BorderRadius.only(
    //                   topLeft: Radius.circular(10),
    //                   topRight: Radius.circular(10)),
    //               border: Border(
    //                 top: BorderSide(
    //                     color: ThemeColors.greyBorder.withOpacity(0.4)),
    //               ),
    //               gradient: const LinearGradient(
    //                 begin: Alignment.topCenter,
    //                 end: Alignment.bottomCenter,
    //                 colors: [
    //                   Color.fromARGB(255, 23, 23, 23),
    //                   Color.fromARGB(255, 48, 48, 48),
    //                 ],
    //               ),
    //             ),
    //             // height: 100,
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 const Align(
    //                   alignment: Alignment.center,
    //                   child: Padding(
    //                     padding: EdgeInsets.only(top: 6),
    //                     child: BottomSheetTick(),
    //                   ),
    //                 ),
    //                 Visibility(
    //                   visible: title != null && title != '',
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(top: 20),
    //                     child: ScreenTitle(title: title, subTitle: subTitle),
    //                   ),
    //                 ),
    //                 // Expanded(child: child),
    //                 // Expanded(child: widgetBuilder(scrollController)),
    //                 Expanded(
    //                   child: FilterMultiSelectListing(
    //                     label: "Select Industry",
    //                     items: items!,
    //                     selectedData: selected,
    //                     onSelected: onSelected,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           );
    //         });
    //   },
    // );
  }

  gradientBottomSheetDraggableSingleSelected({
    // required Widget child,
    required final Function(FiltersDataItem?) onSelected,
    String? title,
    String? subTitle,
    EdgeInsets? padding,
    // required Widget Function(ScrollController scrollController) widgetBuilder,
    List<FiltersDataItem>? items,
    String? selected,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      // enableDrag: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return DraggableScrollableSheet(
            expand: false,
            shouldCloseOnMinExtent: true,
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: padding ??
                    EdgeInsets.fromLTRB(
                      15,
                      0,
                      15,
                      ScreenUtil().bottomBarHeight + 15,
                    ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  border: Border(
                    top: BorderSide(
                        color: ThemeColors.greyBorder.withOpacity(0.4)),
                  ),
                  // gradient: const LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [
                  //     Color.fromARGB(255, 23, 23, 23),
                  //     Color.fromARGB(255, 48, 48, 48),
                  //   ],
                  // ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [ThemeColors.bottomsheetGradient, Colors.black],
                  ),
                ),
                // height: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: BottomSheetTick(),
                      ),
                    ),
                    Visibility(
                      visible: title != null && title != '',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ScreenTitle(title: title, subTitle: subTitle),
                      ),
                    ),

                    Expanded(
                      child: FilterSingleSelectListing(
                        label: "Select Industry",
                        onSelected: onSelected,
                        items: items ?? [],
                        // items: items,
                        // selectedData: selected,
                        // onSelected: onSelected,
                      ),
                    )
                    // Expanded(
                    //   child: FilterSingleSelectListing(
                    //     label: "Select Industry",
                    //     items: items!,
                    //     selectedData: selected,
                    //     onSelected: onSelected,
                    //   ),
                    // ),
                  ],
                ),
              );
            });
      },
    );
  }
}
