import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stocks_news_new/utils/colors.dart';

class TextfieldTrade extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? text;
  final String lastEntered;
  final int counter;
  final void Function(String) change;

  const TextfieldTrade({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.change,
    this.text,
    required this.lastEntered,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        TextFormField(
          focusNode: focusNode,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(7),
            SingleDotInputFormatter(),
            // FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: controller,
          onChanged: (text) {
            change(text);
          },
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: ThemeColors.transparent),
            ),
          ),
          style: const TextStyle(fontSize: 80, color: Colors.transparent),
          cursorColor: Colors.transparent,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                focusNode.requestFocus();
              },
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ThemeColors.accent),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        text ?? "0",
                        style:
                            const TextStyle(fontSize: 80, color: Colors.white),
                      ),
                      ClipRect(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            final slideIn = Tween<Offset>(
                              begin: const Offset(0.0, 1.0),
                              end: const Offset(0.0, 0.0),
                            ).animate(animation);

                            final slideOut = Tween<Offset>(
                              begin: const Offset(60.0, 60.0),
                              end: const Offset(0.0, -1.0),
                            ).animate(animation);

                            if (child.key ==
                                ValueKey<String>('$lastEntered$counter')) {
                              return SlideTransition(
                                position: slideIn,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            } else {
                              return SlideTransition(
                                position: slideOut,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            }
                          },
                          child: Text(
                            lastEntered,
                            key: ValueKey<String>('$lastEntered$counter'),
                            style: const TextStyle(
                                fontSize: 80, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom input formatter to allow only one dot
class SingleDotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains('.')) {
      if (newValue.text.indexOf('.') != newValue.text.lastIndexOf('.')) {
        return oldValue;
      }
    }
    return newValue;
  }
}
