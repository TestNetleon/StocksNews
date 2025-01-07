import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/models/tournament.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/custom_gridview.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../provider/tournament.dart';
import '../dayTraining/index.dart';

class TournamentGrids extends StatelessWidget {
  const TournamentGrids({super.key});

  _onTap(index, int? id) {
    if (index == 0) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => TournamentDayTrainingIndex(
            tournamentId: id,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

    return CustomGridView(
      length: provider.data?.tournaments?.length ?? 0,
      getChild: (index) {
        Tournament? data = provider.data?.tournaments?[index];
        return GestureDetector(
          onTap: () {
            _onTap(
              index,
              data?.tournamentId,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.greyBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImagesWidget(
                    data?.image,
                    // height: 100,
                    // width: 100,
                  ),
                ),
                SpacerVertical(height: 10),
                Text(
                  data?.name ?? '',
                  style: styleGeorgiaBold(color: ThemeColors.greyText),
                ),
                Text(
                  '${data?.point ?? 0}',
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
