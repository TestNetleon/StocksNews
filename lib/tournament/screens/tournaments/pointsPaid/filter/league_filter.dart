import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/filter_list.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/text_input_field.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class LeagueFilter extends StatelessWidget {
  final TournamentsHead? selectedTournament;
  const LeagueFilter({super.key,this.selectedTournament});


  void showTransactionSizePicker(BuildContext context) {
    TournamentProvider provider = context.read<TournamentProvider>();

    BaseBottomSheets().gradientBottomSheet(
      child: FilterListing(
        items: List.generate(provider.ranks?.length ?? 0, (index) {
          return KeyValueElement(
              key: provider.ranks?[index].key,
              value: provider.ranks?[index].value);
        }),
        onSelected: (index) {
          provider.onChangeTransactionSize(
            selectedItem: provider.ranks?[index],
          );
        },
      ),
    );
  }

  void closeKeyboard() {
    try {
      SystemChannels.textInput.invokeMethod("TextInput.hide");
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (e) {
      //
    }
  }
  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Visibility(
            visible: selectedTournament==TournamentsHead.playTraders,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search",
                  style: stylePTSansRegular(),
                ),
                const SpacerVertical(height: 5),
                TextInputField(
                  hintText: "Search...",
                  style: stylePTSansRegular(
                    fontSize: 15,
                    color: ThemeColors.background,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  onChanged: (text) {
                    provider.valueSearch=text;
                  },
                  editable: true,
                  suffix: const Icon(Icons.search, size: 23),
                  controller: provider.searchController,
                ),
              ],
            ),
          ),
          Visibility(
              visible: selectedTournament==TournamentsHead.playTraders,
              child: const SpacerVertical(height: 20)
          ),

          Visibility(
            visible: selectedTournament==TournamentsHead.playTraders,
            child: GestureDetector(
              onTap: () => showTransactionSizePicker(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rank", style: stylePTSansRegular()),
                  const SpacerVertical(height: 5),
                  TextInputField(
                    hintText: provider.ranks?[0].value,
                    suffix: const Icon(
                      Icons.arrow_drop_down,
                      size: 23,
                      color: ThemeColors.background,
                    ),
                    style: stylePTSansRegular(
                      fontSize: 15,
                      color: ThemeColors.background,
                    ),
                    editable: false,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    controller: provider.txnSizeController,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: selectedTournament!=TournamentsHead.playTraders,
            child: GestureDetector(
              onTap: provider.pickDate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date",
                    style: stylePTSansRegular(),
                  ),
                  const SpacerVertical(height: 5),
                  TextInputField(
                    suffix: const Icon(Icons.calendar_month, size: 23),
                    style: stylePTSansRegular(
                      fontSize: 15,
                      color: ThemeColors.background,
                    ),
                    hintText: "mm dd, yyyy",
                    editable: false,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    controller: provider.date,
                  ),
                ],
              ),
            ),
          ),
          const SpacerVertical(height: 20),
          Row(
            children: [
              Expanded(
                child: ThemeButton(
                  color: ThemeColors.accent,
                  onPressed: () {
                    Navigator.pop(context);
                    closeKeyboard();
                    provider.pointsPaidAPI(
                      clear: false,
                      selectedTournament:selectedTournament!,
                      //isFilter: true
                    );
                  },
                  text: "FILTER",
                  textColor: Colors.white,
                ),
              ),
              SpacerHorizontal(width: 10),
              Expanded(
                child: ThemeButton(
                  color: ThemeColors.accent,
                  onPressed: () {
                    Navigator.pop(context);
                    closeKeyboard();
                    provider.pointsPaidAPI(
                        clear: true,
                        selectedTournament:selectedTournament!,
                        //isFilter: false
                    );
                  },
                  text: "RESET",
                  textColor: Colors.white,
                ),
              ),
            ],
          ),

          const SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
