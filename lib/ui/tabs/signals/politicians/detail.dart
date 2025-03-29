import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/politicians.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/custom/base_loader_container.dart';
import '../../../base/base_list_divider.dart';
import '../insiders/blocks.dart';
import 'detail_item.dart';

class SignalPoliticianDetailIndex extends StatefulWidget {
  static const path = 'SignalPoliticianDetailIndex';
  final PoliticianTradeRes data;
  const SignalPoliticianDetailIndex({super.key, required this.data});

  @override
  State<SignalPoliticianDetailIndex> createState() =>
      _SignalPoliticianDetailIndexState();
}

class _SignalPoliticianDetailIndexState
    extends State<SignalPoliticianDetailIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    await context.read<SignalsPoliticianManager>().getPoliticianDetailData(
          userSlug: widget.data.userSlug ?? '',
          loadMore: loadMore,
        );
  }

  @override
  Widget build(BuildContext context) {
    SignalsPoliticianManager manager =
        context.watch<SignalsPoliticianManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.signalPoliticianDetailData?.title,
        showSearch: true,
        showNotification: true,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoadingPoliticianDetail,
        hasData: manager.signalPoliticianDetailData?.data != null &&
            manager.signalPoliticianDetailData?.data?.isNotEmpty == true,
        showPreparingText: true,
        error: manager.errorPoliticianDetail,
        onRefresh: _callAPI,
        child: Column(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.data.userImage ?? '',
                    height: 96,
                    width: 96,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Pad.pad16),
                  child: Text(
                    widget.data.userName ?? '',
                    style: styleBaseBold(fontSize: 29),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    widget.data.office ?? '',
                    style: styleBaseRegular(fontSize: 14),
                  ),
                ),
                SignalInsiderInfo(
                  info: manager.signalPoliticianDetailData?.additionalInfo,
                ),
              ],
            ),
            Expanded(
              child: BaseLoadMore(
                onRefresh: _callAPI,
                onLoadMore: () async => _callAPI(loadMore: true),
                canLoadMore: manager.canLoadMorePoliticianDetail,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    PoliticianTradeRes? data =
                        manager.signalPoliticianDetailData?.data?[index];
                    bool isOpen = manager.openIndexPoliticianDetail == index;
                    if (data == null) {
                      return SizedBox();
                    }
                    return BasePoliticianDetailItem(
                      data: data,
                      isOpen: isOpen,
                      onTap: () =>
                          manager.openMorePoliticianDetail(isOpen ? -1 : index),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return BaseListDivider();
                  },
                  itemCount:
                      manager.signalPoliticianDetailData?.data?.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
