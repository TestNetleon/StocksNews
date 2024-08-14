import 'package:flutter/material.dart';
import '../widget/title_tag.dart';
import 'item.dart';

class MsOurHighlights extends StatelessWidget {
  const MsOurHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MsTitle(title: "Stock Highlights"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              4,
              (index) {
                return MsOurHighlightsItem();
              },
            ),
          ),
        ),
      ],
    );
  }
}
