import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';

class TrendingPartialLoading extends StatelessWidget {
  const TrendingPartialLoading({
    required this.child,
    this.error,
    this.loading = false,
    this.marginTop = true,
    this.onRefresh,
    super.key,
  });

  final Widget child;
  final bool loading;
  final bool marginTop;
  final String? error;
  final Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (loading)
          Container(
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
          Container(
            margin: EdgeInsets.only(top: 20.sp),
            child: child,
          )
      ],
    );
  }
}
