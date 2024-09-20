import 'package:flutter/material.dart';
import '../../../../../utils/theme.dart';

class MsFundamentalHeader extends StatelessWidget {
  final List<String>? header;
  const MsFundamentalHeader({super.key, this.header});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: List.generate(
          header?.length ?? 0,
          (index) {
            return MsFundamentalHeaderItem(
              title: header?[index] ?? '',
            );
          },
        ),
      ),
      // child: Row(
      //   children: [
      //     Flexible(
      //       child: MsFundamentalHeaderItem(
      //         title: "${provider.completeData?.cap ?? 0}",
      //       ),
      //     ),
      //     SpacerHorizontal(width: 8),
      //     Flexible(
      //       child: MsFundamentalHeaderItem(
      //         title: "${provider.completeData?.sector ?? 0}",
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class MsFundamentalHeaderItem extends StatelessWidget {
  final String title;
  const MsFundamentalHeaderItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color.fromARGB(255, 10, 10, 10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text(
        title,
        style: stylePTSansRegular(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }
}
