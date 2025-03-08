import 'package:flutter/material.dart';

import '../../../../../../utils/colors.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../base/heading.dart';

class ScannerNoResult extends StatelessWidget {
  const ScannerNoResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: Pad.pad16),
            decoration: BoxDecoration(
              color: ThemeColors.neutral5,
              borderRadius: BorderRadius.circular(Pad.pad16),
            ),
            child: Image.asset(
              Images.search,
              height: 56,
              width: 56,
            ),
          ),
          BaseHeading(
            crossAxisAlignment: CrossAxisAlignment.center,
            title: 'No Results Found',
            subtitle: 'No record found with this filter',
          ),
        ],
      ),
    );
  }
}
