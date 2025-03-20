import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/crypto_models/crypto_detail_res.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';


class SearchTiles extends StatelessWidget {
  final Rate? item;
  final Function()? onTap;
  final int? fromTo;
  const SearchTiles({super.key,this.item,this.onTap,this.fromTo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 224, 225, 227),
                shape: BoxShape.circle,
              ),
              width: 40,
              height:40,
              child:
              CachedNetworkImagesWidget(item?.imageUrl ?? ""),
            ),
          ),
          const SpacerHorizontal(width: 12),
          Visibility(visible:fromTo==1,child: Text(item?.symbol ?? "", style: styleBaseBold())),
          Visibility(visible:fromTo==2,child: Text(item?.currency ?? "", style: styleBaseBold())),
        ],
      ),
      onTap: onTap,
    );
  }
}
