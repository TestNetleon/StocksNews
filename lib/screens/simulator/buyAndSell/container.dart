import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:stocks_news_new/screens/simulator/buyAndSell/textfield.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../stockDetail/widgets/common_heading.dart';
import 'proceed_button.dart';

class BuyAndSellContainer extends StatefulWidget {
  const BuyAndSellContainer({super.key});

  @override
  State<BuyAndSellContainer> createState() => _BuyAndSellContainerState();
}

class _BuyAndSellContainerState extends State<BuyAndSellContainer> {
  TypeTrade _selectedSegment = TypeTrade.shares;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _currentText = "0";
  String _lastEntered = "";
  int _keyCounter = 0;
  String _previousText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    controller.clear();
    super.dispose();
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
    setState(() {
      if (text.length < _previousText.length) {
        // Clearing text
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
          // Adding new characters
          _lastEntered = text.substring(text.length - 1);
          _currentText = text;
          _keyCounter++;
        }
      }
      _previousText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SdCommonHeading(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CupertinoSlidingSegmentedControl<TypeTrade>(
                    backgroundColor: ThemeColors.greyBorder.withOpacity(0.4),
                    // thumbColor: widget.buy ? ThemeColors.accent : ThemeColors.sos,
                    thumbColor: ThemeColors.accent,

                    groupValue: _selectedSegment,
                    onValueChanged: (TypeTrade? value) {
                      if (value != null) {
                        setState(() {
                          _selectedSegment = value;
                        });
                        _clear();
                      }
                    },
                    children: <TypeTrade, Widget>{
                      TypeTrade.shares: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Buy in Shares',
                          style: styleGeorgiaBold(),
                        ),
                      ),
                      TypeTrade.dollar: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Buy in Dollars',
                          style: styleGeorgiaBold(),
                        ),
                      ),
                    },
                  ),
                ),
                const SpacerVertical(),
                SimulatorTextField(
                  controller: controller,
                  focusNode: focusNode,
                  text: _currentText.substring(
                      0, _currentText.length - _lastEntered.length),
                  change: (value) {
                    _onChange(value);
                  },
                  counter: _keyCounter,
                  lastEntered: _lastEntered,
                ),
              ],
            ),
          ),
        ),
        BuyAndSellProceedButton(
          selectedType: _selectedSegment,
          currentText: _currentText,
          onTap: () {},
        ),
      ],
    );
  }
}
