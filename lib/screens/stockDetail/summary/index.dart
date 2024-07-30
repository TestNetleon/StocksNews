import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/trade_provider.dart';
import 'package:stocks_news_new/screens/stockDetail/summary/item.dart';
import 'package:stocks_news_new/screens/stockDetail/summary/searchTicker/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';

String formatBalance(num balance) {
  final formatter = NumberFormat('#,##0.00');
  return formatter.format(balance);
}

class SdSummaryOrders extends StatelessWidget {
  const SdSummaryOrders({super.key});

  @override
  Widget build(BuildContext context) {
    TradeProviderNew provider = context.watch<TradeProviderNew>();
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        title: "Virtual Trading Account",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
        child: Column(
          children: [
            // const ScreenTitle(
            //   title: "Virtual Trading Account",
            //   dividerPadding: EdgeInsets.only(bottom: 10),
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     boxShadow: const [
            //       BoxShadow(
            //         blurStyle: BlurStyle.solid,
            //         spreadRadius: 2,
            //         color: Color.fromARGB(255, 27, 27, 27),
            //         blurRadius: 0.1,
            //         offset: Offset(0, 2.5),
            //       ),
            //     ],
            //     color: ThemeColors.background,
            //     borderRadius: BorderRadius.circular(5),
            //     // border: Border.all(
            //     //   color: ThemeColors.greyBorder.withOpacity(0.4),
            //     // ),
            //   ),
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //   child: Column(
            //     children: [
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Flexible(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   "\$${provider.data.availableBalance.toCurrency()}",
            //                   style: styleGeorgiaBold(fontSize: 25),
            //                 ),
            //                 const SpacerVertical(height: 5),
            //                 Text(
            //                   "Total Portfolio",
            //                   style: stylePTSansRegular(
            //                       fontSize: 15, color: ThemeColors.greyText),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           const SpacerHorizontal(width: 10),
            //           Flexible(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.end,
            //               children: [
            //                 Text(
            //                   "\$${provider.data.invested.toCurrency()}",
            //                   style: styleGeorgiaBold(fontSize: 25),
            //                 ),
            //                 const SpacerVertical(height: 5),
            //                 Text(
            //                   "Positions P&L",
            //                   style: stylePTSansRegular(
            //                       fontSize: 15, color: ThemeColors.greyText),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SpacerVertical(height: 30),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Column(
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.all(8),
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   color: ThemeColors.greyBorder.withOpacity(0.6),
            //                 ),
            //                 child: const Icon(
            //                   Icons.arrow_circle_down,
            //                 ),
            //               ),
            //               const SpacerVertical(height: 5),
            //               Text(
            //                 "Deposit",
            //                 style: stylePTSansRegular(fontSize: 12),
            //               ),
            //             ],
            //           ),
            //           const SpacerHorizontal(width: 30),
            //           Column(
            //             children: [
            //               Container(
            //                 padding: const EdgeInsets.all(8),
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   color: ThemeColors.greyBorder.withOpacity(0.6),
            //                 ),
            //                 child: const Icon(Icons.arrow_circle_up),
            //               ),
            //               const SpacerVertical(height: 5),
            //               Text(
            //                 "Withdraw",
            //                 style: stylePTSansRegular(fontSize: 12),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    ThemeColors.accent,
                    Color.fromARGB(255, 222, 215, 7),
                  ],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: ThemeColors.background,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "\$${formatBalance(num.parse(provider.data.availableBalance.toCurrency()))}",
                                  style: styleGeorgiaBold(fontSize: 25),
                                ),
                                const SpacerVertical(height: 5),
                                Text(
                                  "Total Portfolio",
                                  style: stylePTSansRegular(
                                      fontSize: 15,
                                      color: ThemeColors.greyText),
                                ),
                              ],
                            ),
                          ),
                          const SpacerHorizontal(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$${provider.data.invested.toCurrency()}",
                                  style: styleGeorgiaBold(fontSize: 25),
                                ),
                                const SpacerVertical(height: 5),
                                Text(
                                  "Positions P&L",
                                  style: stylePTSansRegular(
                                      fontSize: 15,
                                      color: ThemeColors.greyText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SpacerVertical(height: 30),
                      Row(
                        children: [
                          // Expanded(
                          //   child: ThemeButtonSmall(
                          //     textSize: 17,
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 15, vertical: 5),
                          //     onPressed: () {
                          //       showModalBottomSheet(
                          //           isScrollControlled: true,
                          //           useSafeArea: true,
                          //           backgroundColor: Colors.transparent,
                          //           context: navigatorKey.currentContext!,
                          //           builder: (context) {
                          //             return Padding(
                          //               padding: EdgeInsets.only(
                          //                 bottom: MediaQuery.of(context)
                          //                     .viewInsets
                          //                     .bottom,
                          //               ),
                          //               child: const DepositMoney(),
                          //             );
                          //           });
                          //     },
                          //     text: "Deposit",
                          //     icon: Icons.arrow_circle_down_outlined,
                          //   ),
                          // ),
                          // const SpacerHorizontal(width: 10),
                          Expanded(
                            child: ThemeButtonSmall(
                              textSize: 17,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              onPressed: () {
                                tradeSheet();
                                // Navigator.push(
                                //     context, createRoute(const SdSearchTicker()));
                              },
                              text: "Place New Virtual Trade",
                              color: const Color.fromARGB(255, 194, 216, 51),
                              icon: Icons.arrow_outward_outlined,
                              textColor: ThemeColors.background,
                            ),
                          ),
                          // Column(
                          //   children: [
                          //     Container(
                          //       padding: const EdgeInsets.all(8),
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: ThemeColors.greyBorder.withOpacity(0.6),
                          //       ),
                          //       child: const Icon(Icons.arrow_circle_up),
                          //     ),
                          //     const SpacerVertical(height: 5),
                          //     Text(
                          //       "Withdraw",
                          //       style: stylePTSansRegular(fontSize: 12),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SpacerVertical(height: 20),
            Expanded(
              child: CommonTabContainer(
                scrollable: false,
                tabPaddingNew: false,
                tabs: const [
                  "Open",
                  "Pending",
                  "Closed",
                ],
                widgets: [
                  provider.orders.isEmpty
                      ? const SummaryErrorWidget(
                          title: "No open orders",
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            SummaryOrderNew? order = provider.orders[index];
                            return SdSummaryItem(
                              order: order,
                              onTap: () {
                                tradeSheet(
                                  symbol: order.symbol,
                                  doPop: false,
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SpacerVertical();
                          },
                          itemCount: provider.orders.length,
                        ),
                  const SummaryErrorWidget(
                    title: "No pending orders",
                  ),
                  const SummaryErrorWidget(
                    title: "No closed orders",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryErrorWidget extends StatelessWidget {
  final String title;
  final String? error;

  const SummaryErrorWidget({
    super.key,
    this.title = "Title",
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              title,
              style: stylePTSansBold(fontSize: 20),
            ),
            const SpacerVertical(height: 15),
            Text(
              error ??
                  "Use the opportunity to trade on the world's major financial markets",
              style: stylePTSansRegular(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DepositMoney extends StatefulWidget {
  const DepositMoney({super.key});

  @override
  State<DepositMoney> createState() => _DepositMoneyState();
}

class _DepositMoneyState extends State<DepositMoney> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
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
        color: ThemeColors.background,
        border: const Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SpacerVertical(),
              Text(
                "Deposit Funds",
                style: stylePTSansBold(fontSize: 20),
              ),
              const SpacerVertical(
                height: 10,
              ),
              ThemeInputField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(7),
                ],
              ),
              const SpacerVertical(height: 10),
              ThemeButton(
                onPressed: () {
                  Navigator.pop(context);

                  if (controller.text.isEmpty || controller.text == '0') {
                    return;
                  }
                  context
                      .read<TradeProviderNew>()
                      .addAmount(num.parse(controller.text));
                },
                text: "Add Amount",
              ),
              const SpacerVertical(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
