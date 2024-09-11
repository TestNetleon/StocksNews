import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

import '../../../widget/bottom_sheet.dart';

class MsOverviewHeader extends StatefulWidget {
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Function(bool) onTap;
  final String label;
  const MsOverviewHeader({
    super.key,
    this.leadingIcon,
    required this.label,
    this.trailingIcon = Icons.info,
    required this.onTap,
  });

  @override
  State<MsOverviewHeader> createState() => _MsOverviewHeaderState();
}

class _MsOverviewHeaderState extends State<MsOverviewHeader> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        open = !open;
        setState(() {});
        widget.onTap(open);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Visibility(
                  visible: widget.leadingIcon != null,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      widget.leadingIcon,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
                Text(
                  widget.label,
                  style: stylePTSansRegular(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    msShowBottomSheet();
                  },
                  child: Visibility(
                    visible: widget.trailingIcon != null,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        widget.trailingIcon,
                        color: ThemeColors.greyBorder,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Icon(
              open
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
