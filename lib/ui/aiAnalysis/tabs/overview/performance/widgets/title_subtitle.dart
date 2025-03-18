import 'package:flutter/material.dart';

import '../../../../../../utils/theme.dart';

class AIPerformanceTitleSubtitle extends StatelessWidget {
  final String leading;
  final String trailing;
  final Color? color;
  final bool bold;
  const AIPerformanceTitleSubtitle({
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
                ? styleBaseBold(
                    fontSize: 16.0,
                    color: color,
                  )
                : styleBaseRegular(
                    fontSize: 16.0,
                    color: color,
                  ),
          ),
          Text(
            trailing,
            style: bold
                ? styleBaseBold(
                    fontSize: 16.0,
                    color: color,
                  )
                : styleBaseRegular(
                    fontSize: 16.0,
                    color: color,
                  ),
          ),
        ],
      ),
    );
  }
}
