import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../stockDetail/widgets/common_heading.dart';
import 'listing.dart';

class PaperTradeIndex extends StatelessWidget {
  final bool buy;
  const PaperTradeIndex({
    super.key,
    this.buy = true,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true),
      body: SdTypeBuySell(buy: buy),
    );
  }
}

enum TypeTrade { shares, dollar }

class SdTypeBuySell extends StatefulWidget {
  final bool buy;

  const SdTypeBuySell({
    super.key,
    this.buy = true,
  });

  @override
  State<SdTypeBuySell> createState() => _SdTypeBuySellState();
}

class _SdTypeBuySellState extends State<SdTypeBuySell> {
  TypeTrade _selectedSegment = TypeTrade.shares;
  final TextInputFormatter _formatter = FilteringTextInputFormatter.digitsOnly;
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.clear();
    super.dispose();
  }

  _onTap() {
    closeKeyboard();
    if (_controller.text.isEmpty) {
      popUpAlert(
        message: "Value can't be empty",
        title: "Alert",
        icon: Images.alertPopGIF,
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaperTradeListing(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimen.padding, Dimen.padding, Dimen.padding, 0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SdCommonHeading(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CupertinoSlidingSegmentedControl<TypeTrade>(
                      backgroundColor: ThemeColors.greyBorder.withOpacity(0.4),
                      thumbColor: ThemeColors.accent,
                      groupValue: _selectedSegment,
                      onValueChanged: (TypeTrade? value) {
                        if (value != null) {
                          setState(() {
                            _selectedSegment = value;
                          });
                        }
                      },
                      children: <TypeTrade, Widget>{
                        TypeTrade.shares: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            widget.buy ? 'Buy in shares' : 'Sell in shares',
                            style: styleGeorgiaBold(),
                          ),
                        ),
                        TypeTrade.dollar: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            widget.buy ? 'Buy in dollars' : 'Sell in dollars',
                            style: styleGeorgiaBold(),
                          ),
                        ),
                      },
                    ),
                  ),
                  const SpacerVertical(),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _controller,
                      cursorColor: ThemeColors.greyBorder,
                      style: stylePTSansBold(fontSize: 30),
                      inputFormatters: [_formatter],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Value",
                        hintStyle: stylePTSansRegular(
                            fontSize: 30, color: ThemeColors.greyText),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ThemeColors.accent),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ThemeColors.greyBorder),
                        ),
                      ),
                    ),
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

  Widget _newMethod() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: ThemeColors.greyBorder),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    text: "Balance: ",
                    style: stylePTSansBold(fontSize: 14),
                    children: [
                      TextSpan(
                        text: "\$2005.34",
                        style: stylePTSansRegular(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: RichText(
                  text: TextSpan(
                      text: "Order Value: ",
                      style: stylePTSansBold(fontSize: 14),
                      children: [
                        TextSpan(
                          text: "\$0.00",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                      ]),
                ),
              ),
            ],
          ),
          const SpacerVertical(),
          ThemeButton(
            text: widget.buy ? "Proceed Buy Order" : "Proceed Sell Order",
            onPressed: _onTap,
          ),
        ],
      ),
    );
  }
}
