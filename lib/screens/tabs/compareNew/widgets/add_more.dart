import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../providers/compare_stocks_provider.dart';
import '../../../../providers/search_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../compareStocks/widgets/pop_up.dart';

class CompareNewAddMore extends StatelessWidget {
  const CompareNewAddMore({super.key});
  _showPopUp(BuildContext context) {
    context.read<SearchProvider>().clearSearch();
    showDialog(
        context: context,
        builder: (context) {
          return const CompareStocksPopup();
        });
  }

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();

    return Visibility(
      visible:
          provider.company.isEmpty == true || (provider.company.length) < 3,
      child: Padding(
        padding:
            EdgeInsets.only(left: provider.company.isEmpty == true ? 0 : 5),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            _showPopUp(context);
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ThemeColors.greyBorder.withOpacity(0.4),
            ),
            width: ScreenUtil().screenWidth * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add),
                const SpacerVertical(height: 10),
                Text(
                  "Add Stocks",
                  style: stylePTSansRegular(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
