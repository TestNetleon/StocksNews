import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/arena/provider/arena.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/theme.dart';
import '../../../../../widgets/spacer_vertical.dart';
import '../../../../../widgets/theme_button.dart';
import '../../../../widgets/card.dart';
import '../open/index.dart';

class DayTrainingTitle extends StatelessWidget {
  const DayTrainingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    ArenaProvider provider = context.watch<ArenaProvider>();

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ArenaThemeCard(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 15,
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Closes in ',
                    style: styleGeorgiaRegular(color: ThemeColors.greyText),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Text(
                      ' ${provider.timeRemaining['hours']} ',
                      style: styleGeorgiaBold(fontSize: 20),
                    ),
                  ),
                  TextSpan(
                    text: ' hours : ',
                    style: styleGeorgiaRegular(color: ThemeColors.greyText),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Text(
                      ' ${provider.timeRemaining['minutes']} ',
                      style: styleGeorgiaBold(fontSize: 20),
                    ),
                  ),
                  TextSpan(
                    text: ' minutes : ',
                    style: styleGeorgiaRegular(color: ThemeColors.greyText),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Text(
                      ' ${provider.timeRemaining['seconds']} ',
                      style: styleGeorgiaBold(fontSize: 20),
                    ),
                  ),
                  TextSpan(
                    text: ' seconds ',
                    style: styleGeorgiaRegular(color: ThemeColors.greyText),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Text(
                          'Daily Tournament',
                          style:
                              styleGeorgiaRegular(color: ThemeColors.greyText),
                        ),
                        SpacerVertical(height: 8),
                        Text(
                          'Day Trading',
                          style: styleGeorgiaBold(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Text(
                          'Prize Pool',
                          style:
                              styleGeorgiaRegular(color: ThemeColors.greyText),
                        ),
                        SpacerVertical(height: 8),
                        Text(
                          '1,000',
                          style: styleGeorgiaBold(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 250,
                width: 100,
              ),
              ThemeButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TournamentOpenIndex(),
                    ),
                  );
                },
                text: 'Open',
                radius: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
