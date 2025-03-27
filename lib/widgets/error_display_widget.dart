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

  bool isHtml(String? text) {
    if (text == null) return false;
    // Check for common HTML tags
    final htmlPattern = RegExp(
        r'<(br|p|div|span|a|img|b|i|u|strong|em|h1|h2|h3|h4|h5|h6)[^>]*>',
        caseSensitive: false);
    return htmlPattern.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpacerVertical(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isHtml(error)
                ? HtmlWidget(
                    error ?? Const.errSomethingWrong,
                    textStyle: Theme.of(context).textTheme.displayLarge,
                  )
                : Text(
                    error ?? Const.errSomethingWrong,
                    style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
                  ),
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
