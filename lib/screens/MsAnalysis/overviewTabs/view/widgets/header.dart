import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';

import '../../../widget/bottom_sheet.dart';

class MsOverviewHeader extends StatelessWidget {
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final String label;
  final MsProviderKeys stateKey;

  const MsOverviewHeader({
    super.key,
    this.leadingIcon,
    required this.label,
    this.trailingIcon = Icons.info,
    required this.stateKey,
  });

  @override
  Widget build(BuildContext context) {
    final MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    final bool isOpen = provider.getState(stateKey);

    return GestureDetector(
      onTap: () {
        provider.toggleState(stateKey);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Visibility(
                  visible: leadingIcon != null,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      leadingIcon,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    msShowBottomSheet();
                  },
                  child: Visibility(
                    visible: trailingIcon != null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        trailingIcon,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Icon(
              isOpen
                  ? Icons.keyboard_arrow_up_sharp
                  : Icons.keyboard_arrow_down_sharp,
              color: Colors.orange,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
