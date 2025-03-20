import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/billionaires_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/widget/billionaire_grid_item.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';


class AllBillionairesIndex extends StatefulWidget {
  static const path = 'AllBillionairesIndex';

  const AllBillionairesIndex({super.key});

  @override
  State<AllBillionairesIndex> createState() => _AllBillionairesIndexState();
}

class _AllBillionairesIndexState extends State<AllBillionairesIndex> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    BillionairesManager manager = context.read<BillionairesManager>();
    manager.getAllBills();
  }
  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    TopTab? viewRes = manager.viewBillRes?.topTab;

    return BaseScaffold(
        appBar:
        BaseAppBar(
          showBack: true,
          title:  !manager.isViewLoading?viewRes?.billionaires?.title ?? "":"",
          showSearch: true,
        ),
        body: BaseLoaderContainer(
          isLoading: manager.isViewLoading,
          hasData: manager.viewBillRes != null && !manager.isViewLoading,
          showPreparingText: true,
          error: manager.error,
          onRefresh: () {
            _callAPI();
          },
          child: BaseScroll(
            onRefresh: manager.getAllBills,
            margin: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomGridViewPerChild(
                    paddingHorizontal:8,
                    paddingVertical:18,
                    length:viewRes?.billionaires?.data?.length ?? 0,
                    getChild: (index) {
                      CryptoTweetPost? item = viewRes?.billionaires?.data?[index];
                      bool? isEven= index%2==0;
                      if (item == null) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: isEven?8:0.0),
                        child: BillionaireGridItem(
                          item: item,
                          onTap: () {
                            Navigator.pushNamed(context, BillionairesDetailIndex.path,
                                arguments: {'slug': item.slug ?? ""});

                          },
                        ),
                      );
                    },
                  ),
                )
              ],


          ),
        )
    );
  }
}
