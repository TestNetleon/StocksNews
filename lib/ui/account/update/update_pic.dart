import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import 'image_type.dart';

class PersonalDetailUpdatePic extends StatefulWidget {
  const PersonalDetailUpdatePic({super.key});

  @override
  State<PersonalDetailUpdatePic> createState() =>
      _PersonalDetailUpdatePicState();
}

class _PersonalDetailUpdatePicState extends State<PersonalDetailUpdatePic> {
  final picker = ImagePicker();
  File? _image;

  void _selectOption() {
    BaseBottomSheet().bottomSheet(
        child: UpdateImageType(
      onCamera: () => _pickImage(source: ImageSource.camera),
      onGallery: () => _pickImage(),
    ));
  }

  Future<void> _pickImage({ImageSource? source}) async {
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
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: ThemeColors.background,
              toolbarWidgetColor: ThemeColors.border,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: "Image Cropper",
            ),
          ],
        );
        if (croppedFile != null) {
          setState(() {
            _image = File(croppedFile!.path);
          });
          UserManager manager =
              navigatorKey.currentContext!.read<UserManager>();
          manager.updatePersonalDetails(image: _image);
          Utils().showLog("cropped image=> $_image");
        }
      }
    } catch (e) {
      Utils().showLog("Error => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserManager manager = context.watch<UserManager>();
    UserRes? user = manager.user;
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10, bottom: 0),
            child: user?.image == null || user?.image == ''
                ? Image.asset(
                    Images.userPlaceholderNew,
                    height: 80,
                    width: 80,
                  )
                : user?.imageType == 'svg'
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: SvgPicture.network(
                          height: 80,
                          width: 80,
                          user?.image ?? '',
                          fit: BoxFit.cover,
                          placeholderBuilder: (BuildContext context) =>
                              Image.asset(
                            height: 80,
                            width: 80,
                            Images.userPlaceholderNew,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: CachedNetworkImagesWidget(
                          user?.image ?? '',
                          height: 80,
                          width: 80,
                          placeHolder: Images.userPlaceholderNew,
                          showLoading: true,
                        ),
                      ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _selectOption,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ThemeColors.white,
                  border: Border.all(color: ThemeColors.neutral10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  Images.write,
                  height: 14,
                  width: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
