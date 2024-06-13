import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class CustomReadMoreText extends StatelessWidget {
  final String? text;

  const CustomReadMoreText({
    super.key,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            text ?? "",
            style: stylePTSansRegular(
              height: 1.3,
              fontSize: 13,
              color: ThemeColors.greyText,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () => _showFullTextDialog(context),
          child: Text(
            'Read more',
            style: stylePTSansRegular(
              color: ThemeColors.accent,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  void _showFullTextDialog(BuildContext context) {
    popUpAlert(message: text ?? "", title: '');
  }
}
