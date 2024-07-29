import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  final List<NotificationTurn> _data = [
    NotificationTurn(
      label: "Get Alerts",
      isOn: true,
    ),
    NotificationTurn(
      label: "Blog",
      isOn: true,
    ),
    NotificationTurn(
      label: "News",
      isOn: true,
    ),
    NotificationTurn(
      label: "General Notification",
      isOn: true,
    ),
    NotificationTurn(
      label: "Email",
      isOn: true,
    ),
  ];

  void onChange(index) {
    _data[index].isOn = !_data[index].isOn;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            return NotificationSettingItem(
              label: _data[index].label,
              isOn: _data[index].isOn,
              onChanged: (value) => onChange(index),
            );
          },
          separatorBuilder: (context, index) {
            return SpacerVertical(height: 10);
          },
          itemCount: _data.length,
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
