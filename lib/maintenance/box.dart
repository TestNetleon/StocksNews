import 'package:flutter/material.dart';
import 'package:stocks_news_new/routes/my_app.dart';

import 'app_maintenance.dart';

void showMaintenanceDialog({title, description, onClick, log}) {
  showGeneralDialog(
    transitionBuilder: (context, a1, a2, widget) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
                Dialog(
                  insetPadding: EdgeInsets.zero,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: PopScope(
                    canPop: false,
                    child: AppMaintenance(
                      onClick: onClick,
                      log: log,
                      title: title,
                      description: description,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: navigatorKey.currentContext!,
    pageBuilder: (context, animation1, animation2) {
      return const PopScope(
        canPop: false,
        child: SizedBox(),
      );
    },
  );
}
