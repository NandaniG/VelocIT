import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocit/services/models/userAccountDetailModel.dart';

import '../../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';
import 'OTP_verification_Popup.dart';

class EditAccountActivity extends StatefulWidget {
  const EditAccountActivity({Key? key}) : super(key: key);

  @override
  State<EditAccountActivity> createState() => _EditAccountActivityState();
}

class _EditAccountActivityState extends State<EditAccountActivity> {
  double height = 0.0;
  double width = 0.0;
  final picker = ImagePicker();
  late File _profileImage;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  //
  // TextEditingController fullNameController = new TextEditingController();
  // TextEditingController mobileController = new TextEditingController();
  // TextEditingController emailController = new TextEditingController();

  bool _validateFullName = false;
  bool _validateMobile = false;
  bool _validateEmail = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeApp.blackColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/myAccountActivity' );

            },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: ThemeApp.whiteColor,
            ),
          ),
        ),
      ),
      body: Consumer<ProductProvider>(builder: (context, value, child) {
        return Container(
          padding: EdgeInsets.only(top: 0),
          color: ThemeApp.backgroundColor,
          height: height * .6,
          child: Stack(
            children: [
              Container(
                height: height * .12,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ThemeApp.blackColor,
                    border: Border.all(
                      color: ThemeApp.blackColor,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Align(
                  alignment: Alignment(0.0, .2),
                  child: Container(
                    // height: height *.9,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.only(top: 50, left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: ThemeApp.whiteColor,
                    ),
                    // height: profile_side,
                    width: width,
                    child: Form(
                      child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Full Name
                          TextFieldUtils().dynamicText(
                              AppLocalizations.of(context).fullName,
                              context,
                              TextStyle(
                                  color: ThemeApp.blackColor,
                                  fontSize: height * .02,
                                  fontWeight: FontWeight.w600)),
                          TextFormFieldsWidget(
                              errorText:
                                  AppLocalizations.of(context).enterFullName,
                              textInputType: TextInputType.text,
                              controller: value.userNameController,
                              autoValidation:
                                  AutovalidateMode.onUserInteraction,
                              hintText: 'David Wong',
                              onChange: (val) {},
                              validator: (value) {
                                return null;
                              }),
                          //Mobile Number
                          TextFieldUtils().dynamicText(
                              AppLocalizations.of(context).mobileNumber,
                              context,
                              TextStyle(
                                  color: ThemeApp.blackColor,
                                  fontSize: height * .02,
                                  fontWeight: FontWeight.w600)),
                          MobileNumberTextFormField(
                              controller: value.userMobileController),

                          /*    TextFormFieldsWidget(
                                errorText: AppLocalizations.of(context).mobileNumber,
                                textInputType: TextInputType.number,
                                controller: mobileController,maxLength: 10,
                                autoValidation: AutovalidateMode.onUserInteraction,
                                hintText: 'Ex: 8582968541',
                                onChange: (val) {

                                },
                                validator: (value) {
                                  if (value.isEmpty && mobileController.text.isEmpty) {
                                    _validateMobile = true;
                                    return AppLocalizations.of(context).enterMobileNumber;
                                  } else if (
                                  mobileController.text.length <=9) {
                                    _validateMobile = true;
                                    return AppLocalizations.of(context).enterMobileNumber;
                                  } else {
                                    _validateMobile = false;
                                  }
                                  return null;
                                }),*/
                          //Mobile Number
                          TextFieldUtils().dynamicText(
                              AppLocalizations.of(context).email,
                              context,
                              TextStyle(
                                  color: ThemeApp.blackColor,
                                  fontSize: height * .02,
                                  fontWeight: FontWeight.w600)),
                          TextFormFieldsWidget(
                              errorText: AppLocalizations.of(context).email,
                              textInputType: TextInputType.emailAddress,
                              controller: value.userEmailController,
                              autoValidation:
                                  AutovalidateMode.onUserInteraction,
                              hintText: 'david@gmil.com',
                              onChange: (val) {},
                              validator: (val) {
                                if (val.isEmpty &&
                                    value.userEmailController.text.isEmpty) {
                                  _validateEmail = true;
                                  return AppLocalizations.of(context)
                                      .emailError;
                                } else if (!StringConstant().isEmail(val)) {
                                  _validateEmail = true;
                                  return AppLocalizations.of(context)
                                      .emailError;
                                } else {
                                  _validateEmail = false;
                                }
                                return null;
                              }),
                          SizedBox(
                            height: height * .02,
                          ),
                          proceedButton(AppLocalizations.of(context).update,
                              ThemeApp.blackColor, context, () {


                            print("value.creditCardList__________" +
                                value.userAccountDetailList.length.toString());
                            setState(() {
                              value.userAccountDetailList.add(
                                  UserAccountList(
                                      userId: 1,
                                      userName: value.userNameController.text,
                                      userEmail: value.userEmailController.text,
                                      userMobile: value.userMobileController.text,
                                      userPassword: 'userPassword'));

                              Prefs().setToken(StringConstant.userAccountNamePref,
                                  value.userNameController.text);
                              Prefs().setToken(
                                  StringConstant.userAccountEmailPref,
                                  value.userEmailController.text);
                              Prefs().setToken(
                                  StringConstant.userAccountMobilePref,
                                  value.userMobileController.text);


                                });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return OTPVerificationDialog();
                                });
                          })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment(0, -1),
                  child: Container(
                      alignment: Alignment(0, -1),
                      child: Icon(
                        Icons.circle,
                        size: height * .15,
                        color: ThemeApp.lightGreyTab,
                      ))),
              images !=
                  ""
                  ? Align(
                  alignment: Alignment(0, -1),
                  child: Container(
                    // height: 50,width:50,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,),
                      alignment: Alignment(0, -1),
                     child:    InkWell(
                       onTap: () async {
                         await ManagePermissions
                             .askCameraPermission()
                             .then((value) async {
                           var img = await ImagePicker()
                               .getImage(
                               source: ImageSource
                                   .camera);
                           if (mounted) {
                             setState(() {
                               _profileImage =
                                   File(img!.path);
                               getBase64Image(img)
                                   .then((value) => {
                                 images =
                                     value

                               });print("images....$_profileImage");
                             });
                           }
                         });
                       },
                       child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(100)),
                        child: Image.memory(
                            Base64Decoder().convert(images
                                .replaceAll(
                                RegExp(
                                    r'^data:image\/[a-z]+;base64,'),
                                '')),fit: BoxFit.fill,
                          width: 100,
                          height: 100,
                            ),
                    ),
                     ),))
                  :  Align(
                  alignment: Alignment(0, -1),
                  child: Container(
                      alignment: Alignment(0, -1),
                      child: InkWell(
                        onTap: () async {
                          await ManagePermissions
                              .askCameraPermission()
                              .then((value) async {
                            var img = await ImagePicker()
                                .getImage(
                                source: ImageSource
                                    .camera);
                            if (mounted) {
                              setState(() {
                                _profileImage =
                                    File(img!.path);
                                getBase64Image(img)
                                    .then((value) => {
                                  images =
                                      value

                                });print("images....$_profileImage");
                              });
                            }
                          });
                        },
                        child: Icon(
                          Icons.account_circle_rounded,
                          size: height * .15,
                          color: ThemeApp.darkGreyTab,
                        ),
                      ))),
            ],
          ),
        );
      }),
    );
  }
  String images='';
  Future<String> getBase64Image(PickedFile img) async {
    List<int> imageBytes = await File(img.path).readAsBytesSync();
    String img64 = base64Encode(imageBytes);
    // print(img.path);
    // print(img64);
    return img64;
  }
}
