import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/arena/provider/arena.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../widgets/card.dart';

class DayTrainingTimer extends StatelessWidget {
  const DayTrainingTimer({super.key});

  @override
  Widget build(BuildContext context) {
    ArenaProvider provider = context.watch<ArenaProvider>();

    return SizedBox(
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
    );
  }
}
