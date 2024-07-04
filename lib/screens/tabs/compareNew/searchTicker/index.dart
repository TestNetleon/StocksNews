import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/search_res.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../widgets/cache_network_image.dart';
import '../../../../widgets/spacer_horizontal.dart';

//
class CompareNewSearch extends StatefulWidget {
  final bool fromAdd;
  const CompareNewSearch({super.key, this.fromAdd = false});

  @override
  State<CompareNewSearch> createState() => _CompareNewSearchState();
}

class _CompareNewSearchState extends State<CompareNewSearch> {
  Timer? _timer;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void dispose() {
    _timer?.cancel();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(searchFocusNode);
      context.read<SearchProvider>().clearSearch();
    });
  }

  void _searchApiCall(String text) {
    if (text.isEmpty) {
      context.read<SearchProvider>().clearSearch();
    } else {
      Map request = {
        "term": text,
        "token": context.read<UserProvider>().user?.token ?? ""
      };
      context.read<SearchProvider>().searchSymbols(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider compareProvider =
        context.watch<CompareStocksProvider>();
    SearchProvider provider = context.watch<SearchProvider>();

    var outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimen.radius.r),
      borderSide: const BorderSide(
        color: ThemeColors.primaryLight,
        width: 1,
      ),
    );
    return GestureDetector(
      onTap: () {
        closeKeyboard();
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().screenHeight - 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.sp),
            topRight: Radius.circular(10.sp),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ThemeColors.bottomsheetGradient, Colors.black],
          ),
          // gradient: const RadialGradient(
          //   center: Alignment.bottomCenter,
          //   radius: 0.6,
          //   // transform: GradientRotation(radians),
          //   // tileMode: TileMode.decal,
          //   stops: [
          //     0.0,
          //     0.9,
          //   ],
          //   colors: [
          //     Color.fromARGB(255, 0, 93, 12),
          //     // ThemeColors.accent.withOpacity(0.1),
          //     Colors.black,
          //   ],
          // ),
          color: ThemeColors.background,
          border: const Border(
            top: BorderSide(color: ThemeColors.greyBorder),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 6.sp,
              width: 50.sp,
              margin: EdgeInsets.only(top: 8.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: ThemeColors.greyBorder,
              ),
            ),
            const SpacerVertical(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ScreenTitle(title: "Search a stock to compare"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  TextField(
                    focusNode: searchFocusNode,
                    cursorColor: ThemeColors.border,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.sentences,
                    style: stylePTSansRegular(
                      fontSize: 14,
                      color: ThemeColors.background,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search stock to compare",
                      hintStyle: stylePTSansRegular(
                        fontSize: 14,
                        color: ThemeColors.greyText,
                      ),
                      constraints: const BoxConstraints(
                        minHeight: 0,
                        // maxHeight: 50,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(
                        10.sp,
                        10.sp,
                        12.sp,
                        10.sp,
                      ),
                      filled: true,
                      fillColor: ThemeColors.white,
                      enabledBorder: outlineInputBorder,
                      border: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      counterText: '',
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 22,
                        color: ThemeColors.greyText,
                      ),
                    ),
                    onChanged: (value) {
                      if (_timer != null) {
                        _timer!.cancel();
                      }
                      _timer = Timer(
                        const Duration(milliseconds: 1000),
                        () {
                          _searchApiCall(value);
                        },
                      );
                    },
                  ),
                  Positioned(
                    right: 10.sp,
                    top: 12.sp,
                    child: Visibility(
                      visible: provider.isLoading,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: provider.data != null,
              child: Expanded(
                child: Container(
                  padding: EdgeInsets.all(Dimen.padding.sp),
                  margin: EdgeInsets.only(top: 5.sp),
                  child: ListView.separated(
                    // shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      SearchRes? data = provider.data?[index];
                      return InkWell(
                        onTap: widget.fromAdd
                            ? () {
                                if (data != null) {
                                  Navigator.pop(context);
                                  compareProvider.addInCompare(data: data);
                                }
                              }
                            : () => compareProvider.addStockItem(
                                  fromMain: true,
                                  symbol: data?.symbol ?? "",
                                  name: data?.name,
                                  image: data?.image,
                                ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.sp),
                          child: Row(
                            children: [
                              Container(
                                  width: 43.sp,
                                  height: 43.sp,
                                  padding: EdgeInsets.all(5.sp),
                                  child:
                                      CachedNetworkImagesWidget(data?.image)),
                              const SpacerHorizontal(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.symbol ?? '',
                                      style: stylePTSansRegular(fontSize: 14),
                                    ),
                                    Text(
                                      data?.name ?? '',
                                      style: stylePTSansRegular(
                                          fontSize: 12,
                                          color: ThemeColors.greyText),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: ThemeColors.dividerDark);
                    },
                    itemCount: provider.data?.length ?? 0,
                    // itemCount: 10,
                  ),
                ),
              ),
            ),
            Visibility(
              visible:
                  provider.data == null && provider.status == Status.loaded,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Const.errNoRecord,
                        style: stylePTSansRegular(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
