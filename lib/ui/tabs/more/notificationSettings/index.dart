import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/notification/most_bullish.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class NotificationSettings extends StatefulWidget {
  static const path = 'NotificationSettings';
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    NotificationSettingsManager provider =
        context.read<NotificationSettingsManager>();
    provider.getData();
  }

  @override
  Widget build(BuildContext context) {
    NotificationSettingsManager provider =
        context.watch<NotificationSettingsManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        title: "Notification Settings",
        showBack: true,
        showSearch: true,
        showNotification: true,
        onSaveClick: () {},
      ),
      body: BaseLoaderContainer(
          isLoading: provider.isLoading,
          hasData: provider.data != null && !provider.isLoading,
          showPreparingText: true,
          error: provider.error,
          onRefresh: () {},
          child: Text("Settings")
          // BaseLoaderContainer(
          //   isLoading: provider.isLoadingHomePremium,
          //   hasData: provider.homePremiumData != null,
          //   showPreparingText: true,
          //   removeErrorWidget: true,
          //   placeholder: Center(
          //       child: CircularProgressIndicator(
          //     color: ThemeColors.black,
          //   )),
          //   onRefresh: () {},
          //   child: HomePremiumIndex(),
          // ),
          ),
    );
  }
}
