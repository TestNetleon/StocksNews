import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TournamentThemeCard extends StatelessWidget {
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  final Widget? child;
  const TournamentThemeCard({super.key, this.padding, this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 46, 46, 46),
            ThemeColors.blackShade,
          ],
        ),
      ),
      child: child,
    );
  }
}
