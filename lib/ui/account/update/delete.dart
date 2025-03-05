import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/delete.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/text_field.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class DeletePersonalDetail extends StatefulWidget {
  static const path = 'DeletePersonalDetail';
  const DeletePersonalDetail({super.key});

  @override
  State<DeletePersonalDetail> createState() => _DeletePersonalDetailState();
}

class _DeletePersonalDetailState extends State<DeletePersonalDetail> {
  TextEditingController text = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserManager>().deleteUser(reset: true);
    });
  }

  @override
  void dispose() {
    text.clear();
    super.dispose();
  }

  _deleteUser() {
    UserManager manager = context.read<UserManager>();
    manager.deleteUser(text: text.text);
  }

  @override
  Widget build(BuildContext context) {
    UserManager manager = context.watch<UserManager>();
    DeleteUserRes? delete = manager.delete;
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BaseScaffold(
      body: BaseLoaderContainer(
        hasData: delete != null,
        isLoading: manager.isLoadingDelete && manager.delete == null,
        error: manager.errorDelete,
        showPreparingText: true,
        onRefresh: manager.deleteUser,
        child: Column(
          children: [
            Expanded(
              child: BaseScroll(
                children: [
                  SpacerVertical(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Pad.pad16),
                      child: Container(
                        padding: EdgeInsets.all(27),
                        decoration: BoxDecoration(
                          color: ThemeColors.neutral5,
                          borderRadius: BorderRadius.circular(Pad.pad16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: delete?.icon ?? '',
                          height: 33,
                          width: 33,
                        ),
                      ),
                    ),
                  ),
                  SpacerVertical(height: 30),
                  Text(
                    textAlign: TextAlign.center,
                    '${delete?.title}',
                    style: styleBaseBold(fontSize: 32),
                  ),
                  SpacerVertical(height: 10),
                  HtmlWidget(
                    '${delete?.subTitle}',
                    textStyle: TextStyle(
                      fontFamily: Fonts.roboto,
                      fontSize: 18,
                      color: ThemeColors.neutral80,
                    ),
                  ),
                  SpacerVertical(height: 40),
                  BaseTextField(
                    controller: text,
                    onChanged: (p0) {
                      text.text = p0;
                      setState(() {});
                    },
                    hintText: 'Type DELETE to confirm',
                  ),
                ],
              ),
            ),
            if (!isKeyboardOpen)
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: Pad.pad16,
                  vertical: 10,
                ),
                child: BaseButton(
                  color: ThemeColors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: delete?.btnActive ?? '',
                  textColor: ThemeColors.neutral40,
                  side: BorderSide(color: ThemeColors.neutral10),
                ),
              ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: Pad.pad16,
                vertical: 10,
              ),
              child: BaseButton(
                disabledBackgroundColor: ThemeColors.error,
                disableTextColor: ThemeColors.white,
                textColor: ThemeColors.white,
                color: ThemeColors.error120,
                text: delete?.btnDelete ?? '',
                onPressed: text.text.isEmpty || text.text != 'DELETE'
                    ? null
                    : _deleteUser,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
