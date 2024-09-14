import 'package:flutter/material.dart';

import '../../../../../utils/theme.dart';

class MsFundamentalHeader extends StatelessWidget {
  const MsFundamentalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: List.generate(
          7,
          (index) {
            return MsFundamentalHeaderItem();
          },
        ),
      ),
    );
  }
}

class MsFundamentalHeaderItem extends StatelessWidget {
  const MsFundamentalHeaderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color.fromARGB(255, 10, 10, 10),
      ),
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Small-Cap',
        style: stylePTSansRegular(
          fontSize: 12.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
