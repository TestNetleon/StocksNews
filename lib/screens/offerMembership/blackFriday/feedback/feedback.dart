import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../../widgets/theme_input_field.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  double currentRating = 0;
  int totalCount = 5;
  int selectedType = -1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateData();
    });
  }

  _updateData() {
    UserRes? user = context.read<UserProvider>().user;
    if (user?.name != null && user?.name == '') {
      name.text = user?.name ?? '';
    }
    if (user?.phone != null && user?.phone == '') {
      name.text = user?.name ?? '';
    }

    setState(() {});
  }

  List<IdLabelRes> types = [
    IdLabelRes(id: 1, label: 'Yes'),
    IdLabelRes(id: 2, label: 'Partially'),
    IdLabelRes(id: 3, label: 'No'),
  ];

  List<IdLabelRes> dropTypes = [
    IdLabelRes(id: 1, label: 'Viewing Latest Stock News'),
    IdLabelRes(id: 2, label: 'Tracking Stock Performance'),
    IdLabelRes(id: 3, label: 'Managing Watchlist'),
    IdLabelRes(id: 4, label: 'Setting Stock Alerts'),
    IdLabelRes(id: 5, label: 'Reviewing Portfolio Performance'),
  ];

  IdLabelRes? selectedDropType;
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(
        title: 'Feedback Form',
        icon: Icons.close,
        isPopBack: true,
        showTrailing: false,
        canSearch: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimen.padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Did you achieve your goal on our aap?',
                  textAlign: TextAlign.center,
                  style: stylePTSansRegular(
                      color: ThemeColors.greyText, fontSize: 17),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 30),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedType = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            selectedType == index ? ThemeColors.accent : null,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ThemeColors.greyBorder),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(
                        types[index].label,
                        style: stylePTSansRegular(),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    SpacerVertical(height: 10),
                itemCount: 3,
              ),
              Text(
                'What were you using our app for?',
                textAlign: TextAlign.center,
                style: stylePTSansRegular(
                  color: ThemeColors.greyText,
                  fontSize: 17,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(top: 10, bottom: 40),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<IdLabelRes>(
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(5),
                  focusColor: Colors.white,
                  hint: Text('Select an action'),
                  value: selectedDropType,
                  onChanged: (IdLabelRes? newValue) {
                    setState(() {
                      selectedDropType = newValue;
                    });
                  },
                  items: dropTypes
                      .map<DropdownMenuItem<IdLabelRes>>((IdLabelRes value) {
                    return DropdownMenuItem<IdLabelRes>(
                      value: value,
                      child: Text(value.label),
                    );
                  }).toList(),
                ),
              ),
              StarRating(
                size: 50,
                rating: currentRating,
                color: ThemeColors.accent,
                borderColor: ThemeColors.greyText,
                allowHalfRating: true,
                starCount: totalCount,
                onRatingChanged: (rating) => setState(() {
                  currentRating = rating;
                }),
              ),
              SpacerVertical(height: 30),
              Text(
                'What motivated you to subscribe?',
                textAlign: TextAlign.center,
                style: stylePTSansRegular(
                    color: ThemeColors.greyText, fontSize: 17),
              ),
              SpacerVertical(height: 10),
              ThemeInputField(
                controller: description,
                placeholder: 'Share your experience',
                textInputAction: TextInputAction.newline,
                minLines: 4,
                maxLines: 6,
              ),
              SpacerVertical(height: 20),
              ThemeButton(
                onPressed: () {},
                text: 'Submit Feedback',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IdLabelRes {
  final int id;
  final String label;
  IdLabelRes({
    required this.id,
    required this.label,
  });
}
