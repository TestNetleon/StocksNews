import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SignalInsiderInfo extends StatelessWidget {
  final List<AdditionalInfoRes>? info;
  const SignalInsiderInfo({super.key, this.info});

  @override
  Widget build(BuildContext context) {
    if (info == null || info?.isEmpty == true) {
      return SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Pad.pad10, horizontal: Pad.pad10),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            info?.length ?? 0,
            (index) {
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.neutral5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(
                      right: index == ((info?.length ?? 0) - 1) ? 0 : Pad.pad8),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        info?[index].title ?? '',
                        style: styleBaseRegular(
                          color: ThemeColors.neutral80,
                        ),
                      ),
                      SpacerVertical(height: 8),
                      Text(
                        info?[index].value ?? '',
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                        style: styleBaseBold(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
