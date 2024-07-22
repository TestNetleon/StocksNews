import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class PreditionHeader extends StatefulWidget {
  const PreditionHeader({super.key});

  @override
  State<PreditionHeader> createState() => _PreditionHeaderState();
}

class _PreditionHeaderState extends State<PreditionHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Image.asset(Images.microsoft),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Microsoft Pvt.Ltd', style: stylePTSansBold()),
                Text('Val - 20,049594',
                    style: stylePTSansBold(fontSize: 12, color: Colors.green)),
                Text('BDL - 747657489',
                    style: stylePTSansBold(fontSize: 12, color: Colors.red)),
              ],
            ),
          ],
        ),
        Container(
          width: 90,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3],
                  colors: [Colors.greenAccent, Colors.green])
              // color: Colors.white
              ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text('Overall',
                  style: stylePTSansBold(
                    fontSize: 12,
                  )),
              Text('Wait', style: stylePTSansBold()),
            ],
          ),
        ),
      ],
    );
  }
}
