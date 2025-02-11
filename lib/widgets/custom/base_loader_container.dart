import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/update_error.dart';
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:stocks_news_new/widgets/loading.dart';

class BaseLoaderContainer extends StatelessWidget {
  const BaseLoaderContainer({
    required this.child,
    required this.hasData,
    this.error,
    required this.isLoading,
    this.showPreparingText = false,
    this.removeErrorWidget = false,
    this.onRefresh,
    this.onNavigate,
    this.navBtnText,
    this.placeholder,
    super.key,
  });
//
  final Widget child;
  final bool hasData;
  final String? error;
  final bool removeErrorWidget;
  final bool isLoading;
  final bool showPreparingText;
  final String? navBtnText;
  final Widget? placeholder;
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
              ? child
              : error?.contains('Please update your application') == true
                  ? UpdateError(error: error)
                  : removeErrorWidget
                      ? Container(height: 50)
                      : ErrorDisplayNewWidget(
                          error: error ?? Const.errNoRecord,
                          onRefresh: onRefresh,
                          onNavigate: onNavigate,
                          navBtnText: navBtnText,
                        ),
    );
  }
}
