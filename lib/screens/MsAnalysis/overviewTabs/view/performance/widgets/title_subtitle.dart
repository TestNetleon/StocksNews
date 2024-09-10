import 'package:flutter/material.dart';

import '../../../../../../utils/theme.dart';

class MsPerformanceTitleSubtitle extends StatelessWidget {
  final String leading;
  final String trailing;
  final Color? color;
  const MsPerformanceTitleSubtitle({
    super.key,
    required this.leading,
    required this.trailing,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leading,
            style: stylePTSansRegular(
              fontSize: 16.0,
              color: color,
            ),
          ),
          Text(
            trailing,
            style: stylePTSansRegular(
              fontSize: 16.0,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
