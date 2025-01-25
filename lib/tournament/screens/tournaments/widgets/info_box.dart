import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../utils/theme.dart';

class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  const InfoBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Text(
          label,
          style: styleGeorgiaRegular(fontSize: 13),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SpacerVertical(height: 10),
        Text(
          value,
          style: styleGeorgiaBold(fontSize: 18),
        ),
      ],
    ));
  }
}
