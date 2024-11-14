import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../provider/arena.dart';

class TournamentHeader extends StatelessWidget {
  const TournamentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ArenaProvider provider = context.watch<ArenaProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(0.9),
          colors: [
            ThemeColors.bottomsheetGradient,
            ThemeColors.accent,
          ],
        ),
      ),
      child: Row(
        children: List.generate(
          provider.tournamentHeader.length,
          (index) {
            return Expanded(
              child: Column(
                children: [
                  Text(
                    provider.tournamentHeader[index].label ?? '',
                    style: styleGeorgiaRegular(fontSize: 12),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    provider.tournamentHeader[index].value ?? '',
                    style: styleGeorgiaBold(fontSize: 16),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
