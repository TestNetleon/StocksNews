import 'package:flutter/material.dart';

import '../../../../../utils/theme.dart';
import '../../../../../widgets/custom_gridview.dart';
import '../../../../../widgets/spacer_vertical.dart';

class MsFundamentalFooter extends StatefulWidget {
  const MsFundamentalFooter({super.key});

  @override
  State<MsFundamentalFooter> createState() => _MsFundamentalFooterState();
}

class _MsFundamentalFooterState extends State<MsFundamentalFooter> {
  List<Map<String, dynamic>> fundamental = [
    {
      "title": "P/E Ratio",
      "amount": "-",
    },
    {
      "title": "Sector P/E",
      "amount": "119.07",
    },
    {"title": "Dividend yield", "amount": "0.6%"},
    {"title": "Market Cap", "amount": "\$40Cr"},
  ];
  @override
  Widget build(BuildContext context) {
    return CustomGridView(
      length: 4,
      paddingVertical: 10,
      paddingHorizontal: 12,
      getChild: (index) {
        return MsFundamentalFooterItem(
          data: fundamental[index],
        );
      },
    );
  }
}

class MsFundamentalFooterItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const MsFundamentalFooterItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 27, 27, 27),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'].toString(),
            style: stylePTSansRegular(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          const SpacerVertical(height: 8.0),
          Text(
            data['amount'].toString(),
            style: stylePTSansRegular(
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
