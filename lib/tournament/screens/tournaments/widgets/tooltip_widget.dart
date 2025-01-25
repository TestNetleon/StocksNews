import 'package:flutter/material.dart';

class TooltipWidget extends StatelessWidget {
  final String? values;
  final GlobalKey<TooltipState>? tooltipKey;
  const TooltipWidget({super.key, this.values, this.tooltipKey});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Tooltip(
        key: tooltipKey,
        triggerMode: TooltipTriggerMode.tap,
        showDuration: const Duration(seconds: 1),
        message: values??"",
      ),
    );
  }
}
