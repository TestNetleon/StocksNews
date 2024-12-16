import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../providers/user_provider.dart';
import '../../../../routes/my_app.dart';
import '../../../../utils/colors.dart';

class TsPendingSlidableMenu extends StatefulWidget {
  final Widget child;
  final int? index;
  final Function() onEditClick, onCancelClick;

  const TsPendingSlidableMenu({
    super.key,
    required this.child,
    this.index,
    required this.onEditClick,
    required this.onCancelClick,
  });

  @override
  State<TsPendingSlidableMenu> createState() => _SlidableMenuWidgetState();
}

class _SlidableMenuWidgetState extends State<TsPendingSlidableMenu>
    with SingleTickerProviderStateMixin {
  SlidableController? controller;

  @override
  void initState() {
    super.initState();

    controller = SlidableController(this);

    if ((widget.index ?? 1) == 0) {
      controller?.openTo(
        BorderSide.strokeAlignInside,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 500),
      );

      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          // Check if the widget is still mounted
          controller?.close(
            curve: Curves.linear,
            duration: const Duration(milliseconds: 1000),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future _subscribe() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    if (provider.user?.phone == null || provider.user?.phone == '') {
      // await membershipLogin();
    }
    if (provider.user?.phone != null && provider.user?.phone != '') {
      // Navigator.push(
      //   navigatorKey.currentContext!,
      //   MaterialPageRoute(
      //     builder: (_) => const NewMembership(),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: controller,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.8,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller?.close(
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 200),
                      );
                      widget.onEditClick();
                    },
                    child: Container(
                      color: const Color.fromARGB(255, 210, 191, 15),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, color: Colors.black),
                          const SpacerVertical(height: 5),
                          Text(
                            'Edit Order',
                            textAlign: TextAlign.center,
                            style: stylePTSansBold(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller?.close(
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 200),
                      );
                      widget.onCancelClick();
                    },
                    child: Container(
                      color: ThemeColors.darkRed,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete),
                          const SpacerVertical(height: 5),
                          Text(
                            textAlign: TextAlign.center,
                            'Cancel Order',
                            style: stylePTSansBold(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      child: widget.child,
    );
  }
}
