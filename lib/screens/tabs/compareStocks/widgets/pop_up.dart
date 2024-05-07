import 'dart:async';
import 'dart:ui';

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
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

//
class CompareStocksPopup extends StatefulWidget {
  const CompareStocksPopup({super.key});

  @override
  State<CompareStocksPopup> createState() => _CompareStocksPopupState();
}

class _CompareStocksPopupState extends State<CompareStocksPopup> {
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
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
            ),
          ),
        ),
        Dialog(
          insetPadding: EdgeInsets.all(10.sp),
          backgroundColor: ThemeColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.sp),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(40.sp),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close),
                    ),
                  ),
                  const SpacerVertical(height: 5),
                  Stack(
                    children: [
                      TextField(
                        focusNode: searchFocusNode,
                        cursorColor: ThemeColors.border,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.sentences,
                        style: stylePTSansRegular(
                          fontSize: 14.sp,
                          color: ThemeColors.background,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search stock to compare",
                          hintStyle: stylePTSansRegular(
                            fontSize: 14.sp,
                            color: ThemeColors.greyText,
                          ),
                          constraints: const BoxConstraints(
                            minHeight: 0,
                            maxHeight: 50,
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
                  Visibility(
                    visible: provider.data != null,
                    child: Container(
                      padding: EdgeInsets.all(Dimen.padding.sp),
                      margin: EdgeInsets.only(top: 5.sp),
                      decoration: BoxDecoration(
                        color: ThemeColors.primaryLight,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(Dimen.radius.r),
                          bottomRight: Radius.circular(Dimen.radius.r),
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          SearchRes? data = provider.data?[index];
                          return InkWell(
                            onTap: () => compareProvider.addStockItem(
                                symbol: data?.symbol ?? "", index: index),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.sp),
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
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(color: ThemeColors.dividerDark);
                        },
                        itemCount: provider.data?.length ?? 0,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: provider.data == null &&
                        provider.status == Status.loaded,
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
          ),
        ),
      ],
    );
  }
}
