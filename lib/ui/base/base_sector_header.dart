import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/industries_res.dart';
import 'package:stocks_news_new/utils/constants.dart';

class BaseSectorHeader extends StatelessWidget {
  final HeadingLabel? title;

  const BaseSectorHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // bool isOpen = _openIndex == widget.index;
    return Container(
      padding: EdgeInsets.all(Pad.pad16),
      child: LayoutBuilder(builder: (context, constraints) {
        double titleSpace = constraints.maxWidth * .5;
        double type = constraints.maxWidth * .32;
        double value = constraints.maxWidth * .18;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: titleSpace,
              child: Text(
                title?.title ?? "",
                // style: styleBaseBold(fontSize: 12),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            SizedBox(
              width: type,
              child: AutoSizeText(
                title?.sentiment ?? "",
                // style: styleBaseBold(fontSize: 12),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            SizedBox(
              width: value,
              child: AutoSizeText(
                title?.mentions ?? "",
                // style: styleBaseBold(fontSize: 12),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        );
      }),
    );
  }
}
