import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/league_titan_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/filter_list.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class LeagueFilter extends StatelessWidget {
  final TournamentsHead? selectedTournament;
  const LeagueFilter({super.key,this.selectedTournament});


  void showTransactionSizePicker(BuildContext context) {
    LeagueManager manager = context.read<LeagueManager>();
    LeagueTitanRes? leagueTitanRes= manager.leagueTitanRes;
    BaseBottomSheet().bottomSheet(
      child: FilterListing(
        items: List.generate(leagueTitanRes?.ranks?.length ?? 0, (index) {
          return KeyValueElement(
              key: leagueTitanRes?.ranks?[index].key,
              value: leagueTitanRes?.ranks?[index].value);
        }),
        onSelected: (index) {
          manager.onChangeTransactionSize(
            selectedItem: leagueTitanRes?.ranks?[index],
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
    LeagueManager manager = context.watch<LeagueManager>();
    LeagueTitanRes? leagueTitanRes= manager.leagueTitanRes;
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseHeading(
            title: "Filter ${leagueTitanRes?.title ??"Trading Leagues"}",
          ),
          Visibility(
            visible: (selectedTournament==TournamentsHead.playTraders|| selectedTournament==TournamentsHead.topTitan),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search",
                  style: styleBaseRegular(),
                ),
                const SpacerVertical(height: 5),
                BaseTextField(
                  hintText: "Search Name",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  onChanged: (text) {
                    manager.valueSearch=text;
                  },
                  editable: true,
                  suffixIcon: const Icon(Icons.search, size: 23),
                  controller: manager.searchController,
                ),
              ],
            ),
          ),
          Visibility(
              visible:(selectedTournament==TournamentsHead.playTraders|| selectedTournament==TournamentsHead.topTitan),
              child: const SpacerVertical(height: 20)
          ),

          //if((selectedTournament!=TournamentsHead.tradTotal) || (selectedTournament!=TournamentsHead.pPaid))
          Visibility(
           // visible: (selectedTournament==TournamentsHead.playTraders|| selectedTournament==TournamentsHead.topTitan),
            visible: leagueTitanRes?.ranks!=null && leagueTitanRes?.ranks?.isNotEmpty==true,
            child: GestureDetector(
              onTap: () => showTransactionSizePicker(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rank", style: styleBaseRegular()),
                  const SpacerVertical(height: 5),
                  BaseTextField(
                    hintText: leagueTitanRes?.ranks?[0].value,
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      size: 23,
                    ),
                    editable: false,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    controller: manager.txnSizeController,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible:!(selectedTournament==TournamentsHead.playTraders||selectedTournament==TournamentsHead.topTitan),
            child: GestureDetector(
              onTap: manager.pickDate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date",
                    style: styleBaseRegular(),
                  ),
                  const SpacerVertical(height: 5),
                  BaseTextField(
                    suffixIcon: const Icon(Icons.calendar_month, size: 23),
                    hintText: "MM DD, YYYY",
                    editable: false,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    controller: manager.date,
                  ),
                ],
              ),
            ),
          ),
          const SpacerVertical(height: 20),
          Row(
            children: [
              Expanded(
                child: BaseButton(
                  //color: ThemeColors.accent,
                  onPressed: () {
                    Navigator.pop(context);
                    closeKeyboard();
                    manager.getAllTitans(
                      clear: true,
                      selectedTournament:selectedTournament!,
                      //isFilter: false
                    );
                  },
                  text: "RESET",
                  //textColor: Colors.white,
                ),
              ),
              SpacerHorizontal(width: 10),
              Expanded(
                child: BaseButton(
                //  color: ThemeColors.accent,
                  onPressed: () {
                    Navigator.pop(context);
                    closeKeyboard();
                    manager.getAllTitans(
                      clear: false,
                      selectedTournament:selectedTournament!,
                      //isFilter: true
                    );
                  },
                  text: "FILTER",
                //  textColor: Colors.white,
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
