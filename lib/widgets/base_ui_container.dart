import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/error_display_widget.dart';
import 'package:stocks_news_new/widgets/optiona_parent.dart';

class BaseUiContainer extends StatelessWidget {
  const BaseUiContainer({
    required this.child,
    required this.hasData,
    required this.error,
    required this.isLoading,
    this.errorDispCommon = false,
    this.showPreparingText = false,
    this.onRefresh,
    super.key,
  });
//
  final Widget child;
  final bool hasData;
  final String? error;
  final bool isLoading;
  final bool showPreparingText;
  final bool errorDispCommon;
  final dynamic Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? showPreparingText
            ? Center(
                child: Text(
                  "We are preparing …",
                  style: styleGeorgiaRegular(
                    color: Colors.white,
                  ),
                ),
              )
            : const SizedBox()
        : hasData
            ? child
            : OptionalParent(
                addParent: errorDispCommon,
                parentBuilder: (child) {
                  return ErrorDisplayWidget(
                    error: error ?? Const.errNoRecord,
                    onRefresh: onRefresh,
                  );
                },
                child: ErrorDisplayNewWidget(
                  error: error ?? Const.errNoRecord,
                  onRefresh: onRefresh,
                ),
              );
  }
}
