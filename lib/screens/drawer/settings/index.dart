import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/notification_settings.dart';
import '../../../routes/my_app.dart';
import '../../../utils/constants.dart';
import '../../../utils/dialogs.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addObserver(this);
      _getSettings();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Utils().showLog('App resumed');
        _check();
        break;
      case AppLifecycleState.paused:
        Utils().showLog('App paused');
        break;
      case AppLifecycleState.inactive:
        Utils().showLog('App inactive');
        break;
      case AppLifecycleState.detached:
        Utils().showLog('App detached');
        break;
      default:
        break;
    }
  }

  Future _check() async {
    notifySnackbar = await openNotificationsSettings();
    setState(() {});
  }

  Future _getSettings() async {
    await context.read<NotificationsSettingProvider>().getSettings();
  }

  @override
  Widget build(BuildContext context) {
    NotificationsSettingProvider provider =
        context.watch<NotificationsSettingProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        showTrailing: false,
        canSearch: false,
        title: provider.extra?.title ?? "Notification Settings",
      ),
      body:

          //  userProvider.user == null
          //     ? LoginError(
          //         title: "Notification Settings",
          //         onClick: () async {
          //           isPhone ? await loginSheet() : await loginSheetTablet();
          //           await _getSettings();
          //         },
          //       )
          //     :

          Stack(
        children: [
          BaseUiContainer(
            hasData: provider.settings != null && !provider.isLoading,
            isLoading: provider.isLoading,
            error: provider.error,
            onRefresh: provider.getSettings,
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
                          visible: provider.updatingIndex == -1 &&
                              provider.isUpdating,
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
                            value:
                                provider.settings?[index].selected == 1 ? 0 : 1,
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
                    visible:
                        provider.updatingIndex == index && provider.isUpdating,
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
          if (notifySnackbar && homeProvider.extra?.notifyTextMsg != null)
            CustomSnackbar(
              bottomPosition: 0,
              message:
                  "${navigatorKey.currentContext!.watch<HomeProvider>().extra?.notifyTextMsg}",
              displayDuration: Duration(minutes: 1),
              onTap: () async {
                // await openAppSettings();
                AppSettings.openAppSettings(type: AppSettingsType.notification);
              },
            ),
        ],
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
