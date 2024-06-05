import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';

class HomePartialLoading extends StatelessWidget {
  const HomePartialLoading({
    required this.child,
    this.error,
    this.loading = false,
    this.marginTop = true,
    this.onRefresh,
    this.placeHolder,
    this.loadingWidget,
    super.key,
  });

  final Widget child;
  final bool loading;
  final bool marginTop;
  final String? error;
  final Function()? onRefresh;
  final Widget? placeHolder;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const SpacerVertical(),
        if (loading)
          loadingWidget ??
              placeHolder ??
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.all(20.sp),
                child: const CircularProgressIndicator(
                  color: ThemeColors.accent,
                ),
              ),
        if (error != null)
          ErrorDisplayWidget(
            smallHeight: true,
            error: error,
            onRefresh: onRefresh,
          ),
        if (!loading && error == null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(top: isPhone ? 20.sp : 5.sp),
            child: child,
          ),
      ],
    );
  }
}
