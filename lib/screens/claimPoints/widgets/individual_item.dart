import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/missions/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import '../../../modals/missions/missions.dart';
import '../../../utils/constants.dart';

class ClaimPointsIndividual extends StatelessWidget {
  final ClaimPointsRes? data;

  const ClaimPointsIndividual({
    super.key,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (data?.points ?? 0) / (data?.targetPoints ?? 1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 28, 28, 28)),
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.5],
          colors: [
            Color.fromARGB(255, 22, 22, 22),
            Color.fromARGB(255, 0, 0, 0),
          ],
        ),
      ),
      child: Row(
        children: [
          // CircleAvatar(
          //   radius: 25,
          //   backgroundColor: const Color.fromARGB(255, 36, 36, 36),
          // ),
          // SpacerHorizontal(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "${data?.title}",
                        style: styleGeorgiaBold(fontSize: 20),
                      ),
                    ),
                    SpacerHorizontal(width: 10),
                    Visibility(
                      visible: data?.status == true,
                      child: GestureDetector(
                        // onTap: () {
                        //   if (data?.type == null || data?.type == '') {
                        //     return;
                        //   }
                        //   context.read<MissionProvider>().claimPoints(
                        //         type: data?.type ?? "",
                        //         points: data?.claimPoints,
                        //       );
                        // },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: const [
                                ThemeColors.tabBack,
                                ThemeColors.blackShade,
                                ThemeColors.tabBack,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                Images.pointIcon2,
                                width: 14,
                              ),
                              const SpacerHorizontal(width: 8),
                              Text(
                                "${data?.claimPoints}",
                                style: stylePTSansRegular(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SpacerVertical(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(
                      visible:
                          data?.points != null && data?.targetPoints != null,
                      child: Flexible(
                        child:

                            // ProgressBar(
                            //   current: data?.limit ?? 0,
                            //   total: data?.totalLimit ?? 1,
                            // ),
                            //     SegmentedProgressBar(
                            //   current: data?.limit ?? 0,
                            //   total: data?.totalLimit ?? 1,
                            // ),

                            Container(
                          margin: EdgeInsets.only(right: 10),
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(5),
                            value: percentage,
                            backgroundColor:
                                const Color.fromARGB(255, 19, 19, 19),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                percentage >= 0 && percentage <= 0.33
                                    ? Colors.red
                                    : percentage > 0.33 && percentage <= 0.66
                                        ? Colors.orange
                                        : Colors.green),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          data?.points != null && data?.targetPoints != null,
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          "${data?.points ?? 0}/${data?.targetPoints ?? 1}",
                          style: styleGeorgiaBold(fontSize: 14),
                        ),
                      ),
                    ),
                    // Visibility(
                    //   visible: data?.status == true,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       if (data?.type == null || data?.type == '') {
                    //         return;
                    //       }
                    //       context.read<MissionProvider>().claimPoints(
                    //             type: data?.type ?? "",
                    //             points: data?.claimPoints,
                    //           );
                    //     },
                    //     child: Container(
                    //       padding:
                    //           EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(30),
                    //         gradient: LinearGradient(
                    //           begin: Alignment.topCenter,
                    //           end: Alignment.bottomCenter,
                    //           colors: const [
                    //             ThemeColors.tabBack,
                    //             ThemeColors.blackShade,
                    //             ThemeColors.tabBack,
                    //           ],
                    //         ),
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Image.asset(
                    //             Images.pointIcon2,
                    //             width: 14,
                    //           ),
                    //           const SpacerHorizontal(width: 8),
                    //           Text(
                    //             "${data?.claimPoints}",
                    //             style: stylePTSansRegular(
                    //               fontSize: 14,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: data?.status == true,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ThemeButtonSmall(
                onPressed: () {
                  if (data?.type == null || data?.type == '') {
                    return;
                  }
                  context.read<MissionProvider>().claimPoints(
                        type: data?.type ?? "",
                        points: data?.claimPoints,
                      );
                },
                text: 'Claim',
                showArrow: false,
                radius: 30,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                textColor: ThemeColors.background,
                fontBold: true,
                color: const Color.fromARGB(255, 194, 216, 51),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
