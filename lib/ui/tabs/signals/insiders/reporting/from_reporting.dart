import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../utils/colors.dart';
import '../../../../../widgets/custom/base_loader_container.dart';
import '../../../../base/app_bar.dart';
import '../../../../base/base_list_divider.dart';
import '../blocks.dart';
import 'item.dart';

class SignalInsidersReportingIndex extends StatefulWidget {
  static const path = 'SignalInsidersReportingIndex';
  final InsiderTradeRes data;
  const SignalInsidersReportingIndex({super.key, required this.data});

  @override
  State<SignalInsidersReportingIndex> createState() =>
      _SignalInsidersReportingIndexState();
}

class _SignalInsidersReportingIndexState
    extends State<SignalInsidersReportingIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    await context.read<SignalsManager>().getInsidersReportingData(
          cik: widget.data.reportingCik ?? '',
          loadMore: loadMore,
        );
  }

  @override
  Widget build(BuildContext context) {
    SignalsManager manager = context.watch<SignalsManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.signalInsidersReportingData?.title,
        showSearch: true,
        showNotification: true,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoadingInsidersReporting,
        hasData: manager.signalInsidersReportingData?.data != null &&
            manager.signalInsidersReportingData?.data?.isNotEmpty == true,
        showPreparingText: true,
        error: manager.errorInsidersReporting,
        onRefresh: _callAPI,
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: Pad.pad16),
                  child: Text(
                    widget.data.reportingName ?? '',
                    style: styleBaseBold(fontSize: 29),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    widget.data.typeOfOwner ?? '',
                    style: styleBaseRegular(
                      fontSize: 14,
                      color: ThemeColors.neutral40,
                    ),
                  ),
                ),
                SignalInsiderInfo(
                  info: manager.signalInsidersReportingData?.additionalInfo,
                ),
              ],
            ),
            Expanded(
              child: BaseLoadMore(
                onRefresh: _callAPI,
                onLoadMore: () async => _callAPI(loadMore: true),
                canLoadMore: manager.canLoadMoreInsidersReporting,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    InsiderTradeRes? data =
                        manager.signalInsidersReportingData?.data?[index];
                    bool isOpen = manager.openIndexReporting == index;
                    if (data == null) {
                      return SizedBox();
                    }
                    return BaseInsiderReportingItem(
                      data: data,
                      isOpen: isOpen,
                      onTap: () =>
                          manager.openMoreReporting(isOpen ? -1 : index),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return BaseListDivider();
                  },
                  itemCount:
                      manager.signalInsidersReportingData?.data?.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
