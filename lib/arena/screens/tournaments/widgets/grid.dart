import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/custom_gridview.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../provider/arena.dart';
import '../dayTraining/index.dart';

class TournamentGrids extends StatelessWidget {
  const TournamentGrids({super.key});

  _onTap(index) {
    if (index == 0) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => TournamentDayTrainingIndex(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ArenaProvider provider = context.watch<ArenaProvider>();

    return CustomGridView(
      length: provider.tournaments.length,
      getChild: (index) {
        return GestureDetector(
          onTap: () {
            _onTap(index);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.greyBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                ),
                SpacerVertical(height: 10),
                Text(
                  provider.tournaments[index].label ?? '',
                  style: styleGeorgiaBold(color: ThemeColors.greyText),
                ),
                Text(
                  provider.tournaments[index].value ?? '',
                  style: styleGeorgiaBold(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
