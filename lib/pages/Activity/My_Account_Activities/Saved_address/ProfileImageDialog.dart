import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/pages/Activity/My_Account_Activities/MyAccount_activity.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../../../Core/AppConstant/apiMapping.dart';
import '../../../../Core/Model/CRMModels/CRMSingleIDModel.dart';
import '../../../../utils/StringUtils.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/routes/routes.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/dynamicPopUp.dart';
import '../../../../widgets/global/textFormFields.dart';
import '../MyAccountActivity/Edit_Account_activity.dart';

class ProfileImageDialog extends StatefulWidget {
  File? imageFile1;
  bool isEditAccount;

  ProfileImageDialog({
    required this.imageFile1,required this.isEditAccount
  });

  @override
  State<ProfileImageDialog> createState() => _ProfileImageDialogState();
}

class _ProfileImageDialogState extends State<ProfileImageDialog> {
  final picker = ImagePicker();

  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 280.0,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Container(
            //  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: TextFieldUtils().dynamicText(
                        'Upload image by choosing',
                        context,
                        TextStyle(fontSize: 20))),
                SizedBox(
                  height: 30,
                ),
                proceedButton(
                    'Camera', ThemeApp.tealButtonColor, context, false,
                    () async {
                  var image = await picker.getImage(source: ImageSource.camera);
                  final prefs = await SharedPreferences.getInstance();
                  // StringConstant.CurrentPinCode = (prefs.getString('CurrentPinCodePref') ?? '');
                  String imagePath = image!.path;

                  await prefs.setString('profileImagePrefs', imagePath);
                  Map data = {
                    "imgUrl": image.path,
                  };

                  setState(() {
                    widget.imageFile1 = File(image.path);
                    if(widget.isEditAccount ==true) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MyAccountActivity(),
                        ),
                      );
                    }else{
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>  EditAccountActivity(),
                        ),
                      );
                    }

                  });
                }),
                SizedBox(
                  height: 20,
                ),
                proceedButton(
                    'Gallery', ThemeApp.tealButtonColor, context, false,
                    () async {
                      final prefs = await SharedPreferences.getInstance();

                  FilePickerResult? pickedFile =
                      await FilePicker.platform.pickFiles();
                  if (pickedFile != null) {
                    String? filePath = pickedFile.files.single.path;
                    if (filePath != null) {
                      final file = File(filePath);
                      await prefs.setString('profileImagePrefs', filePath);

                      widget.imageFile1 = file;
                      if(widget.isEditAccount ==true) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MyAccountActivity(),
                          ),
                        );
                      }else{
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>  EditAccountActivity(),
                          ),
                        );
                      }
                    }
                  }
                }),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
