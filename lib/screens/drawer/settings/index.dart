import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../providers/notification_settings.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSettings();
    });
  }

  void getSettings() async {
    context.read<NotificationsSettingProvider>().getSettings();
  }

  @override
  Widget build(BuildContext context) {
    NotificationsSettingProvider provider =
        context.watch<NotificationsSettingProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        showTrailing: false,
        canSearch: false,
        title: provider.extra?.title ?? "Notification Settings",
      ),
      body: BaseUiContainer(
        hasData: provider.settings != null && !provider.isLoading,
        isLoading: provider.isLoading,
        error: provider.error,
        onRefresh: getSettings,
        errorDispCommon: true,
        showPreparingText: true,
        child: Padding(
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
                      visible:
                          provider.updatingIndex == -1 && provider.isUpdating,
                      // onChanged: (value) => provider.changeAll(),
                      onChanged: (value) => provider.updateSettings(
                        slug: "all",
                        value: provider.allOn ? 0 : 1,
                        index: -1,
                      ),
                    ),
                    SpacerVertical(height: 10),
                    NotificationSettingItem(
                      label: provider.settings?[index].title ?? '',
                      isOn: provider.settings?[index].selected == 1,
                      visible: provider.updatingIndex == index &&
                          provider.isUpdating,
                      // onChanged: (value) => provider.open(index),
                      onChanged: (value) => provider.updateSettings(
                        slug: provider.settings?[index].slug,
                        value: provider.settings?[index].selected == 1 ? 0 : 1,
                        index: index,
                      ),
                    ),
                  ],
                );
              }
              return NotificationSettingItem(
                label: provider.settings?[index].title ?? '',
                isOn: provider.settings?[index].selected == 1,
                // onChanged: (value) => provider.open(index),
                visible: provider.updatingIndex == index && provider.isUpdating,
                onChanged: (value) => provider.updateSettings(
                  slug: provider.settings?[index].slug,
                  value: provider.settings?[index].selected == 1 ? 0 : 1,
                  index: index,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
            // itemCount: provider.data.length,
            itemCount: provider.settings?.length ?? 0,
          ),
        ),
      ),
    );
  }
}

class NotificationSettingItem extends StatelessWidget {
  final String label;
  final bool isOn;
  final bool visible;
  final void Function(bool)? onChanged;

  const NotificationSettingItem({
    super.key,
    required this.label,
    this.isOn = true,
    this.onChanged,
    this.visible = false,
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
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: styleSansBold(color: ThemeColors.white, fontSize: 20),
            ),
          ),
          Visibility(
            visible: visible,
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: ThemeColors.accent,
                strokeWidth: 2,
              ),
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
