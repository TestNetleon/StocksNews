import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/drawer/widgets/profile_image.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/select_type.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/api/image_service.dart';

import '../../../providers/leaderboard.dart';
import '../../../utils/constants.dart';

//

class MyAccountHeader extends StatefulWidget {
  const MyAccountHeader({super.key});

  @override
  State<MyAccountHeader> createState() => _MyAccountHeaderState();
}

class _MyAccountHeaderState extends State<MyAccountHeader> {
  final picker = ImagePicker();
  File? _image;

  String appSignature = "";
  void _selectOption() {
    // showPlatformBottomSheet(
    //     padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 7.sp),
    //     context: context,
    //     content: MyAccountImageType(
    //       onCamera: () => _pickImage(source: ImageSource.camera),
    //       onGallery: () => _pickImage(),
    //     ));

    BaseBottomSheets().gradientBottomSheet(
        child: MyAccountImageType(
      onCamera: () => _pickImage(source: ImageSource.camera),
      onGallery: () => _pickImage(),
    ));
  }

  Future _pickImage({ImageSource? source}) async {
    Navigator.pop(context);
    closeKeyboard();
    try {
      CroppedFile? croppedFile;
      final pickedFile =
          await picker.pickImage(source: source ?? ImageSource.gallery);
      if (pickedFile != null) {
        croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: "Image Cropper",
                toolbarColor: ThemeColors.background,
                toolbarWidgetColor: ThemeColors.border,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: true),
            IOSUiSettings(
              title: "Image Cropper",
            ),
          ],
        );
        if (croppedFile != null) {
          Utils().showLog("cropped image=> ${croppedFile.path}");
          _image = File(croppedFile.path);
          setState(() {});
          _uploadImage(image: _image);
        }
      }
    } catch (e) {
      Utils().showLog("Error => $e");
    }
  }

  void _uploadImage({File? image}) async {
    MultipartFile? multipartFile;
    String? token = context.read<UserProvider>().user?.token ?? "";
    UserProvider userProvider = context.read<UserProvider>();

    if (image != null) {
      Uint8List? result = await testCompressAndGetFile(image);

      if (result != null) {
        multipartFile = MultipartFile.fromBytes(
          result,
          filename: image.path.substring(image.path.lastIndexOf("/") + 1),
        );
        final request = FormData.fromMap({
          "token": token,
          "image": multipartFile,
        });

        try {
          ApiResponse response = await requestUploadImage(
              url: Apis.updateProfile, request: request);
          if (response.status) {
            userProvider.updateUser(image: response.data);
          } else {
            //
          }
        } catch (e) {
          Utils().showLog("Error $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();

    return Stack(
      children: [
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10),
        //   child: Opacity(
        //     opacity: 0.2,
        //     child: Image.asset(
        //       Images.profileBg,
        //       height: 230,
        //       width: double.infinity,
        //     ),
        //   ),
        // ),
        SizedBox(
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            // color: ThemeColors.primaryLight,
            // elevation: 5, // Adjust the elevation to give a shadow effect
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10),
            //   // Rounded corners
            // ),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileImage(
                      imageSize: 95,
                      cameraSize: 19,
                      onTap: _selectOption,
                      url: context.watch<UserProvider>().user?.image,
                    ),
                    const SpacerVertical(height: 13),
                    Text(
                      userProvider.user?.name == null ||
                              userProvider.user?.name == ''
                          ? "Hello"
                          : userProvider.user?.name ?? "",
                      textAlign: TextAlign.center,
                      style: stylePTSansBold(
                        fontSize: 24,
                      ),
                    ),
                    // Visibility(
                    //   visible: userProvider.user?.email != null,
                    //   child: Text(
                    //     userProvider.user?.email ?? "",
                    //     style: stylePTSansRegular(
                    //         fontSize: 14, color: ThemeColors.greyText),
                    //   ),
                    // ),
                    const Padding(
                      padding: EdgeInsets.only(top: 13),
                      child: MyVerifiedCard(gotoProfile: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyVerifiedCard extends StatelessWidget {
  final bool gotoProfile;
  const MyVerifiedCard({super.key, this.gotoProfile = true});

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider leaderProvider = context.watch<LeaderBoardProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    bool verified = userProvider.user?.name != null &&
        (userProvider.user?.displayName != null &&
            userProvider.user?.displayName != '') &&
        (userProvider.user?.email != null && userProvider.user?.email != '') &&
        (userProvider.user?.phone != null && userProvider.user?.phone != '');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: InkWell(
            onTap: () {
              verified
                  ? popUpAlert(
                      padding: const EdgeInsets.all(10),
                      message: !verified
                          ? homeProvider.extra?.profileText?.unVerified ??
                              "Unverified users are those who have not confirmed their name, email, display name, or mobile number."
                          : homeProvider.extra?.profileText?.verified ??
                              "Verified users are those who have confirmed their name, email, display name, and mobile number.",
                      title: verified ? "Verified" : "Unverified",
                      iconWidget: Icon(
                        Icons.verified,
                        size: 80,
                        color: verified ? ThemeColors.accent : ThemeColors.sos,
                      ),
                    )
                  : gotoProfile
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyAccount(),
                          ),
                        )
                      : null;
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified,
                  size: 24,
                  color: verified ? ThemeColors.accent : ThemeColors.sos,
                ),
                const SpacerVertical(height: 5),
                Text(
                  verified ? "Verified" : "Unverified",
                  style: stylePTSansBold(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SpacerHorizontal(width: 10),
        Flexible(
          child: InkWell(
            onTap: () {
              popUpAlert(
                padding: const EdgeInsets.all(10),
                message: homeProvider.extra?.profileText?.points ??
                    "Points are earned by referring the app to friends and family who join and verify their contact information, with the referring user receiving points for each verified referral.",
                title: "Points",
                icon: Images.pointIcon2,
              );
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    Images.pointIcon2,
                    height: 25,
                    width: 25,
                  ),
                ),
                const SpacerVertical(height: 5),
                Text(
                  leaderProvider.extra?.balance == 0 ||
                          leaderProvider.extra?.balance == 1
                      ? "${leaderProvider.extra?.balance ?? 0} Point"
                      : "${leaderProvider.extra?.balance ?? 0} Points",
                  textAlign: TextAlign.center,
                  style: stylePTSansBold(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SpacerHorizontal(width: 10),
        Flexible(
          child: InkWell(
            onTap: () {
              popUpAlert(
                padding: const EdgeInsets.all(10),
                message: homeProvider.extra?.profileText?.rank ??
                    "Rank is the position a user holds on the leaderboard of the affiliate program.",
                title: "Rank",
                icon: Images.rankAffiliate,
              );
            },
            child: Column(
              children: [
                Image.asset(
                  Images.rankAffiliate,
                  height: 30,
                  width: 30,
                ),
                const SpacerVertical(height: 5),
                Text(
                  verified
                      ? "Rank - ${leaderProvider.extra?.selfRank ?? 0}"
                      : "Rank - N/A",
                  style: stylePTSansBold(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
