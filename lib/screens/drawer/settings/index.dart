import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../providers/notification_settings.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  @override
  Widget build(BuildContext context) {
    NotificationsSettingProvider provider =
        context.watch<NotificationsSettingProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        showTrailing: true,
        title: "Notification Settings",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  NotificationSettingItem(
                    label: provider.allOn
                        ? "Turn off all notifications"
                        : "Turn on all notifications",
                    isOn: provider.allOn,
                    onChanged: (value) => provider.changeAll(),
                  ),
                  SpacerVertical(height: 10),
                  NotificationSettingItem(
                    label: provider.data[index].label,
                    isOn: provider.data[index].isOn,
                    onChanged: (value) => provider.open(index),
                  ),
                ],
              );
            }
            return NotificationSettingItem(
              label: provider.data[index].label,
              isOn: provider.data[index].isOn,
              onChanged: (value) => provider.open(index),
            );
          },
          separatorBuilder: (context, index) {
            return SpacerVertical(height: 10);
          },
          itemCount: provider.data.length,
        ),
      ),
    );
  }
}

class NotificationSettingItem extends StatelessWidget {
  final String label;
  final bool isOn;
  final void Function(bool)? onChanged;
  const NotificationSettingItem({
    super.key,
    required this.label,
    this.isOn = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: styleSansBold(color: ThemeColors.white, fontSize: 20),
            ),
          ),
          Switch(
            value: isOn,
            onChanged: onChanged,
            activeColor: ThemeColors.accent,
            inactiveThumbColor: Color.fromARGB(255, 151, 151, 151),
            inactiveTrackColor: Color.fromARGB(255, 55, 57, 57),
          ),
        ],
      ),
    );
  }
}

class NotificationTurn {
  String label;
  bool isOn;
  NotificationTurn({
    required this.label,
    required this.isOn,
  });
}
