import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/update_error.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/optiona_parent.dart';

class BaseUiContainer extends StatelessWidget {
  const BaseUiContainer({
    required this.child,
    required this.hasData,
    this.isFull = false,
    this.error,
    required this.isLoading,
    this.errorDispCommon = false,
    this.showPreparingText = false,
    this.onRefresh,
    this.onNavigate,
    this.navBtnText,
    this.placeholder,
    this.isOldApp,
    super.key,
  });
//
  final Widget child;
  final bool hasData;
  final bool isFull;
  final String? error;
  final bool isLoading;
  final bool showPreparingText;
  final bool errorDispCommon;
  final String? navBtnText;
  final Widget? placeholder;
  final bool? isOldApp;
  final dynamic Function()? onRefresh;
  final dynamic Function()? onNavigate;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: isLoading
          ? showPreparingText
              ? placeholder ?? const Loading()
              : const SizedBox()
          // const Loading()
          : hasData
              ? isFull
                  ? Column(children: [Expanded(child: child)])
                  : child
              : OptionalParent(
                  addParent: errorDispCommon,
                  parentBuilder: (child) {
                    if (isOldApp == true) {
                      return UpdateError(error: error);
                    }
                    return ErrorDisplayWidget(
                      error: error ?? Const.errNoRecord,
                      onRefresh: onRefresh,
                      onNavigate: onNavigate,
                      navBtnText: navBtnText,
                    );
                  },
                  child:
                      error?.contains('Please update your application') == true
                          ? UpdateError(error: error)
                          : ErrorDisplayNewWidget(
                              error: error ?? Const.errNoRecord,
                              onRefresh: onRefresh,
                              onNavigate: onNavigate,
                              navBtnText: navBtnText,
                            ),
                ),
    );
  }
}
