import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

//
class CommonEmptyError extends StatelessWidget {
  const CommonEmptyError({
    required this.child,
    required this.hasData,
    required this.isLoading,
    this.error,
    this.onRefresh,
    this.postJobButton,
    this.smallHeight = false,
    super.key,
    required this.onClick,
    this.title,
    this.subTitle,
    this.showRefresh = true,
    this.buttonText,
  });
  final Widget child;
  final bool hasData;
  final bool isLoading;
  final Function() onClick;
  final String? error;
  final Function()? onRefresh;
  final bool? postJobButton;
  final bool smallHeight;
  final String? title;
  final String? subTitle;
  final String? buttonText;
  final bool showRefresh;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: smallHeight
          ? ScreenUtil().screenHeight * .4
          : ScreenUtil().screenHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: isLoading
              ? const Loading()
              : hasData
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          // visible: title != null && title != '',
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              title ?? "",
                              style: styleBaseBold(fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Visibility(
                          // visible: title != null && title != '',
                          child: Text(
                            subTitle ?? "",
                            style: styleBaseRegular(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SpacerVertical(height: 10),
                        Visibility(
                          visible: showRefresh,
                          child: ThemeButtonSmall(
                            showArrow: false,
                            onPressed: onClick,
                            text: buttonText ?? "Refresh",
                            iconFront: true,
                            radius: 30,
                            mainAxisSize: MainAxisSize.max,
                            textSize: 15,
                            fontBold: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 11),
                          ),
                        ),
                      ],
                    )
                  : child,
        ),
      ),
    );
  }
}
