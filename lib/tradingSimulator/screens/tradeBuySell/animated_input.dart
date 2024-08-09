import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/text_field.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class AnimatedInput extends StatefulWidget {
  final TextEditingController controller;

  const AnimatedInput({super.key, required this.controller});

  @override
  State<AnimatedInput> createState() => _AnimatedInputState();
}

class _AnimatedInputState extends State<AnimatedInput> {
  // TextEditingController controller = TextEditingController(text: "0");
  FocusNode focusNode = FocusNode();
  // String _currentText = "0";
  String _lastEntered = "";
  String _previousText = "";

  int _keyCounter = 0;

  // String text = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    widget.controller.clear();
    super.dispose();
  }

  _clear() {
    Timer(const Duration(milliseconds: 50), () {
      widget.controller.clear();
      setState(() {
        // _currentText = "0";
        _lastEntered = '';
        _keyCounter = 0;
      });
    });
  }

  _onChange(String text) {
    setState(() {
      if (text.length < _previousText.length) {
        widget.controller.text =
            text.startsWith("0") ? num.parse(text).toString() : text;
        if (text == '') {
          widget.controller.text = '0';
        }
      } else {
        // widget.controller.text =
        //     text.startsWith("0") ? num.parse(text).toString() : text;
        if (text == "." || text == "0.") {
          widget.controller.text =
              text.startsWith("0") ? num.parse(text).toString() : text;
          Utils().showLog("IF");
          // _currentText = "0.";
          // controller.text = "0.";
          // widget.controller.text = "0.";
        } else {
          Utils().showLog("ELSE");
          // Adding new characters
          if (text.isEmpty) {
            // _lastEntered = text.substring(text.length - 1);
            widget.controller.text = "0";
          } else {
            _lastEntered = text.substring(text.length - 1);
          }
          // _currentText = text;
          // widget.controller.text = text;
          _keyCounter++;
        }
      }
    });

    // setState(() {
    //   if (text.length < _previousText.length) {
    //     // Clearing text
    //     _lastEntered = "";
    //     // _currentText = text;
    //     _keyCounter++;
    //     if (text == '') {
    //       // _currentText = '0';
    //       widget.controller.text = '0';
    //     }
    //   } else {
    //     if (text.startsWith("0")) {
    //       widget.controller.text = text;
    //     }
    //     if (text == "." || text == "0.") {
    //       Utils().showLog("IF");
    //       // _currentText = "0.";
    //       // controller.text = "0.";
    //       // widget.controller.text = "0.";
    //     } else {
    //       Utils().showLog("ELSE");

    //       // Adding new characters
    //       _lastEntered = text.substring(text.length - 1);
    //       // _currentText = text;
    //       // widget.controller.text = text;
    //       _keyCounter++;
    //     }
    //   }
    //   _previousText = text;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return TextfieldTrade(
      controller: widget.controller,
      focusNode: focusNode,
      text: widget.controller.text.substring(
        0,
        widget.controller.text.length - _lastEntered.length,
      ),
      change: _onChange,
      counter: _keyCounter,
      lastEntered: _lastEntered,
    );
  }
}
