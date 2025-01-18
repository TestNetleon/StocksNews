import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../provider/tournament.dart';
import '../pointsPaid/index.dart';

class TournamentHeader extends StatelessWidget {
  const TournamentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

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
          provider.data?.tournamentHeader?.length ?? 0,
          (index) {
            return Expanded(
              child: InkWell(
                onTap: () {
                  if (index == 1) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TournamentPointsPaidIndex();
                      },
                    ));
                  }
                },
                child: Column(
                  children: [
                    Text(
                      provider.data?.tournamentHeader?[index].label ?? '',
                      style: styleGeorgiaRegular(fontSize: 14),
                    ),
                    const SpacerVertical(height: 5),
                    Text(
                      provider.data?.tournamentHeader?[index].value ?? '',
                      style: styleGeorgiaBold(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
