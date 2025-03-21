import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
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
          HtmlWidget(
           // textAlign: TextAlign.center,
            error ?? Const.errSomethingWrong,
            // style: styleBaseBold(color: ThemeColors.black),
            textStyle: Theme.of(context).textTheme.displayLarge,
          ),
          const SpacerVertical(),
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
