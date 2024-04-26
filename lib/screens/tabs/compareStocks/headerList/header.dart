import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/compare_stock_res.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/headerList/item.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/widgets/add_company_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class HeaderList extends StatelessWidget {
  final void Function()? onTap;
  const HeaderList({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    List<CompareStockRes> company =
        context.watch<CompareStocksProvider>().company;
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
            height: constraints.maxWidth * .29,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (company.isEmpty) {
                  return const SizedBox();
                }

                if (index == company.length) {
                  return FittedBox(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.scaleDown,
                      child: AddCompanyContainer(onTap: onTap));
                }

                return HeaderItem(
                  company: company[index],
                  onTap: () => provider.removeStockItem(index: index),
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerHorizontal(width: 10);
              },
              itemCount: company.isEmpty
                  ? 1
                  : (company.length < 4 ? company.length + 1 : company.length),
            ));
      },
    );
  }
}
