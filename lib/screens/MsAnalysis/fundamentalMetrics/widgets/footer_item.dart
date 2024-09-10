import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';

class MsMetricsFooterItem extends StatelessWidget {
  final int index;
  const MsMetricsFooterItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 19, 201, 25),
              offset: Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 30,
        ),
        margin: const EdgeInsets.all(8.0),
        child: Text(
          index == 0
              ? "Net Profit"
              : index == 1
                  ? "Revenue"
                  : "Debits",
          maxLines: 2,
          style: stylePTSansBold(color: Colors.black),
        ),
      ),
    );
  }
}
