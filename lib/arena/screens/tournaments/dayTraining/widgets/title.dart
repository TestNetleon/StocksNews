import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/theme.dart';
import '../open/index.dart';

class DayTrainingTitle extends StatelessWidget {
  const DayTrainingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      style: styleGeorgiaRegular(color: ThemeColors.greyText),
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
                      style: styleGeorgiaRegular(color: ThemeColors.greyText),
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
    );
  }
}
