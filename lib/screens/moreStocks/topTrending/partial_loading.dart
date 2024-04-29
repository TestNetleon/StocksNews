import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class TopTrendingPartialLoading extends StatelessWidget {
  const TopTrendingPartialLoading({
    required this.child,
    this.error,
    this.loading = false,
    this.marginTop = true,
    this.onRefresh,
    super.key,
  });
//
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
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: ThemeColors.accent,
                ),
                const SpacerHorizontal(width: 5),
                Flexible(
                  child: Text(
                    "Preparing your data.. Please wait.",
                    style: stylePTSansRegular(),
                  ),
                ),
              ],
            ),
          ),
        if (error != null)
          ErrorDisplayWidget(
            showHeight: false,
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
