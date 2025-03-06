import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';


class HelpDeskReasonsNew extends StatelessWidget {
  const HelpDeskReasonsNew({super.key});

  @override
  Widget build(BuildContext context) {
    NewHelpDeskManager manager = context.watch<NewHelpDeskManager>();
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: manager.data?.helpDesk?.subjects?.map((subject) {
              return GestureDetector(
                onTap: () {
                  manager.sendSubjectID(subject: subject);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: const BoxDecoration(
                    color: ThemeColors.background,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Text(
                      subject.title ?? "",
                      style: stylePTSansBold(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              );
            }).toList() ??
            [],
      ),
    );
  }
}
