import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class CustomReadMoreText extends StatefulWidget {
  final String? text;
  final Color textColor;

  const CustomReadMoreText({
    super.key,
    required this.text,
    this.textColor = ThemeColors.white,
  });

  @override
  State<CustomReadMoreText> createState() => _CustomReadMoreTextState();
}

class _CustomReadMoreTextState extends State<CustomReadMoreText> {
  bool _isOverflowing = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: stylePTSansRegular(
          height: 1.3,
          fontSize: 13,
          color: widget.textColor,
        ),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: context.size!.width);

    setState(() {
      _isOverflowing = textPainter.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: RichText(
          text: TextSpan(
            text: widget.text,
            style: stylePTSansRegular(
              height: 1.3,
              fontSize: 13,
              color: widget.textColor,
            ),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )),
        Visibility(
          visible: _isOverflowing,
          child: GestureDetector(
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
        ),
      ],
    );
  }

  void _showFullTextDialog(BuildContext context) {
    popUpAlert(
      message: widget.text ?? "",
      title: '',
      messageTextAlign: TextAlign.left,
    );
  }
}
