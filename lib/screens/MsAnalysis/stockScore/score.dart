import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import 'item.dart';

class MsStockScore extends StatelessWidget {
  const MsStockScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimen.padding),
      child: MsStockScoreItem(),
    );
  }
}
