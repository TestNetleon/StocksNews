import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../providers/user_provider.dart';
import '../../../../routes/my_app.dart';
import '../../../../utils/colors.dart';

class TournamentCloseSlidableMenu extends StatefulWidget {
  final Widget child;
  final int? index;
  final Function() close;

  const TournamentCloseSlidableMenu({
    super.key,
    required this.child,
    this.index,
    required this.close,
  });

  @override
  State<TournamentCloseSlidableMenu> createState() =>
      _SlidableMenuWidgetState();
}

class _SlidableMenuWidgetState extends State<TournamentCloseSlidableMenu>
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

        // extentRatio: 0.8,
        children: [
          GestureDetector(
            onTap: () {
              controller?.close(
                curve: Curves.linear,
                duration: const Duration(milliseconds: 200),
              );
              widget.close();
            },
            child: Container(
              color: ThemeColors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.remove_circle,
                    color: Colors.black,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    textAlign: TextAlign.center,
                    'Close Trade',
                    style: stylePTSansBold(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}
