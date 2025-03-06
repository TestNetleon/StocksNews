import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_open.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_recurring.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_recurring_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/show_conditional_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradeBuySell/text_field.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradingWithTypes/order_info_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/s_top.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_input_field.dart';


class RecurringContainer extends StatefulWidget {
  final num? editTradeID;
  final int? tickerID;

  const RecurringContainer({
    super.key,
    this.editTradeID,
    this.tickerID
  });

  @override
  State<RecurringContainer> createState() => _RecurringContainerState();
}

class _RecurringContainerState extends State<RecurringContainer> {

  TextEditingController controller = TextEditingController();
  TextEditingController selectedDateController = TextEditingController();

  FocusNode focusNode = FocusNode();
  String _currentText = "0";
  String _lastEntered = "";
  String _previousText = "";
  int _keyCounter = 0;
  num _availableBalance = 0;

  DateTime? selectedDate;
  int? selectedOption;


  final List<DateTime> holidays = [
    DateTime(DateTime.now().year, 1, 1),
    DateTime(DateTime.now().year, 12, 25),
    DateTime(DateTime.now().year, 2, 17),
    DateTime(DateTime.now().year + 1, 1, 1),
  ];

  bool isSelectable(DateTime date) {
    PortfolioManager portfolioManager = context.read<PortfolioManager>();
    return date.weekday != DateTime.saturday &&
        date.weekday != DateTime.sunday &&
        !portfolioManager.holidaysRes!.holidays!.any((holiday) => isSameDate(holiday, date));
  }

  DateTime getNextValidDate(DateTime date) {
    while (!isSelectable(date)) {
      date = date.add(Duration(days: 1));
    }
    return date;
  }

  Future<void> selectDate() async {
    DateTime now = DateTime.now();
    DateTime validInitialDate = getNextValidDate(now);

    DateTime? picked = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: validInitialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 5, 12, 31),
      selectableDayPredicate: isSelectable,
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedOption = null;
      });

    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void initState() {
    super.initState();
    Utils().showLog("ORDER DATA => ${widget.tickerID}");
    selectedDate = getNextValidDate(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _availableBalance = context.read<PortfolioManager>().userData?.userDataRes?.tradeBalance ?? 0;
      if (widget.editTradeID != null) {
        TsRecurringListRes? data = context
            .read<SRecurringManager>()
            .data
            ?.firstWhere((ele) => ele.id == widget.editTradeID);
        if (data != null) {
          setState(() {
            _currentText = (data.recurringAmount ?? 0).toString();
            controller.text = _currentText;
            selectedOption = data.frequency=="market-day"?1:data.frequency=="weekly"?2:data.frequency=="bi-weekly"?3:4;
          });
        }
      }

    });
  }

  @override
  void dispose() {
    controller.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
    super.dispose();
  }

  _onTap() async {
    closeKeyboard();
    TradeManager manager = context.read<TradeManager>();
    BaseTickerRes? detailRes = manager.detailRes;
    if (detailRes?.executable == false) {
      popUpAlert(
        title: "Confirm Order",
        message:
            "You are making transaction when market is closed. Your transaction will be take place when market is open. This order will be pending until then.",
        okText: "Continue",
        onTap: () {
          Navigator.pop(context);
          _onContinue(isPending: true);
        },
        cancel: true,
      );
    } else {
      _onContinue();
    }
  }

  _onContinue({bool isPending = false}) async {
    TradeManager manager = context.read<TradeManager>();
    PortfolioManager portfolioManager = context.read<PortfolioManager>();
    BaseTickerRes? detailRes = manager.detailRes;
    num invested = (detailRes?.price ?? 0) * num.parse(_currentText);
    closeKeyboard();

    if (widget.editTradeID != null) {
      final Map<String, dynamic> request = {
        //"token": navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "recurring_amount": controller.text,
        "order_type":"RECURRING_ORDER",
        "recurring_date":selectedDateController.text,
        "recurring_frequency": selectedOption==1?"market-day":selectedOption==2?"weekly":selectedOption==3?"bi-weekly":"monthly",
      };
      ApiResponse response = await manager.requestUpdateShare(
        id: widget.editTradeID ?? 0,
        request: request,
        showProgress: true,
      );
      if (response.status) {
        context.read<SOpenManager>().getData();
        final order = SummaryOrderNew(
          image: detailRes?.image,
          name: detailRes?.name,
          symbol: detailRes?.symbol,
          invested: invested,
          date: response.data['result']['created_date'],
          selectedOption: selectedOption,
          investedPrice:  controller.text.isNotEmpty?num.parse(controller.text):0,
          targetPrice: 0,
          stopPrice:0,
          limitPrice:0,
        );

        Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,arguments: {"initialIndex":3});


        _clear();
        await showCOrderSuccessSheet(order, ConditionType.recurringOrder);
      } else {
        popUpAlert(
          message: "${response.message}",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      }
      return;
    }
    if (invested > (portfolioManager.userData?.userDataRes?.tradeBalance ?? 0)) {
      popUpAlert(
        message: "Insufficient available balance to place this order.",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }
    else {
      final Map<String, dynamic> request = {
        // "token":
        // navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": detailRes?.symbol,
        "recurring_amount": controller.text,
        "order_type":"RECURRING_ORDER",
        "recurring_date":selectedDateController.text,
        "recurring_frequency": selectedOption==1?"market-day":selectedOption==2?"weekly":selectedOption==3?"bi-weekly":"monthly",
      };

      ApiResponse response =
      await manager.requestBuyShare(request, showProgress: true);
      Utils().showLog('~~~~~${response.status}~~~~');
      if (response.status) {
        context.read<SOpenManager>().getData();
        num? numPrice = response.data['result']['executed_at'];
        final order = SummaryOrderNew(
          image: detailRes?.image,
          name: detailRes?.name,
          currentPrice: numPrice,
          symbol: detailRes?.symbol,
          invested: invested,
          date: response.data['result']['created_date'],
          selectedOption: selectedOption,
          investedPrice:  controller.text.isNotEmpty?num.parse(controller.text):0,
          targetPrice: 0,
          stopPrice:0,
          limitPrice:0,
        );

        Navigator.popUntil(navigatorKey.currentContext!, (route) => route.isFirst);
        Navigator.pushNamed(navigatorKey.currentContext!, SimulatorIndex.path,arguments: {"initialIndex":3});

        _clear();

        await showCOrderSuccessSheet(order, ConditionType.recurringOrder);
      } else {
        popUpAlert(
          message: "${response.message}",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      }
    }
  }

  _clear() {
    Timer(const Duration(milliseconds: 50), () {
      controller.clear();
      setState(() {
        _currentText = "0";
        _lastEntered = '';
        _keyCounter = 0;
      });
    });
  }

  _onChange(String text) {
    try {
      setState(() {
        if (text.length < _previousText.length) {
          _lastEntered = "";
          _currentText = text;
          _keyCounter++;
          if (text == '') {
            _currentText = '0';
          }
        } else {
          if (text == "." || text == "0.") {
            _currentText = "0.";
            controller.text = "0.";
          } else {
            _lastEntered = text.substring(text.length - 1);
            _currentText = text;
            _keyCounter++;
          }
        }
        _previousText = text;
      });
    } catch (e) {
      Utils().showLog('error $e');
    }
  }

  Widget _newMethod() {
    TradeManager manager = context.read<TradeManager>();
    BaseTickerRes? detailRes = manager.detailRes;
    PortfolioManager portfolioManager = context.read<PortfolioManager>();

    num parsedCurrentText = num.tryParse(_currentText) ?? 0;
    num invested = (detailRes?.price ?? 0) * parsedCurrentText;
    return Container(
      padding: const EdgeInsets.all(Pad.pad3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonCard(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Balance',
                        style: stylePTSansRegular(
                          fontSize: 12,
                          color: ThemeColors.neutral80,
                        ),
                      ),
                      SpacerVertical(height:  Pad.pad10),
                      Text(
                        portfolioManager.userData?.userDataRes?.tradeBalance != null
                            ? "\$${formatBalance(num.parse(portfolioManager.userData!.userDataRes!.tradeBalance.toCurrency()))}"
                            : '\$0',
                        style: stylePTSansBold(
                            fontSize: 16,
                            color: ThemeColors.splashBG
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpacerHorizontal(width: Pad.pad10),
              Expanded(
                child:
                CommonCard(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Order Value',
                        style: stylePTSansRegular(
                          fontSize: 12,
                          color: ThemeColors.neutral80,
                        ),
                      ),
                      SpacerVertical(height:  Pad.pad10),
                      Text(
                        "\$${invested.toCurrency()}",
                        style: stylePTSansBold(
                            fontSize: 16,
                            color: ThemeColors.splashBG
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SpacerVertical(),
          BaseButton(
            disabledBackgroundColor: ThemeColors.neutral5,
            disableTextColor: ThemeColors.black,
            textColor: ThemeColors.splashBG,
            text: widget.editTradeID != null
                ? 'Update Recurring Order'
                : "Proceed Recurring Order",
            color: (invested > _availableBalance || invested == 0)
                ? ThemeColors.neutral5
                : ThemeColors.primary100,
            onPressed:
                (invested > _availableBalance || invested == 0) ? null : (){
                  if (controller.text.isEmpty || num.parse(controller.text) == 0.0) {
                    popUpAlert(
                      message: "Recurring Investment Amount can't be empty",
                      title: "Alert",
                      icon: Images.alertPopGIF,
                    );
                    return;
                  }
                  else if (selectedOption==null) {
                    popUpAlert(
                      message: "Choose frequency",
                      title: "Alert",
                      icon: Images.alertPopGIF,
                    );
                    return;
                  }
                  else{
                    _onTap();
                  }
                },
          ),

          Visibility(
            visible: controller.text.isNotEmpty && (invested > _availableBalance),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Your current balance is ',
                  style: stylePTSansRegular(color: ThemeColors.neutral40),
                  children: [
                    TextSpan(
                      text: _availableBalance.toFormattedPrice(),
                      style: stylePTSansBold(
                          color: ThemeColors.splashBG, fontSize: 14),
                    ),
                    TextSpan(
                        style: stylePTSansRegular(color: ThemeColors.neutral40),

                        text:
                            '. You cannot purchase shares with an order value that exceeds your available balance.')
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Future onTap({ConditionType? cType, StockType? selectedStock}) async {
    openInfoSheet(cType,selectedStock);
  }


  @override
  Widget build(BuildContext context) {
    if (selectedDate == null) return SizedBox();
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    String weekday = DateFormat('EEEE').format(selectedDate!);
    int dayOfMonth = selectedDate!.day;
    selectedDateController.text=formattedDate;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const STopWidget(),
                  const SpacerVertical(height: 5),
                  GestureDetector(
                    onTap: (){
                      onTap(cType: ConditionType.recurringOrder,selectedStock: StockType.buy);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "RECURRING ORDER",
                          style: stylePTSansBold(
                            color: ThemeColors.splashBG,
                            fontSize: 12,
                          ),
                        ),
                        SpacerHorizontal(width: 5),
                        Icon(Icons.info_sharp,color: ThemeColors.splashBG,size: 18)
                      ],
                    ),
                  ),
                  const SpacerVertical(height: 10),
                  Container(
                    width: 110,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient:  LinearGradient(
                          colors: [
                            ThemeColors.neutral40,
                            ThemeColors.splashBG,
                          ],

                        )
                    ),
                    child: Center(
                      child: Text(
                        "Buy",
                        style:styleGeorgiaBold(
                            fontSize: 15,
                            color: ThemeColors.white
                        ),
                      ),
                    ),
                  ),

                  Visibility(child: const SpacerVertical(height: Pad.pad10)),
                  Text(
                    'Enter Recurring Investment Amount',
                    style: styleGeorgiaRegular(color: ThemeColors.neutral80,fontSize: 18),
                  ),
                  TextfieldTrade(
                    controller: controller,
                    focusNode: focusNode,
                    text: _currentText.substring(
                      0,
                      _currentText.length - _lastEntered.length,
                    ),
                    change: _onChange,
                    counter: _keyCounter,
                    lastEntered: _lastEntered,
                    readOnly: (widget.tickerID == null ? false : true),
                  ),
                  SpacerVertical(),
                  ScreenTitle(
                    title: "Choose Recurring Investment Date",
                    style: stylePTSansBold(color: ThemeColors.splashBG),
                    dividerPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                  GestureDetector(
                    onTap: selectDate,
                    child: ThemeInputField(
                      cursorColor:ThemeColors.neutral6,
                      fillColor: ThemeColors.neutral5,
                      borderColor: ThemeColors.neutral5,
                      controller: selectedDateController,
                      placeholder: "mm-dd-yyyy",
                      keyboardType:
                      TextInputType.numberWithOptions(decimal: true),
                      style: stylePTSansRegular(color: ThemeColors.splashBG),
                      editable: false,
                    ),
                  ),
                  RadioListTile<int>(
                    title: Text("Every Market Day (Monday to Friday)",style:stylePTSansRegular(color:ThemeColors.splashBG,fontSize: 14)),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    activeColor: ThemeColors.splashBG,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<int>(
                    title: Text("Every Week (on $weekday)",style:stylePTSansRegular(color: ThemeColors.splashBG,fontSize: 14)),
                    value: 2,
                    groupValue:selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    activeColor:ThemeColors.splashBG,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<int>(
                    title: Text("Every Two Weeks (on $weekday)",style:stylePTSansRegular(color: ThemeColors.splashBG,fontSize: 14)),
                    value: 3,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                    activeColor: ThemeColors.splashBG,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<int>(
                    title: Text("Every Month (on the $dayOfMonth)",style:stylePTSansRegular(color: ThemeColors.splashBG,fontSize: 14)),
                    value: 4,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value;
                        selectedOption = value;
                      });
                    },
                    activeColor:ThemeColors.splashBG,
                    contentPadding: EdgeInsets.zero,
                  ),


                ],
              ),
            ),
          ),
          _newMethod(),
        ],
      ),
    );
  }
}
