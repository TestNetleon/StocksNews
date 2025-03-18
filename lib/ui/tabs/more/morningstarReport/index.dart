import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/morningstar_report.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/ui/stockDetail/overview/morningStar/pdf.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';

import '../../../../models/lock.dart';
import '../../../base/base_list_divider.dart';
import '../../../base/login_required.dart';

class MorningStarReportsIndex extends StatefulWidget {
  static const path = 'MorningStarReportsIndex';
  const MorningStarReportsIndex({super.key});

  @override
  State<MorningStarReportsIndex> createState() =>
      _MorningStarReportsIndexState();
}

class _MorningStarReportsIndexState extends State<MorningStarReportsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MorningStarReportsManager>().getMorningStarReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MorningStarReportsManager>(
      builder: (context, value, child) {
        BaseLockInfoRes? loginRequired = value.data?.loginRequired;

        return BaseScaffold(
          appBar: BaseAppBar(
            showBack: true,
            title: value.data?.title ?? '',
          ),
          body: loginRequired != null && !value.isLoading
              ? BaseLoginRequired(
                  data: loginRequired,
                  onPressed: () async {
                    value.getMorningStarReports();
                  },
                )
              : BaseLoaderContainer(
                  hasData: value.data != null,
                  isLoading: value.isLoading,
                  error: value.error,
                  showPreparingText: true,
                  child: CommonRefreshIndicator(
                    onRefresh: () async {
                      value.getMorningStarReports();
                    },
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        BaseTickerRes? data = value.data?.data?[index];
                        if (data == null) {
                          return SizedBox();
                        }
                        return BaseStockAddItem(
                          data: data,
                          index: index,
                          slidable: false,
                          onTap: (p0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PdfViewerWidget(url: p0.pdfUrl ?? ''),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return BaseListDivider();
                      },
                      itemCount: value.data?.data?.length ?? 0,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
