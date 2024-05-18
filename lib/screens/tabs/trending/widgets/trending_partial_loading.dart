import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';

//
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
    if (loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Images.progressGIF,
              width: 100,
              height: 100,
            ),
            Text(
              "We are preparing, Please wait...",
              style: styleGeorgiaRegular(
                color: ThemeColors.accent,
              ),
            ),
          ],
        ),
      );
    }
    if (error != null) {
      return ErrorDisplayWidget(
        smallHeight: true,
        error: error,
        onRefresh: onRefresh,
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // if (loading)
          //   Center(
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Image.asset(
          //           Images.progressGIF,
          //           width: 100,
          //           height: 100,
          //         ),
          //         Text(
          //           "We are preparing …",
          //           style: styleGeorgiaRegular(
          //             color: ThemeColors.accent,
          //           ),
          //         ),
          //         // const CircularProgressIndicator(
          //         //   color: ThemeColors.accent,
          //         // ),
          //       ],
          //     ),
          //   ),
          // if (error != null)
          //   ErrorDisplayWidget(
          //     smallHeight: true,
          //     error: error,
          //     onRefresh: onRefresh,
          //   ),

          if (!loading && error == null)
            Container(
              margin: EdgeInsets.only(top: 20.sp),
              child: child,
            )
        ],
      ),
    );
  }
}
