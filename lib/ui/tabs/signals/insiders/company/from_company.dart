import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/insiders.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import '../../../../../widgets/custom/base_loader_container.dart';
import '../../../../base/app_bar.dart';
import '../../../../base/base_list_divider.dart';
import '../blocks.dart';
import 'item.dart';

class SignalInsidersCompanyIndex extends StatefulWidget {
  static const path = 'SignalInsidersCompanyIndex';
  final InsiderTradeRes data;
  const SignalInsidersCompanyIndex({super.key, required this.data});

  @override
  State<SignalInsidersCompanyIndex> createState() =>
      _SignalInsidersCompanyIndexState();
}

class _SignalInsidersCompanyIndexState
    extends State<SignalInsidersCompanyIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    await context.read<SignalsInsiderManager>().getInsidersCompanyData(
          cik: widget.data.companyCik ?? '',
          loadMore: loadMore,
        );
  }

  @override
  Widget build(BuildContext context) {
    SignalsInsiderManager manager = context.watch<SignalsInsiderManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        showSearch: true,
        showNotification: true,
        title: manager.signalInsidersCompanyData?.title,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoadingInsidersCompany,
        hasData: manager.signalInsidersCompanyData?.data != null &&
            manager.signalInsidersCompanyData?.data?.isNotEmpty == true,
        showPreparingText: true,
        error: manager.errorInsidersCompany,
        onRefresh: _callAPI,
        child: Column(
          children: [
            Column(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.data.image ?? '',
                  height: 96,
                  width: 96,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Pad.pad16),
                  child: Text(
                    widget.data.symbol ?? '',
                    style: styleBaseBold(fontSize: 29),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    widget.data.name ?? '',
                    style: styleBaseRegular(
                      fontSize: 14,
                      color: ThemeColors.neutral40,
                    ),
                  ),
                ),
                SignalInsiderInfo(
                    info: manager.signalInsidersCompanyData?.additionalInfo),
              ],
            ),
            Expanded(
              child: BaseLoadMore(
                onRefresh: _callAPI,
                onLoadMore: () async => _callAPI(loadMore: true),
                canLoadMore: manager.canLoadMoreInsidersCompany,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    InsiderTradeRes? data =
                        manager.signalInsidersCompanyData?.data?[index];
                    bool isOpen = manager.openIndexCompany == index;
                    if (data == null) {
                      return SizedBox();
                    }
                    return BaseInsiderCompanyItem(
                      data: data,
                      isOpen: isOpen,
                      onTap: () => manager.openMoreCompany(isOpen ? -1 : index),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return BaseListDivider();
                  },
                  itemCount:
                      manager.signalInsidersCompanyData?.data?.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
