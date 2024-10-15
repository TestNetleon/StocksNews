import 'package:flutter/material.dart';

import '../../../../../../utils/theme.dart';

class MsPerformanceTitleSubtitle extends StatelessWidget {
  final String leading;
  final String trailing;
  final Color? color;
  final bool bold;
  const MsPerformanceTitleSubtitle({
    super.key,
    required this.leading,
    required this.trailing,
    this.color = Colors.grey,
    this.bold = false,
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
            style: bold
                ? styleGeorgiaBold(
                    fontSize: 16.0,
                    color: color,
                  )
                : stylePTSansRegular(
                    fontSize: 16.0,
                    color: color,
                  ),
          ),
          Text(
            trailing,
            style: bold
                ? styleGeorgiaBold(
                    fontSize: 16.0,
                    color: color,
                  )
                : stylePTSansRegular(
                    fontSize: 16.0,
                    color: color,
                  ),
          ),
        ],
      ),
    );
  }
}
