import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/ticker_search.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

// MARK: Search Box
class BaseSearchSimulator extends StatefulWidget {
  final Function(String) onSearchChanged;

  const BaseSearchSimulator({super.key, required this.onSearchChanged});

  @override
  State<BaseSearchSimulator> createState() => _BaseSearchFieldState();
}

class _BaseSearchFieldState extends State<BaseSearchSimulator> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 250), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TickerSearchManager manager = context.watch<TickerSearchManager>();
    return Container(
      margin: EdgeInsets.only(left: 40, right: Pad.pad16),
      child: BaseTextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (text) {
          if (_timer != null) {
            _timer!.cancel();
          }
          _timer = Timer(
            const Duration(milliseconds: 1000),
            () {
              widget.onSearchChanged(text);
            },
          );
        },
        contentPadding: EdgeInsets.symmetric(
          vertical: Pad.pad10,
          horizontal: Pad.pad16,
        ),
        maxLines: 1,
        prefixIcon: Container(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            Images.search,
            color: ThemeColors.black,
          ),
        ),
        suffixIcon: manager.isLoadingSearch
            ? Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: ThemeColors.secondary120,
                ),
              )
            : _controller.text.isNotEmpty
                ? InkWell(
                    onTap: () {
                      setState(() {
                        _controller.clear();
                        _controller.text = "";
                        widget.onSearchChanged("");
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(Pad.pad10),
                      decoration: BoxDecoration(
                        color: ThemeColors.neutral5,
                        borderRadius: BorderRadius.circular(Pad.pad8),
                      ),
                      child: Icon(Icons.clear,
                          color: ThemeColors.neutral60, size: 18),
                    ),
                  )
                : null,
      ),
    );
  }
}
