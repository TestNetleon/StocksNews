import 'package:flutter/material.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

//
class ErrorDisplayNewWidget extends StatelessWidget {
  const ErrorDisplayNewWidget({
    this.error,
    this.onRefresh,
    this.onNavigate,
    this.navBtnText,
    super.key,
  });
  final String? error;
  final String? navBtnText;
  final Function()? onRefresh;
  final Function()? onNavigate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpacerVertical(),
          Text(
            error ?? Const.errSomethingWrong,
            style: stylePTSansBold(),
          ),
          const SpacerVertical(),
          // Visibility(
          //   visible: onRefresh != null,
          //   child: ThemeButton(
          //     onPressed: () {
          //       FocusManager.instance.primaryFocus?.unfocus();
          //       if (onRefresh != null) onRefresh!();
          //     },
          //     padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 5.sp),
          //     text: "Refresh",
          //   ),
          // ),
          Visibility(
            visible: onRefresh != null,
            child: GestureDetector(
              onTap: () {
                if (onRefresh != null) onRefresh!();
              },
              child: const CircleAvatar(
                radius: 25,
                backgroundColor: ThemeColors.primary,
                child: Icon(
                  Icons.replay_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
          Visibility(
            visible: onNavigate != null,
            child: ThemeButtonSmall(
              onPressed: () {
                if (onNavigate != null) onNavigate!();
              },
              text: "$navBtnText",
              showArrow: false,
              // fullWidth: false,
            ),
          ),
          const SpacerVertical(),
        ],
      ),
    );
  }
}
