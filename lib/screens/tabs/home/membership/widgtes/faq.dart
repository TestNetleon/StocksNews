import 'package:flutter/material.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NewMembershipFaq extends StatelessWidget {
  const NewMembershipFaq({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: Color(0xFF7a9295)
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.65],
          colors: [
            Color.fromARGB(255, 27, 85, 68),
            Color.fromARGB(255, 39, 37, 37),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FAQ',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            const SpacerVertical(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(4, (index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black.withOpacity(.2)),
                        borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.all(2.0),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: const Text(
                          'Subscriber Information',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                        // collapsedBackgroundColor: Colors.green.withOpacity(0.20),
                        // backgroundColor: Colors.green.withOpacity(0.10),
                        onExpansionChanged: (bool change) {},
                        childrenPadding: const EdgeInsets.all(10),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        expandedAlignment: Alignment.topLeft,
                        children: const [
                          Text('* Ticket Id1'),
                          Text('* Ticket Id2'),
                          Text('* Ticket Id3'),
                          Text('* Ticket Id 4'),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
