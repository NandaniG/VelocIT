import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/utils.dart';

// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/repository/auth_repository.dart';
import 'package:velocit/services/models/userAccountDetailModel.dart';
import 'package:velocit/utils/routes/routes.dart';

import '../../../../Core/Model/userModel.dart';
import '../../../../services/models/FilterModel.dart';
import '../../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/proceedButtons.dart';
import '../../../../widgets/global/textFormFields.dart';
import '../Saved_address/ProfileImageDialog.dart';
import 'OTP_verification_Popup.dart';
import 'package:velocit/utils/StringUtils.dart';

class EditAccountActivity extends StatefulWidget {
  // final Payload? payload;

  EditAccountActivity({
    Key? key,
    /*this.payload*/
  }) : super(key: key);

  @override
  State<EditAccountActivity> createState() => _EditAccountActivityState();
}

class _EditAccountActivityState extends State<EditAccountActivity> {
  double height = 0.0;
  double width = 0.0;
  final picker = ImagePicker();
  late File _profileImage;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  TextEditingController userNameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  bool _validateFullName = false;
  bool _validateMobile = false;
  bool _validateEmail = false;

  @override
  void initState() {
    // TODO: implement initState

    // getPrefValue();
    getUserData();
    super.initState();
  }

  // getPrefValue() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   bool check = prefs.containsKey('userProfileImagePrefs');
  //   if (check) {
  //     setState(() {
  //       print("yes/./././.");
  //       StringConstant.ProfilePhoto =
  //           prefs.getString('userProfileImagePrefs') ?? "";
  //     });
  //     return;
  //   }
  // }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
      StringConstant.userProfileName =
          prefs.getString('userProfileNamePrefs') ?? "";
      StringConstant.userProfileEmail =
          prefs.getString('userProfileEmailPrefs') ?? "";
      StringConstant.userProfileMobile =
          prefs.getString('userProfileMobilePrefs') ?? "";
      StringConstant.ProfilePhoto =
          prefs.getString('userProfileImagePrefs') ?? "";
      userNameController =
          TextEditingController(text: StringConstant.userProfileName);
      mobileController =
          TextEditingController(text: StringConstant.userProfileMobile);
      emailController =
          TextEditingController(text: StringConstant.userProfileEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeApp.appBackgroundColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.myAccountRoute);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: ThemeApp.blackColor,
            ),
          ),
        ),
        title: TextFieldUtils().dynamicText(
            'Edit my Account',
            context,
            TextStyle(
                fontFamily: 'Roboto',
                color: ThemeApp.blackColor,
                // fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.height * .022,
                fontWeight: FontWeight.w500)),
      ),
      body: SafeArea(
          child: ListView(
        children: [mainUI()],
      )),
    );
  }

  Widget mainUI() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: ThemeApp.whiteColor,
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StringConstant.ProfilePhoto.isNotEmpty
                ? Stack(
                    // alignment: Alignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 110.0,
                          height: 110.0,
                          decoration: new BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: ThemeApp.appLightColor,
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ],
                            border: Border.all(
                                color: ThemeApp.whiteColor, width: 4),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Image.network(
                              StringConstant.ProfilePhoto.toString()!,
                              fit: BoxFit.fitWidth,
                              width: 90.0,
                              height: 90.0,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image,
                                  color: ThemeApp.whiteColor,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: width / 2.7,
                        // width: 130.0,

                        // height: 40.0,
                        child: InkWell(
                            onTap: () {
                              // _getFromCamera();

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ProfileImageDialog(
                                        isEditAccount: true);
                                  });
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ThemeApp.appColor),
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: SvgPicture.asset(
                                  'assets/appImages/cameraIcon.svg',
                                  color: ThemeApp.whiteColor,
                                  semanticsLabel: 'Acme Logo',

                                  // height: height * .03,
                                ),
                              ),
                            )),
                      ),
                    ],
                  )
                : Stack(
                    // alignment: Alignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 110.0,
                          height: 110.0,
                          decoration: new BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: ThemeApp.appBackgroundColor,
                                  spreadRadius: 1,
                                  blurRadius: 15)
                            ],
                            color: ThemeApp.appBackgroundColor,
                            border: Border.all(
                                color: ThemeApp.whiteColor, width: 7),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Image.file(
                              File(StringConstant.ProfilePhoto),
                              fit: BoxFit.fitWidth,
                              width: 110.0,
                              height: 110.0,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image,
                                  color: ThemeApp.whiteColor,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: width / 2.7,
                        // width: 130.0,

                        // height: 40.0,
                        child: InkWell(
                            onTap: () {
                              // _getFromCamera();

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ProfileImageDialog(
                                        isEditAccount: true);
                                  });
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ThemeApp.appColor),
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: SvgPicture.asset(
                                  'assets/appImages/cameraIcon.svg',
                                  color: ThemeApp.whiteColor,
                                  semanticsLabel: 'Acme Logo',

                                  // height: height * .03,
                                ),
                              ),
                            )
                            /*; Container(
                                            // alignment: Alignment.bottomCenter,
                                            color: ThemeApp.primaryNavyBlackColor,
                                            alignment: const Alignment(-2, -0.1),
                                            child: iconsUtils(
                                                'assets/appImages/editIcon.svg'),
                                          ),*/
                            ),
                      ),
                    ],
                  ),
            /*     imageFile1 != null
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          // height: 50,width:50,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () async {
                              _getFromCamera();
                            },
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              child: Image.file(
                                imageFile1!,
                                fit: BoxFit.fill,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                        ))
                    : Align(
                        alignment: Alignment.center,
                        child: Container(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () async {
                                _getFromCamera();
                              },
                              child: Icon(
                                Icons.account_circle_rounded,
                                size: height * .15,
                                color: ThemeApp.backgroundColor,
                              ),
                            ))),*/
            SizedBox(
              height: height * .03,
            ),
            TextFieldUtils().asteriskTextField(
              StringUtils.fullName,
              context,
            ),
            CharacterTextFormFieldsWidget(
                // isEnable: true,
                errorText: StringUtils.enterFullName,
                textInputType: TextInputType.name,
                controller: userNameController,
                autoValidation: AutovalidateMode.onUserInteraction,
                intialvalue: 'Testing Name',
                hintText: 'Full Name',
                onChange: (val) {
                  setState(() {
                    if (val.isEmpty && userNameController.text.isEmpty) {
                      _validateFullName = true;
                    } else {
                      _validateFullName = false;
                    }
                  });
                },
                validator: (value) {
                  if (value.isEmpty && userNameController.text.isEmpty) {
                    _validateFullName = true;
                    return StringUtils.validUserNameError;
                  } else {
                    _validateFullName = false;
                  }
                  return null;
                }),
            SizedBox(
              height: height * .02,
            ),
            Text(
              StringUtils.emailAddress,
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ThemeApp.primaryNavyBlackColor,
              ),
            ),
            EmailTextFormFieldsWidget(
                enabled: false,
                errorText: StringUtils.validEmailError,
                textInputType: TextInputType.emailAddress,
                controller: emailController,
                autoValidation: AutovalidateMode.onUserInteraction,
                hintText: '',
                onChange: (val) {},
                validator: (val) {
                  return null;
                }),
            SizedBox(
              height: height * .02,
            ),
            Text(
              StringUtils.mobileNumber,
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ThemeApp.primaryNavyBlackColor,
              ),
            ),
            MobileNumberTextFormField(
                controller: mobileController,
                enable: false,
                onChanged: (phone) {
                  print(phone.completeNumber);
                  if (phone.countryCode == "IN") {
                    print("india selected");
                    print(phone.completeNumber);
                  } else {
                    print("india not selected");
                  }
                },
                validator: (value) {
                  return null;
                }),
            SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ThemeApp.appColor),
                  color: ThemeApp.appBackgroundColor),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "In order to prevent unauthorized access of personal information, request you to contact admin for changing the registered mobile number and email address.",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ThemeApp.appColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * .03,
            ),
            updateButton(),
            SizedBox(
              height: height * .02,
            ),
          ],
        ),
      ),
    );
  }

  Widget updateButton() {
    return proceedButton(
        StringUtils.update, ThemeApp.tealButtonColor, context, false, () {
      FocusManager.instance.primaryFocus?.unfocus();
      Map data = {
        "username": userNameController.text,
      };
      AuthRepository().editUserInfoApi(data, StringConstant.UserLoginId);
    });
  }

  Widget accountTextList(String text) {
    return TextFieldUtils().dynamicText(
        text,
        context,
        TextStyle(
            fontFamily: 'Roboto',
            color: ThemeApp.blackColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: -0.25));
  }

  // Widget bottomSheetForImagePicker() {
  //   return SingleChildScrollView(
  //     child: Container(
  //       padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
  //       decoration: const BoxDecoration(
  //           color: ThemeApp.whiteColor,
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20.0),
  //               topRight: Radius.circular(20.0))),
  //       // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           accountTextList('Change Profile Photo'),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Row(
  //             children: [
  //               InkWell(
  //                 onTap: () async {
  //                   // final prefs = await SharedPreferences.getInstance();
  //                   //
  //                   // FilePickerResult? pickedFile =
  //                   // await FilePicker.platform.pickFiles();
  //                   // if (pickedFile != null) {
  //                   //   String? filePath = pickedFile.files.single.path;
  //                   //   if (filePath != null) {
  //                   //     final file = File(filePath);
  //                   //     await prefs.setString('profileImagePrefs', filePath);
  //                   //
  //                   //     imageFile1 = file;
  //                   //     Navigator.of(context).pushReplacement(
  //                   //       MaterialPageRoute(
  //                   //         builder: (context) =>  EditAccountActivity(),
  //                   //       ),
  //                   //     );
  //                   //   }
  //                   // }
  //
  //                   final prefs = await SharedPreferences.getInstance();
  //
  //                   final pickedFile = await picker.getImage(
  //                     source: ImageSource.gallery,
  //                   );
  //                   print(pickedFile!.path.toString());
  //                   if (pickedFile != null) {
  //                     await prefs.setString(
  //                         'userProfileImagePrefs', pickedFile.path);
  //                     await prefs.setString(
  //                         'profileImagePrefs', pickedFile.path);
  //                     StringConstant.UserLoginId =
  //                         (prefs.getString('isUserId')) ?? '';
  //
  //                     AuthRepository().updateProfileImageApi(
  //                         File(pickedFile.path),
  //                         StringConstant.UserLoginId,
  //                         context);
  //
  //                     Navigator.of(context).pushReplacement(
  //                       MaterialPageRoute(
  //                         builder: (context) => EditAccountActivity(),
  //                       ),
  //                     );
  //                   }
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: ThemeApp.lightBorderColor,
  //                     borderRadius: BorderRadius.all(Radius.circular(8)),
  //                     // border: Border.all(color: ThemeApp.lightBorderColor)
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20),
  //                     child: SvgPicture.asset(
  //                       'assets/appImages/imageIcon.svg',
  //                       color: ThemeApp.subIconColor,
  //                       semanticsLabel: 'Acme Logo',
  //                       height: 37,
  //                       // height: height * .03,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               InkWell(
  //                 onTap: () async {
  //                   // var image =
  //                   // await picker.getImage(source: ImageSource.camera);
  //                   // final prefs = await SharedPreferences.getInstance();
  //                   // // StringConstant.CurrentPinCode = (prefs.getString('CurrentPinCodePref') ?? '');
  //                   // String imagePath = image!.path;
  //                   //
  //                   // await prefs.setString('profileImagePrefs', imagePath);
  //                   // Map data = {
  //                   //   "imgUrl": image.path,
  //                   // };
  //                   //
  //                   // setState(() {
  //                   //   imageFile1 = File(image.path);
  //                   //   Navigator.of(context).pushReplacement(
  //                   //     MaterialPageRoute(
  //                   //       builder: (context) =>  EditAccountActivity(),
  //                   //     ),
  //                   //   );
  //                   // });
  //
  //                   var image =
  //                       await picker.getImage(source: ImageSource.camera);
  //                   final prefs = await SharedPreferences.getInstance();
  //                   String imagePath = image!.path;
  //                   await prefs.setString('profileImagePrefs', imagePath);
  //                   StringConstant.UserLoginId =
  //                       (prefs.getString('isUserId')) ?? '';
  //                   await prefs.setString('userProfileImagePrefs', imagePath);
  //
  //                   AuthRepository().updateProfileImageApi(
  //                       File(image.path), StringConstant.UserLoginId, context);
  //
  //                   Navigator.of(context).pushReplacement(
  //                     MaterialPageRoute(
  //                       builder: (context) => EditAccountActivity(),
  //                     ),
  //                   );
  //                 },
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     color: ThemeApp.lightBorderColor,
  //                     borderRadius: BorderRadius.all(Radius.circular(8)),
  //                     // border: Border.all(color: ThemeApp.lightBorderColor)
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20),
  //                     child: SvgPicture.asset(
  //                       'assets/appImages/cameraIconGrey.svg',
  //                       color: ThemeApp.subIconColor,
  //                       semanticsLabel: 'Acme Logo',
  //                       height: 37,
  //                       // height: height * .03,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
