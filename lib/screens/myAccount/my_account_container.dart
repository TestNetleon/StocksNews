import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/api/image_service.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/otp.dart';
import 'package:stocks_news_new/screens/myAccount/widgets/select_type.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/alphabet_inputformatter.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:validators/validators.dart';
//
import '../../utils/dialogs.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../../utils/validations.dart';
import '../../widgets/spacer_vertical.dart';
import '../../widgets/theme_input_field.dart';
import '../drawer/widgets/profile_image.dart';

class MyAccountContainer extends StatefulWidget {
  const MyAccountContainer({super.key});

  @override
  State<MyAccountContainer> createState() => _MyAccountContainerState();
}

class _MyAccountContainerState extends State<MyAccountContainer>
    with WidgetsBindingObserver {
  final picker = ImagePicker();
  File? _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    UserProvider provider = context.read<UserProvider>();
    provider.keyboardVisiblity(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateUser();
  }

  void _updateUser() {
    UserRes? user = context.read<UserProvider>().user;
    if (user?.name?.isNotEmpty == true) nameController.text = user?.name ?? "";
    if (user?.email?.isNotEmpty == true) {
      emailController.text = user?.email ?? "";
    }
  }

  void _onTap() async {
    closeKeyboard();
    UserProvider provider = context.read<UserProvider>();
    if (isEmpty(nameController.text)) {
      // showErrorMessage(message: "Please enter valid name");
      return;
    } else if (!isEmail(emailController.text)) {
      // showErrorMessage(message: "Please enter valid email address");
      return;
    } else {
      try {
        ApiResponse res = await context.read<UserProvider>().updateProfile(
              token: context.read<UserProvider>().user?.token ?? "",
              name: nameController.text,
              email: emailController.text.toLowerCase(),
            );

        if (res.status) {
          if (emailController.text != provider.user?.email) {
            log("IF");
            _sendOTP(otp: res.data["otp"].toString());
          } else {
            log("ELSE");
            provider.updateUser(
                name: nameController.text,
                email: emailController.text.toLowerCase());
          }
        }
      } catch (e) {
        //
      }
    }
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
          log("cropped image=> ${croppedFile.path}");
          _image = File(croppedFile.path);
          setState(() {});
          _uploadImage(image: _image);
        }
      }
    } catch (e) {
      log("Error => $e");
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
          log("Error $e");
        }
      }
    }
  }

  void _selectOption() {
    showPlatformBottomSheet(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 7.sp),
        context: context,
        content: MyAccountImageType(
          onCamera: () => _pickImage(source: ImageSource.camera),
          onGallery: () => _pickImage(),
        ));
  }

  void _sendOTP({String? otp}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.sp),
            topRight: Radius.circular(6.sp),
          ),
        ),
        backgroundColor: ThemeColors.background,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: MyAccountOTP(
              otp: otp,
              name: nameController.text,
              email: emailController.text,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(25.sp),
            child: ProfileImage(
              imageSize: 95,
              cameraSize: 19,
              onTap: _selectOption,
              url: context.watch<UserProvider>().user?.image,
            ),
          ),
        ),
        Text(
          "Name",
          style: stylePTSansRegular(fontSize: 14),
        ),
        const SpacerVertical(height: 5),
        ThemeInputField(
          controller: nameController,
          placeholder: "Enter your name",
          keyboardType: TextInputType.text,
          inputFormatters: [AlphabetInputFormatter()],
          textCapitalization: TextCapitalization.words,
        ),
        const SpacerVertical(height: 13),
        Text(
          "Email",
          style: stylePTSansRegular(fontSize: 14),
        ),
        const SpacerVertical(height: 5),
        ThemeInputField(
          controller: emailController,
          placeholder: "Enter your email id",
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [emailFormatter],
          textCapitalization: TextCapitalization.none,
        ),
        // const SpacerVertical(height: 13),
        // Text(
        //   "Phone Number",
        //   style: stylePTSansRegular(fontSize: 14),
        // ),
        // const SpacerVertical(height: 5),
        // ThemeInputField(
        //   controller: mobileController,
        //   placeholder: "Enter your phone number",
        //   keyboardType: TextInputType.phone,
        //   inputFormatters: [
        //     FilteringTextInputFormatter.digitsOnly,
        //     // LengthLimitingTextInputFormatter(10),
        //   ],
        // ),
        const SpacerVertical(height: 20),
        ThemeButton(
          onPressed: _onTap,
          text: "Save Changes",
        )
      ],
    );
  }
}
