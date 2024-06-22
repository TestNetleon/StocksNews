import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/drawer/widgets/profile_image.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/select_type.dart';
import 'package:stocks_news_new/utils/bottom_sheets.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/api/image_service.dart';

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
    LeaderBoardProvider leaderProvider = context.read<LeaderBoardProvider>();

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: ThemeColors.primaryLight,
        elevation: 5, // Adjust the elevation to give a shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          // Rounded corners
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(25.sp),
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
                  userProvider.user?.name ?? "Hello",
                  style: stylePTSansBold(fontSize: 24),
                ),
                Visibility(
                  visible: userProvider.user?.email != null,
                  child: Text(
                    userProvider.user?.email ?? "",
                    style: stylePTSansRegular(
                        fontSize: 14, color: ThemeColors.greyText),
                  ),
                ),
                Visibility(
                  visible: userProvider.user?.name != null &&
                      (userProvider.user?.displayName != null &&
                          userProvider.user?.displayName != '') &&
                      (userProvider.user?.email != null &&
                          userProvider.user?.email != '') &&
                      (userProvider.user?.phone != null &&
                          userProvider.user?.phone != ''),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 18,
                          color: ThemeColors.accent,
                        ),
                        const SpacerHorizontal(width: 5),
                        Text(
                          "Verified",
                          style: stylePTSansRegular(
                              fontSize: 14, color: ThemeColors.greyText),
                        ),
                      ],
                    ),
                  ),
                ),
                // Visibility(
                //   visible: leaderProvider.extra?.received != null &&
                //       leaderProvider.extra?.received != 0,
                //   child: Container(
                //     padding: const EdgeInsets.all(.2),
                //     margin: const EdgeInsets.only(top: 13),
                //     decoration: const BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.only(
                //         topRight: Radius.circular(20),
                //         bottomRight: Radius.circular(20),
                //         bottomLeft: Radius.circular(20),
                //         topLeft: Radius.circular(20),
                //       ),
                //     ),
                //     child: Container(
                //       decoration: const BoxDecoration(
                //         color: ThemeColors.primaryLight,
                //         borderRadius: BorderRadius.only(
                //           topRight: Radius.circular(20),
                //           bottomRight: Radius.circular(20),
                //           bottomLeft: Radius.circular(20),
                //           topLeft: Radius.circular(20),
                //         ),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 5, horizontal: 40),
                //         child: Text(
                //           "${leaderProvider.extra?.received ?? 0}",
                //           style: stylePTSansBold(
                //               color: Colors.white, fontSize: 14),
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
