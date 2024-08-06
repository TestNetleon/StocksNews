import 'package:flutter/material.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../stockDetail/stockDetailTabs/overview/top_widget.dart';

class SdPortfolioHeading extends StatelessWidget {
  const SdPortfolioHeading({this.showRating = false, super.key});
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SdTopWidgetDetail(),
          SpacerVertical(height: 4),
        ],
      ),
    );
  }
}
