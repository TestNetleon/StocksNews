import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/prediction/Widget/heading.dart';

class PreditionHeader extends StatefulWidget {
  const PreditionHeader({super.key});

  @override
  State<PreditionHeader> createState() => _PreditionHeaderState();
}

class _PreditionHeaderState extends State<PreditionHeader> {
  @override
  Widget build(BuildContext context) {
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Row(
    //       children: [
    //         Container(
    //           height: 50,
    //           width: 50,
    //           decoration: const BoxDecoration(
    //               shape: BoxShape.circle, color: Colors.white),
    //           child: Image.asset(Images.microsoft),
    //         ),
    //         const SizedBox(width: 10.0),
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text('MSFT', style: stylePTSansBold()),
    //             const SpacerVertical(
    //               height: 5.0,
    //             ),
    //             Text('20,049594',
    //                 style: stylePTSansBold(fontSize: 12, color: Colors.green)),
    //             const SpacerVertical(
    //               height: 5.0,
    //             ),
    //             Text('747657489',
    //                 style: stylePTSansBold(fontSize: 12, color: Colors.white)),
    //           ],
    //         ),
    //       ],
    //     ),
    //     Container(
    //       width: 120,
    //       height: 70,
    //       decoration: BoxDecoration(
    //           shape: BoxShape.rectangle,
    //           borderRadius: BorderRadius.circular(8.0),
    //           gradient: const LinearGradient(
    //               begin: Alignment.topCenter,
    //               end: Alignment.bottomCenter,
    //               stops: [0.0, 0.3],
    //               colors: [Color.fromARGB(255, 32, 240, 139), Colors.green])
    //           // color: Colors.white
    //           ),
    //       padding: const EdgeInsets.all(10.0),
    //       child: Center(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text('Overall',
    //                 style: stylePTSansBold(
    //                   fontSize: 16,
    //                 )),
    //             Text('Wait', style: stylePTSansBold(fontSize: 20)),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // );

    return SdPortfolioHeading();
  }
}
