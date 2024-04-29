import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/sectorIndustry/sector_industry.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

import '../states.dart';

//
class CompanyBrief extends StatelessWidget {
  const CompanyBrief({super.key});
  void _navigateSector(context, name, titleName) {
    Navigator.pushNamed(context, SectorIndustry.path, arguments: {
      "type": StockStates.sector,
      "name": name,
      "titleName": titleName,
    });
  }

  void _navigateIndustry(context, name, titleName) {
    Navigator.pushNamed(context, SectorIndustry.path, arguments: {
      "type": StockStates.industry,
      "name": name,
      "titleName": titleName,
    });
  }

  @override
  Widget build(BuildContext context) {
    StockDetailsRes? res = context.watch<StockDetailProvider>().data;

    String name =
        "${res?.keyStats?.name ?? ""} (${res?.keyStats?.symbol ?? ""})";
    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Column(
        children: [
          ScreenTitle(
            title: "Company Brief: $name",
            subTitle:
                "The Stock Score/Grades evaluate bankruptcy risk and assess the financial strength and fundamental health of a company",
            // style: stylePTSansRegular(fontSize: 20),
          ),
          Visibility(
            visible: res?.companyInfo?.sector != null,
            child: StateItem(
              label: "Sector",
              value: "${res?.companyInfo?.sector}",
              clickable: true,
              onTap: () => _navigateSector(context,
                  res?.companyInfo?.sectorSlug ?? "", res?.companyInfo?.sector),
            ),
          ),
          Visibility(
            visible: res?.companyInfo?.industry != null,
            child: StateItem(
              label: "Industry",
              value: "${res?.companyInfo?.industry}",
              clickable: true,
              onTap: () => _navigateIndustry(
                  context,
                  res?.companyInfo?.industrySlug ?? "",
                  res?.companyInfo?.industry),
            ),
          ),
          Visibility(
              visible: res?.companyInfo?.ceo != null,
              child: StateItem(label: "CEO", value: res?.companyInfo?.ceo)),
          Visibility(
            visible: res?.companyInfo?.website != null,
            child: StateItem(
              label: "Website",
              value: res?.companyInfo?.website,
              clickable: true,
              onTap: () => openUrl(res?.companyInfo?.website),
            ),
          ),
          Visibility(
            visible: res?.companyInfo?.country != null,
            child: StateItem(
              label: "Headquarters",
              value: res?.companyInfo?.country,
            ),
          ),
          Visibility(
            visible: res?.companyInfo?.fullTimeEmployees != null,
            child: StateItem(
              label: "Employees (FY)",
              value: res?.companyInfo?.fullTimeEmployees,
            ),
          ),
          Visibility(
              visible: res?.companyInfo?.ipoDate != null,
              child: StateItem(
                  label: "Founded", value: res?.companyInfo?.ipoDate)),
          Visibility(
              visible: res?.companyInfo?.isin != null,
              child: StateItem(label: "ISIN", value: res?.companyInfo?.isin)),
          const SpacerVerticel(height: 5),
          Visibility(
            visible: res?.companyInfo?.description != null,
            child: Text(
              res?.companyInfo?.description ?? "",
              style: stylePTSansRegular(
                fontSize: 14,
                height: 1.3,
                color: ThemeColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
