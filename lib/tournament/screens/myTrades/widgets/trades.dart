import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';

class TournamentTrades extends StatefulWidget {
  const TournamentTrades({super.key});

  @override
  State<TournamentTrades> createState() => _TournamentTradesState();
}

class _TournamentTradesState extends State<TournamentTrades> {
  TextEditingController search = TextEditingController();
  // ignore: unused_field
  num _selectedTradeType = 0;

  selectedIndex(index) {
    _selectedTradeType = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TournamentTradesProvider provider =
    //     context.watch<TournamentTradesProvider>();

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimen.radius),
      borderSide: BorderSide(
        color: ThemeColors.primaryLight,
        width: 1,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              cursorColor: ThemeColors.white,
              controller: search,
              maxLength: 60,
              minLines: 1,
              maxLines: 1,
              enabled: true,
              textCapitalization: TextCapitalization.sentences,
              style: stylePTSansBold(fontSize: isPhone ? 14 : 7),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: stylePTSansRegular(
                  fontSize: 14,
                  color: ThemeColors.greyText,
                ),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                filled: true,
                fillColor: ThemeColors.primaryLight,
                enabledBorder: outlineInputBorder,
                border: outlineInputBorder,
                focusedBorder: outlineInputBorder,
                counterText: '',
                prefixIcon: Icon(
                  Icons.search,
                  size: 22,
                  color: ThemeColors.greyText,
                ),
              ),
              onChanged: (value) {},
            ),
            Positioned(
              right: 10,
              child: Visibility(
                visible: false,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        SpacerVertical(height: 10),
        // Wrap(
        //   direction: Axis.horizontal,
        //   spacing: 10.0,
        //   runSpacing: 10.0,
        //   children: List.generate(
        //     provider.trades.length,
        //     (index) {
        //       return GestureDetector(
        //         onTap: () => selectedIndex(index),
        //         child: Container(
        //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(8),
        //               color: ThemeColors.greyBorder.withOpacity(0.5),
        //               border: _selectedTradeType == index
        //                   ? Border.all(color: ThemeColors.white)
        //                   : null),
        //           child: Text(
        //             '${provider.trades[index].name} ${provider.trades[index].total}',
        //             style: styleGeorgiaBold(),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        // SpacerVertical(height: 10),
        // Expanded(
        //   child: ListView.separated(
        //     physics: AlwaysScrollableScrollPhysics(),
        //     itemBuilder: (context, index) {
        //       List<TradingSearchTickerRes> filteredData;
        //       if (_selectedTradeType == 1) {
        //         filteredData =
        //             provider.data.where((item) => item.isOpen == true).toList();
        //       } else if (_selectedTradeType == 2) {
        //         filteredData = provider.data
        //             .where((item) => item.isOpen == false)
        //             .toList();
        //       } else {
        //         filteredData = provider.data;
        //       }
        //       TradingSearchTickerRes data = filteredData[index];
        //       return GestureDetector(
        //         onTap: () {
        //           Navigator.pop(context, data);
        //         },
        //         child: TournamentStockItem(
        //           data: data,
        //         ),
        //       );
        //     },
        //     separatorBuilder: (context, index) {
        //       return SpacerVertical(height: 20);
        //     },
        //     // itemCount: provider.data.length,
        //     itemCount: _selectedTradeType == 0
        //         ? provider.data.length
        //         : (_selectedTradeType == 1
        //             ? provider.data.where((item) => item.isOpen == true).length
        //             : provider.data
        //                 .where((item) => item.isOpen == false)
        //                 .length),
        //   ),
        // ),
      ],
    );
  }
}
