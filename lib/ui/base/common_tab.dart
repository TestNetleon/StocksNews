import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/optional_parent.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import 'base_list_divider.dart';

class BaseTabs extends StatefulWidget {
  const BaseTabs({
    super.key,
    required this.data,
    required this.onTap,
    this.isScrollable = true,
    this.showDivider = true,
    this.rightChild,
    this.leftChild,
    this.child,
    this.unselectedBold = true,
    this.labelPadding,
    this.selectedIndex = 0,
    this.fontSize,
  });

  final Widget? child;
  final Widget? rightChild;
  final Widget? leftChild;
  final bool isScrollable;
  final List<dynamic> data;
  final Function(int index) onTap;
  final bool showDivider;
  final bool unselectedBold;
  final EdgeInsetsGeometry? labelPadding;
  final int selectedIndex;
  final double? fontSize;

  @override
  State<BaseTabs> createState() => _CommonTabsState();
}

class _CommonTabsState extends State<BaseTabs>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.data.length,
      vsync: this,
      initialIndex: widget.selectedIndex,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (widget.leftChild != null) widget.leftChild!,
            Expanded(
              child: TabBar(
                controller: _tabController,
                isScrollable: widget.isScrollable,
                labelPadding: widget.labelPadding,

                tabs: (widget.data.map((e) {
                  int index = widget.data.indexOf(e);
                  bool isSelected = index == _tabController?.index;
                  return TabItem(
                    label: e.title,
                    textStyle: isSelected
                        // ? styleBaseSemiBold(fontSize: widget.fontSize ?? 16)
                        ? styleBaseBold(
                            fontSize: widget.fontSize ?? 16,
                            color: ThemeColors.selectedBG,
                          )
                        // Theme.of(context).textTheme.displayLarge
                        : widget.unselectedBold
                            ? styleBaseSemiBold(
                                color: ThemeColors.neutral20,
                                fontSize: widget.fontSize ?? 16,
                              )
                            : styleBaseRegular(
                                color: ThemeColors.neutral20,
                                fontSize: widget.fontSize ?? 16,
                              ),
                    // leadingIcon: e?.icon,
                  );
                })).toList(),
                // labelStyle: widget.textStyle ?? styleBaseBold(),
                indicator: CustomTabIndicator(),
                onTap: (int index) {
                  widget.onTap(index);
                },
              ),
            ),
            if (widget.rightChild != null) widget.rightChild!,
          ],
        ),
        if (widget.showDivider) BaseListDivider(),
      ],
    );
  }
}

class TabItem extends StatelessWidget {
  const TabItem(
      {super.key, required this.label, this.textStyle, this.leadingIcon});

  final String label;
  final String? leadingIcon;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12),
      child: OptionalParent(
        addParent: leadingIcon != null && leadingIcon != "",
        parentBuilder: (Widget child) {
          return Row(
            children: [
              Image.asset(leadingIcon ?? "", width: 20, height: 20),
              SpacerHorizontal(width: Pad.pad5),
              Flexible(child: child)
            ],
          );
        },
        child: Text(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          label,
          style: textStyle,
        ),
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    // Provide a default no-op function for onChanged
    return _CustomTabIndicatorPainter(onChanged ?? () {});
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final VoidCallback onChanged;

  _CustomTabIndicatorPainter(this.onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final double width = 20.0; // Fixed width of indicator
    final double height = 3; // Height of indicator
    final Paint paint = Paint()..color = ThemeColors.secondary120;
    final Rect rect = Offset(
            configuration.size!.width / 2 - width / 2 + offset.dx,
            configuration.size!.height - height + offset.dy) &
        Size(width, height);

    // Add rounded corners to the indicator
    final RRect rRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(4.0),
    );

    canvas.drawRRect(rRect, paint);
  }
}
