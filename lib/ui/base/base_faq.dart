import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/global.dart';
import 'package:stocks_news_new/models/faq.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/more/faq/item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BaseFaq extends StatefulWidget {
  final BaseFaqRes? faqs;
  const BaseFaq({super.key, this.faqs});

  @override
  State<BaseFaq> createState() => _BaseFaqState();
}

class _BaseFaqState extends State<BaseFaq> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalManager globalManager = context.read<GlobalManager>();

      globalManager.change(0);
    });
  }
  @override
  Widget build(BuildContext context) {
    GlobalManager globalManager = context.watch<GlobalManager>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.faqs?.title!=null,
          child: BaseHeading(
            title: widget.faqs?.title,
            margin: EdgeInsets.only(
                left: Pad.pad16,
                right: Pad.pad16,
                bottom: Pad.pad10
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
          itemBuilder: (context, index) {
            BaseFaqDataRes? data = widget.faqs?.faqs?[index];
            if (data == null) {
              return SizedBox();
            }
            bool isOpen = globalManager.openIndex == index;
            return FAQItem(
              isOpen: isOpen,
              faq: data,
              onChange: () => globalManager.change(isOpen ? -1 : index),
            );
          },
          separatorBuilder: (context, index) {
            return SpacerVertical();
          },
          itemCount: widget.faqs?.faqs?.length ?? 0,
        ),
      ],
    );
  }
}

