import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/msAnalysis/complete.dart';
import '../../../../../utils/theme.dart';
import '../../../../../widgets/custom_gridview.dart';
import '../../../../../widgets/spacer_vertical.dart';

class MsFundamentalFooter extends StatelessWidget {
  final List<MsFundamentalsResBody>? body;
  const MsFundamentalFooter({super.key, this.body});

  @override
  Widget build(BuildContext context) {
    return CustomGridView(
      length: 4,
      paddingVertical: 10,
      paddingHorizontal: 12,
      getChild: (index) {
        return MsFundamentalFooterItem(
          data: body?[index],
        );
      },
    );
  }
}

class MsFundamentalFooterItem extends StatelessWidget {
  final MsFundamentalsResBody? data;
  const MsFundamentalFooterItem({super.key, this.data});

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
            data?.label ?? "",
            style: stylePTSansRegular(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SpacerVertical(height: 8.0),
          Text(
            "${data?.value ?? 0}",
            style: stylePTSansRegular(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
