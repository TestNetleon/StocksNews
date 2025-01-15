import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../../utils/theme.dart';

// class CountryPickerWidget extends StatelessWidget {
//   final Function(CountryCode value) onChanged;
//   final bool enabled;
//   final Color textColor;
//   const CountryPickerWidget({
//     super.key,
//     required this.onChanged,
//     this.enabled = true,
//     this.textColor = Colors.black,
//   });

//   @override
//   Widget build(BuildContext context) {
//     UserProvider provider = context.watch<UserProvider>();
//     UserRes? user = provider.user;
//     String? locale;

//     provider.updateUser(countryCode: '');
//     if (user?.phoneCode != null && user?.phoneCode != "") {
//       locale = CountryCode.fromDialCode(user!.phoneCode!).code?.split('_').last;
//     } else if (geoCountryCode != null && geoCountryCode != "") {
//       locale = geoCountryCode;
//     } else {
//       locale = "US";
//     }
//     return Stack(
//       children: [
//         CountryCodePicker(
//           padding: EdgeInsets.zero,
//           onChanged: onChanged,
//           initialSelection: locale,
//           showCountryOnly: false,
//           enabled: enabled,
//           closeIcon: const Icon(
//             Icons.close_sharp,
//             color: Colors.black,
//           ),
//           flagWidth: 24,
//           showOnlyCountryWhenClosed: false,
//           alignLeft: false,
//           boxDecoration: BoxDecoration(
//             color: ThemeColors.white,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           dialogTextStyle: styleGeorgiaBold(color: Colors.black),
//           textStyle: styleGeorgiaRegular(color: textColor),
//           searchStyle: styleGeorgiaRegular(color: Colors.black),
//           barrierColor: Colors.black26,
//           searchDecoration: InputDecoration(
//             iconColor: Colors.black,
//             fillColor: ThemeColors.divider,
//             contentPadding: EdgeInsets.zero,
//             prefixIcon: const Icon(
//               Icons.search,
//               size: 22,
//               color: Colors.black,
//             ),
//             filled: true,
//             hintStyle: stylePTSansRegular(color: Colors.grey),
//             hintText: "Search country",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(4.0),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(4.0),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(4.0),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//         CountryPickerWidgetHide(),
//       ],
//     );
//   }
// }

class CountryPickerWidget extends StatefulWidget {
  final Function(CountryCode value) onChanged;
  final bool enabled;
  final Color textColor;
  final bool showBox;

  const CountryPickerWidget({
    super.key,
    required this.onChanged,
    this.enabled = true,
    this.showBox = true,
    this.textColor = Colors.black,
  });

  @override
  State<CountryPickerWidget> createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  // final ValueNotifier<bool> _showOverlayNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = context.watch<UserProvider>();
    UserRes? user = provider.user;
    String? locale;

    // provider.updateUser(countryCode: '');
    // if (user?.phoneCode != null && user?.phoneCode != "") {
    //   locale = CountryCode.fromDialCode(user!.phoneCode!).code?.split('_').last;
    // } else if (geoCountryCode != null && geoCountryCode != "") {
    //   locale = geoCountryCode;
    // } else {
    //   locale = "US";
    // }

    if (user?.phoneCode != null && user?.phoneCode != "") {
      locale = CountryCode.fromDialCode(user!.phoneCode!).code?.split('_').last;
      if (user.phoneCode == '+1') {
        locale = 'US';
      }
    } else if (geoCountryCode != null && geoCountryCode != "") {
      locale = geoCountryCode;
    } else {
      locale = "US";
    }
    // try {
    //   Utils().showLog('${CountryCode.fromDialCode('+3').code}');
    // } catch (e) {
    //   Utils().showLog('$e');
    // }
    return Stack(
      children: [
        CountryCodePicker(
          padding: EdgeInsets.zero,
          onChanged: (value) {
            widget.onChanged(value);
            // _showOverlayNotifier.value = false;
          },
          initialSelection: locale,
          showCountryOnly: false,
          enabled: widget.enabled,
          closeIcon: const Icon(
            Icons.close_sharp,
            color: Colors.black,
          ),
          flagWidth: 24,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
          boxDecoration: BoxDecoration(
            color: ThemeColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          dialogTextStyle: styleGeorgiaBold(color: Colors.black),
          textStyle: styleGeorgiaRegular(color: widget.textColor),
          searchStyle: styleGeorgiaRegular(color: Colors.black),
          barrierColor: Colors.black26,
          searchDecoration: InputDecoration(
            iconColor: Colors.black,
            fillColor: ThemeColors.divider,
            contentPadding: EdgeInsets.zero,
            prefixIcon: const Icon(
              Icons.search,
              size: 22,
              color: Colors.black,
            ),
            filled: true,
            hintStyle: stylePTSansRegular(color: Colors.grey),
            hintText: "Search country",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        // ValueListenableBuilder<bool>(
        //   valueListenable: _showOverlayNotifier,
        //   builder: (context, showOverlay, child) {
        //     return Visibility(
        //       visible: showOverlay,
        //       child: Positioned.fill(
        //         child: IgnorePointer(
        //           ignoring: true,
        //           child: Container(
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(5),
        //                 bottomLeft: Radius.circular(5),
        //               ),
        //               color: ThemeColors.sos,
        //             ),
        //             child: const Icon(Icons.arrow_circle_down_outlined),
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
