import 'package:flutter/material.dart';

import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

//
class ErrorDisplayNewWidget extends StatelessWidget {
  const ErrorDisplayNewWidget({
    this.error,
    this.onRefresh,
    super.key,
  });
  final String? error;
  final Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpacerVerticel(),
          Text(
            error ?? Const.errSomethingWrong,
            style: stylePTSansBold(),
          ),
          const SpacerVerticel(),
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
          const SpacerVerticel(),
        ],
      ),
    );
  }
}
