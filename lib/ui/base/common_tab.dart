import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class CommonTabs extends StatefulWidget {
  const CommonTabs({
    super.key,
    required this.data,
    required this.onTap,
    this.isScrollable = true,
    this.showDivider = true,
    this.rightChild,
    this.child,
  });

  final Widget? child;
  final Widget? rightChild;
  final bool isScrollable;
  final List<dynamic> data;
  final Function(int index) onTap;
  final bool showDivider;

  @override
  State<CommonTabs> createState() => _CommonTabsState();
}

class _CommonTabsState extends State<CommonTabs>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                controller: _tabController,
                isScrollable: widget.isScrollable,
                tabs: (widget.data.map(
                  (e) {
                    return TabItem(label: e.title);
                  },
                )).toList(),
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicator: CustomTabIndicator(),
                onTap: (int index) {
                  widget.onTap(index);
                },
              ),
            ),
            if (widget.rightChild != null) widget.rightChild!,
          ],
        ),
        if (widget.showDivider)
          Divider(
            color: ThemeColors.border,
            height: 1,
            thickness: 1,
          ),
        if (widget.child != null)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: Text("1")),
                Center(child: Text("2")),
                Center(child: Text("3")),
              ],
            ),
          ),
      ],
    );
    // return BaseContainer(
    //   body: Text("HERE"),
    // );
  }
}

class TabItem extends StatelessWidget {
  const TabItem({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Text(
        label,
        style: styleGeorgiaBold(),
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
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(4.0),
    );

    canvas.drawRRect(rrect, paint);
  }
}
