import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/screens/drawerScreens/widget/market_data_filter_textfiled.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/filter_list.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class MarketDataFilterBottomSheet extends StatelessWidget {
  const MarketDataFilterBottomSheet({required this.provider, super.key});
  final dynamic provider;

  void showTransactionPicker(BuildContext context) {
    BaseBottomSheets().gradientBottomSheet(
      child: FilterListing(
        items: List.generate(provider.transactionType?.length ?? 0, (index) {
          return KeyValueElement(
              key: provider.transactionType?[index].key,
              value: provider.transactionType?[index].value);
        }),
        onSelected: (index) {
          provider.onChangeTransactionType(
            selectedItem: provider.transactionType?[index],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isPhone ? 0 : 0 // ScreenUtil().screenWidth * .15,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MarketDataTextFiledClickable(
              hintText: "All Exchange",
              label: "Exchange Type",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          MarketDataTextFiledClickable(
              hintText: "All Sector",
              label: "Sector",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          MarketDataTextFiledClickable(
              hintText: "All Industry",
              label: "Industry",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          MarketDataTextFiledClickable(
              hintText: "All Market Cap",
              label: "Market Cap",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          MarketDataTextFiledClickable(
              hintText: "All Price",
              label: "Price",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          MarketDataTextFiledClickable(
              hintText: "All Beta",
              label: "Beta",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          MarketDataTextFiledClickable(
              hintText: "All Dividend",
              label: "Dividend",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          MarketDataTextFiledClickable(
              hintText: "All",
              label: "Is Etf",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          MarketDataTextFiledClickable(
              hintText: "All",
              label: "Is Fund",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          MarketDataTextFiledClickable(
              hintText: "All",
              label: "Is ActivelyTrading",
              onTap: () {},
              controller: TextEditingController()),
          const SpacerVertical(height: 20),
          ThemeButton(
            color: ThemeColors.accent,
            onPressed: () {
              // Navigator.pop(context);
              // provider.getData(
              //   showProgress: false,
              //   clear: false,
              // );
            },
            text: "FILTER",
            textColor: Colors.white,
          ),
          const SpacerVertical(height: 10),
        ],
      ),
    );
  }
}
