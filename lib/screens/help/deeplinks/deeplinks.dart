import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/retry.dart';
import 'package:stocks_news_new/screens/help/deeplinks/deeplink_data.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class Deeplinks extends StatefulWidget {
  static const String path = "Deeplinks";

  const Deeplinks({super.key});

  @override
  State<Deeplinks> createState() => _DeeplinksState();
}

class _DeeplinksState extends State<Deeplinks> {
  List<DeeplinkData>? allData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDataFromStorage();
    });
  }

  void _getDataFromStorage() async {
    showGlobalProgressDialog();
    List<DeeplinkData> loadedData = await Preference.getDataList();
    closeGlobalProgressDialog();
    if (loadedData.isEmpty) {
      setState(() {
        allData = null;
      });
      return;
    }
    setState(() {
      allData = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.all(Dimen.padding.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenTitle(
              title: "Deeplinks",
              subTitleHtml: true,
              optionalWidget: TextButton(
                onPressed: () async {
                  await Preference.saveClearDataList();
                  _getDataFromStorage();
                },
                child: Text(
                  "Clear",
                  style: styleGeorgiaBold(color: ThemeColors.accent),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  DeeplinkData data = allData![index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.uri.toString(),
                        style: styleGeorgiaBold(),
                      ),
                      if (data.from != null)
                        Text(
                          "From : ${data.from}",
                          style: styleGeorgiaRegular(),
                        ),
                      if (data.path != null)
                        Text(
                          "Path : ${data.path}",
                          style: styleGeorgiaRegular(),
                        ),
                      if (data.type != null)
                        Text(
                          "Type : ${data.type}",
                          style: styleGeorgiaRegular(),
                        ),
                      if (data.slug != null)
                        Text(
                          "${data.slug}",
                          style: styleGeorgiaRegular(),
                        ),
                      if (data.onDeepLink != null)
                        Text(
                          "isDeepLink : ${data.onDeepLink}",
                          style: styleGeorgiaRegular(),
                        ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const SpacerVertical(),
                itemCount: allData != null ? allData?.length ?? 0 : 0,
                // itemCount: 3,
                shrinkWrap: true,
              ),
            ),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: ListView.separated(
            //       shrinkWrap: true,
            //       physics: const NeverScrollableScrollPhysics(),
            //       itemBuilder: (context, index) {
            //         return Container(
            //           width: double.infinity,
            //           height: 100,
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 12,
            //             vertical: 10,
            //           ),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(10.sp),
            //               topRight: Radius.circular(10.sp),
            //             ),
            //             gradient: const RadialGradient(
            //               center: Alignment.bottomCenter,
            //               radius: 0.6,
            //               stops: [0.0, 0.9],
            //               colors: [
            //                 Color.fromARGB(255, 0, 93, 12),
            //                 Colors.black,
            //               ],
            //             ),
            //             color: const Color.fromARGB(255, 118, 118, 118),
            //             border: const Border(
            //               top: BorderSide(color: ThemeColors.greyBorder),
            //             ),
            //           ),
            //           child: Text(
            //             "Data",
            //             style: stylePTSansBold(),
            //           ),
            //         );
            //       },
            //       separatorBuilder: (context, index) {
            //         return const SpacerVertical();
            //       },
            //       itemCount: allData?.length ?? 3,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
