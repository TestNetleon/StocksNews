import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/insider_trading_res.dart';
import 'package:stocks_news_new/providers/insider_trading_provider.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/item_back.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class InsiderContent extends StatefulWidget {
  const InsiderContent({super.key});

  @override
  State<InsiderContent> createState() => _InsiderContentState();
}

//
class _InsiderContentState extends State<InsiderContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.read<InsiderTradingProvider>().getData(showProgress: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    InsiderTradingProvider provider = context.watch<InsiderTradingProvider>();

    return BaseUiContainer(
      isLoading: provider.isLoading,
      hasData: provider.data != null &&
          (provider.data?.data.isNotEmpty ?? false) &&
          !provider.isLoading,
      error: provider.error,
      onRefresh: () => provider.getData(showProgress: true),
      child: RefreshControll(
        onRefresh: () => provider.getData(showProgress: true),
        canLoadmore: provider.canLoadMore,
        onLoadMore: () => provider.getData(loadMore: true, clear: false),
        child: ListView.separated(
          itemCount: provider.data?.data.length ?? 0,
          // physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 12.sp),
          itemBuilder: (context, index) {
            InsiderTradingData? data = provider.data?.data[index];
            if (index == 0) {
              return Column(
                children: [
                  Divider(
                    color: ThemeColors.greyBorder,
                    height: 15.sp,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "COMPANY",
                          textAlign: TextAlign.start,
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ),
                      const SpacerHorizontal(width: 10),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "INSIDER NAME",
                          textAlign: TextAlign.start,
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ),
                      const SpacerHorizontal(width: 10),
                      Expanded(
                        child: Text(
                          "BUY/SELL",
                          textAlign: TextAlign.end,
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: ThemeColors.greyBorder,
                    height: 15.sp,
                    thickness: 1,
                  ),
                  StocksItemTrending(
                    data: data,
                    up: index % 3 == 0,
                    index: index,
                  ),
                ],
              );
            }
            return StocksItemTrending(
              data: data,
              up: index % 3 == 0,
              index: index,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SpacerVerticel(height: 12);
          },
        ),
      ),
    );
  }
}

class StocksItemTrending extends StatelessWidget {
  final bool up;
  final InsiderTradingData? data;
  final int index;

  const StocksItemTrending({
    required this.data,
    required this.index,
    this.up = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    InsiderTradingProvider provider = context.watch<InsiderTradingProvider>();
    return ItemBack(
      color: index % 2 == 0 ? ThemeColors.primaryLight : ThemeColors.background,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.pushNamed(context, StockDetails.path,
                        //     arguments: data?.symbol);
                        Navigator.pushNamed(context, InsiderDetailsType.path,
                            arguments: {
                              "companySlug": data?.companySlug,
                              "companyName": data?.companyName,
                            });
                      },
                      child: Text(
                        "${data?.exchangeShortName}:${data?.symbol}",
                        // "NYSL:TSLA",
                        style: stylePTSansBold(
                          fontSize: 14,
                          color: ThemeColors.accent,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SpacerVerticel(height: 5),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, InsiderDetailsType.path,
                            arguments: {
                              "companySlug": data?.companySlug,
                              "companyName": data?.companyName,
                            });
                      },
                      child: Text(
                        "${data?.companyName.capitalizeWords()}",
                        style: stylePTSansRegular(
                          color: ThemeColors.greyText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SpacerHorizontal(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, InsiderDetailsType.path,
                            arguments: {
                              "companySlug": data?.companySlug,
                              "reportingSlug": data?.reportingSlug,
                              "companyName": data?.companyName,
                              "reportingName": data?.reportingName,
                            });
                      },
                      child: Text(
                        "${data?.reportingName.capitalizeWords()}",
                        style: stylePTSansBold(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SpacerVerticel(height: 5),
                    Text(
                      "${data?.typeOfOwner.capitalizeWords()}",
                      style: stylePTSansRegular(
                        color: ThemeColors.greyText,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SpacerHorizontal(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${data?.transactionType}",
                        // "Buy",
                        style: stylePTSansBold(
                          fontSize: 14,
                          color: data?.transactionType == "Buy"
                              ? ThemeColors.accent
                              : data?.transactionType == "Sell"
                                  ? ThemeColors.sos
                                  : ThemeColors.white,
                        )),
                    const SpacerVerticel(height: 5),
                    GestureDetector(
                      onTap: () {
                        provider.setOpen(
                          provider.openIndex == index ? -1 : index,
                        );
                      },
                      child: Container(
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                          // color: data?.transactionType == "Buy"
                          //     ? ThemeColors.accent
                          //     : data?.transactionType == "Sell"
                          //         ? ThemeColors.sos
                          //         : ThemeColors.white,

                          color: ThemeColors.white,
                        ),
                        margin: EdgeInsets.only(left: 8.sp),
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          provider.openIndex == index
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: ThemeColors.background,
                          size: 16.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            child: Container(
              height: index == provider.openIndex ? null : 0,
              // height: open ? null : 0,
              margin: EdgeInsets.only(
                top: provider.openIndex == index ? 10.sp : 0,
                bottom: provider.openIndex == index ? 10.sp : 0,
              ),
              child: Column(
                children: [
                  InnerRowItem(
                    lable: "Shares Bought/Sold",
                    value: "${data?.securitiesTransacted}",
                  ),
                  InnerRowItem(
                    lable: "Total Transaction",
                    value: "${data?.totalTransaction}",
                  ),
                  InnerRowItem(
                    lable: "Shares Held After Transaction",
                    value: "${data?.securitiesOwned}",
                  ),
                  InnerRowItem(
                    lable: "Transaction Date",
                    value: "${data?.transactionDateNew}",
                  ),
                  InnerRowItem(
                    lable: "Details",
                    link: true,
                    value: "${data?.link}",
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InnerRowItem extends StatelessWidget {
  final String lable;
  final String? value;
  final bool link;

  const InnerRowItem({
    required this.lable,
    this.value,
    this.link = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lable, style: stylePTSansBold(fontSize: 14)),
              Flexible(
                child: !link
                    ? Text(value ?? '', style: stylePTSansBold(fontSize: 14))
                    : InkWell(
                        onTap: () => openUrl(value),
                        child: Text(
                          "See Details",
                          style: stylePTSansBold(
                              fontSize: 14,
                              color: ThemeColors.accent,
                              decoration: TextDecoration.underline),
                        ),
                      ),
              ),
            ],
          ),
        ),
        // Divider(
        //   color: ThemeColors.dividerDark,
        //   height: 1.sp,
        //   thickness: 1.sp,
        // )
        Divider(
          color: ThemeColors.greyBorder,
          height: 1.sp,
        )
      ],
    );
  }
}
