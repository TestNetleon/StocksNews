import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/search_res.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/widgets/pop_up.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../utils/bottom_sheets.dart';
import '../searchTicker/index.dart';

class CompareNewAddHeader extends StatelessWidget {
  const CompareNewAddHeader({super.key});

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();
    return Row(
      children: [
        _buildItem(provider, 0),
        _buildItem(provider, 1),
        _buildItem(provider, 2),
      ],
    );
  }

  Widget _buildItem(CompareStocksProvider provider, int index) {
    if ((provider.compareData.length > index)) {
      return _afterAdd(
        provider,
        data: provider.compareData,
        index: index,
        showBorder: index == 0,
      );
    } else {
      if (index < 2) {
        return _headerWidget(showBorder: index == 0);
      } else {
        return Container();
      }
    }
  }

  _showPopUp(BuildContext context) {
    context.read<SearchProvider>().clearSearch();
    showDialog(
        context: context,
        builder: (context) {
          return const CompareStocksPopup(
            fromAdd: true,
          );
        });
  }

  _showBottomSheet() {
    showModalBottomSheet(
      useSafeArea: true,
      backgroundColor: ThemeColors.transparent,
      // constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 100),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.sp),
          topRight: Radius.circular(5.sp),
        ),
      ),
      context: navigatorKey.currentContext!,
      builder: (context) {
        return const CompareNewSearch();
      },
    );
  }

  Widget _afterAdd(
    CompareStocksProvider provider, {
    showBorder = false,
    required List<SearchRes> data,
    required int index,
  }) {
    return Expanded(
      child: InkWell(
        // borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Ink(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(8),
              // color: ThemeColors.greyBorder.withOpacity(0.4),
              border: Border(
            right: data.length == 1
                ? BorderSide.none
                : data.length == 2 && index == 0
                    ? BorderSide(
                        color: ThemeColors.greyBorder.withOpacity(0.4),
                      )
                    : data.length == 3 && (index == 0 || index == 1)
                        ? BorderSide(
                            color: ThemeColors.greyBorder.withOpacity(0.4),
                          )
                        : BorderSide.none,
          )),
          width: ScreenUtil().screenWidth * 0.3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpacerVertical(height: 10),
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: CachedNetworkImagesWidget(data[index].image),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    data[index].symbol,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: stylePTSansRegular(),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    data[index].name,
                    style: stylePTSansRegular(
                        fontSize: 11, color: ThemeColors.greyText),
                  ),
                ],
              ),
              Visibility(
                // visible: provider.company.length != 1,
                child: Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => provider.removeFromCompare(index: index),
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.close,
                          color: ThemeColors.greyBorder,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerWidget({showBorder = false}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // _showPopUp(navigatorKey.currentContext!);
          _showBottomSheet();
        },
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(
            right: showBorder
                ? BorderSide(
                    color: ThemeColors.greyBorder.withOpacity(0.4),
                  )
                : BorderSide.none,
          )),
          width: ScreenUtil().screenWidth * 0.3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpacerVertical(height: 10),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ThemeColors.greyBorder)),
                    child: const Icon(Icons.stacked_line_chart_outlined,
                        size: 20, color: ThemeColors.greyBorder),
                  ),
                  const SpacerVertical(height: 8),
                  Text(
                    "Add Stock",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: stylePTSansRegular(
                        fontSize: 14, color: ThemeColors.greyText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
