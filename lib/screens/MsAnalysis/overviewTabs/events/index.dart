import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/msAnalysis/radar_chart.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import '../../../../utils/colors.dart';

class MsEvents extends StatelessWidget {
  const MsEvents({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    return BaseUiContainer(
      hasData:
          provider.msEvents != null && provider.msEvents?.isNotEmpty == true,
      isLoading: provider.isLoadingEvents &&
          (provider.msEvents == null || provider.msEvents?.isEmpty == true),
      error: provider.errorEvents,
      showPreparingText: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: provider.msEvents?.length ?? 0,
        padding: EdgeInsets.only(bottom: 12, top: 10),
        itemBuilder: (context, index) {
          MsRadarChartRes? data = provider.msEvents?[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: data?.label != null && data?.label != '',
                child: Text(
                  "${data?.label}",
                  style: styleGeorgiaBold(fontSize: 18),
                ),
              ),
              Visibility(
                visible: data?.value != null && data?.value != '',
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "${data?.value}",
                    style: stylePTSansRegular(),
                  ),
                ),
              ),
              Visibility(
                visible: data?.description != null && data?.description != '',
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "${data?.description}",
                    style: stylePTSansRegular(color: ThemeColors.greyText),
                  ),
                ),
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: ThemeColors.greyText, height: 25);
        },
      ),
    );
  }
}
