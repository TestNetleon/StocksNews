import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/my_evaluvated_button.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg.dart';

class NewMembershipUpgradeCurrentPlan extends StatefulWidget {
  const NewMembershipUpgradeCurrentPlan({super.key});

  @override
  State<NewMembershipUpgradeCurrentPlan> createState() =>
      _NewMembershipUpgradeCurrentPlanState();
}

class _NewMembershipUpgradeCurrentPlanState
    extends State<NewMembershipUpgradeCurrentPlan> {
  List<bool> isSelectedList = List.generate(3, (_) => true);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upgrade Plan',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        const SpacerVertical(
          height: 10,
        ),
        Column(
          children: List.generate(3, (index) {
            return Column(
              children: [
                Container(
                    // height: 180,
                    width: MediaQuery.of(context).size.width / 1.10,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.2, 0.65],
                          colors: [
                            Color.fromARGB(255, 32, 128, 65),
                            Color.fromARGB(255, 39, 37, 37),
                          ],
                        ),
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 60,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0))),
                              padding: const EdgeInsets.all(8.0),
                              child: const Center(
                                child: Text(
                                  'Plus',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            const Text(
                              '₹ 2000 / Mo',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          ],
                        ),
                        const SpacerVertical(
                          height: 10,
                        ),
                        const Text(
                          'Discovering free trading and investing, with more charts & intervals and indicatores ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                        ),
                        const SpacerVertical(
                          height: 10,
                        ),
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'All The benefits of ',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
                              ),
                              TextSpan(
                                text: 'Essentials',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              TextSpan(
                                text: ' and more!',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SpacerVertical(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              'See Benefits',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            const SpacerHorizontal(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSelectedList[index] =
                                      !isSelectedList[index];
                                });
                              },
                              child: SvgPicture.asset(
                                Images.arrow,
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SpacerVertical(
                          height: 10,
                        ),
                        Visibility(
                            visible: isSelectedList[index],
                            child: const Column(
                              children: [
                                Text(
                                  '* Ticket Id1',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SpacerVertical(
                                  height: 5,
                                ),
                                Text(
                                  '* Ticket Id1',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SpacerVertical(
                                  height: 5,
                                ),
                                Text(
                                  '* Ticket Id1',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SpacerVertical(
                                  height: 5,
                                ),
                                Text(
                                  '* Ticket Id1',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ))
                      ],
                    )),
                const SpacerVertical(
                  height: 10,
                )
              ],
            );
          }),
        ),
        MyElevatedButton(
          width: MediaQuery.of(context).size.width / 1.10,
          onPressed: () {},
          gradient: LinearGradient(
              colors: [Colors.green.shade300, Colors.black.withOpacity(.8)]),
          borderRadius: BorderRadius.circular(10),
          child: const Text('Upgrade Now'),
        )
      ],
    );
  }
}
