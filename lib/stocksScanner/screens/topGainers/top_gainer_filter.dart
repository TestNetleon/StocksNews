import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/theme.dart';

class ScannerTopGainerFilter extends StatelessWidget {
  const ScannerTopGainerFilter({
    super.key,
    this.isPercent,
    this.isVolume,
    required this.onPercentClick,
    required this.onVolumnClick,
  });

  final bool? isPercent, isVolume;
  final Function onPercentClick, onVolumnClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 21, 21, 21),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => {},
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isPercent == true
                      ? const Color.fromARGB(255, 0, 82, 4)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Percent Change",
                  style: styleGeorgiaBold(fontSize: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => {},
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isVolume == true
                      ? const Color.fromARGB(255, 0, 82, 4)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Volume",
                  style: styleGeorgiaBold(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
